/*	$NetBSD: ugen.c,v 1.27 1999/10/28 12:08:38 augustss Exp $	*/
/*	$FreeBSD$	*/

/*
 * Copyright (c) 1998 The NetBSD Foundation, Inc.
 * All rights reserved.
 *
 * This code is derived from software contributed to The NetBSD Foundation
 * by Lennart Augustsson (lennart@augustsson.net) at
 * Carlstedt Research & Technology.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *        This product includes software developed by the NetBSD
 *        Foundation, Inc. and its contributors.
 * 4. Neither the name of The NetBSD Foundation nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


#include <sys/param.h>
#include <sys/systm.h>
#include <sys/kernel.h>
#include <sys/malloc.h>
#if defined(__NetBSD__) || defined(__OpenBSD__)
#include <sys/device.h>
#include <sys/ioctl.h>
#elif defined(__FreeBSD__)
#include <sys/module.h>
#include <sys/bus.h>
#include <sys/ioccom.h>
#include <sys/conf.h>
#include <sys/fcntl.h>
#include <sys/filio.h>
#endif
#include <sys/tty.h>
#include <sys/file.h>
#include <sys/select.h>
#include <sys/proc.h>
#include <sys/vnode.h>
#include <sys/poll.h>

#include <dev/usb/usb.h>
#include <dev/usb/usbdi.h>
#include <dev/usb/usbdi_util.h>

#ifdef UGEN_DEBUG
#define DPRINTF(x)	if (ugendebug) logprintf x
#define DPRINTFN(n,x)	if (ugendebug>(n)) logprintf x
int	ugendebug = 10;
#else
#define DPRINTF(x)
#define DPRINTFN(n,x)
#endif

struct ugen_endpoint {
	struct ugen_softc *sc;
	usb_endpoint_descriptor_t *edesc;
	usbd_interface_handle iface;
	int state;
#define	UGEN_ASLP	0x02	/* waiting for data */
#define UGEN_SHORT_OK	0x04	/* short xfers are OK */
	usbd_pipe_handle pipeh;
	struct clist q;
	struct selinfo rsel;
	void *ibuf;
	u_int32_t timeout;
};

#define	UGEN_CHUNK	128	/* chunk size for read */
#define	UGEN_IBSIZE	1020	/* buffer size */
#define	UGEN_BBSIZE	1024

struct ugen_softc {
	USBBASEDEVICE sc_dev;		/* base device */
	usbd_device_handle sc_udev;

	char sc_is_open[USB_MAX_ENDPOINTS];
	struct ugen_endpoint sc_endpoints[USB_MAX_ENDPOINTS][2];
#define OUT 0
#define IN  1

	int sc_refcnt;
	u_char sc_dying;
};

#if defined(__NetBSD__) || defined(__OpenBSD__)
cdev_decl(ugen);
#elif defined(__FreeBSD__)
d_open_t  ugenopen;
d_close_t ugenclose;
d_read_t  ugenread;
d_write_t ugenwrite;
d_ioctl_t ugenioctl;
d_poll_t  ugenpoll;

#define UGEN_CDEV_MAJOR	114

Static struct cdevsw ugen_cdevsw = {
	/* open */	ugenopen,
	/* close */	ugenclose,
	/* read */	ugenread,
	/* write */	ugenwrite,
	/* ioctl */	ugenioctl,
	/* poll */	ugenpoll,
	/* mmap */	nommap,
	/* strategy */	nostrategy,
	/* name */	"ugen",
	/* maj */	UGEN_CDEV_MAJOR,
	/* dump */	nodump,
	/* psize */	nopsize,
	/* flags */	0,
	/* bmaj */	-1
};
#endif

Static void ugenintr __P((usbd_xfer_handle xfer, usbd_private_handle addr, 
			  usbd_status status));

Static int ugen_do_read __P((struct ugen_softc *, int, struct uio *, int));
Static int ugen_do_write __P((struct ugen_softc *, int, struct uio *, int));
Static int ugen_do_ioctl __P((struct ugen_softc *, int, u_long, 
			      caddr_t, int, struct proc *));
Static int ugen_set_config __P((struct ugen_softc *sc, int configno));
Static usb_config_descriptor_t *ugen_get_cdesc __P((struct ugen_softc *sc,
						    int index, int *lenp));
Static usbd_status ugen_set_interface __P((struct ugen_softc *, int, int));
Static int ugen_get_alt_index __P((struct ugen_softc *sc, int ifaceidx));

#define UGENUNIT(n) ((minor(n) >> 4) & 0xf)
#define UGENENDPOINT(n) (minor(n) & 0xf)
#define UGENMINOR(u, e) (((u) << 4) | (e))

USB_DECLARE_DRIVER(ugen);

USB_MATCH(ugen)
{
	USB_MATCH_START(ugen, uaa);

	if (uaa->usegeneric)
		return (UMATCH_GENERIC);
	else
		return (UMATCH_NONE);
}

USB_ATTACH(ugen)
{
	USB_ATTACH_START(ugen, sc, uaa);
	char devinfo[1024];
	usbd_status err;
	int conf;
	
	usbd_devinfo(uaa->device, 0, devinfo);
	USB_ATTACH_SETUP;
	printf("%s: %s\n", USBDEVNAME(sc->sc_dev), devinfo);

	sc->sc_udev = uaa->device;
	conf = 1;		/* XXX should not hard code 1 */
	err = ugen_set_config(sc, conf);
	if (err) {
		printf("%s: setting configuration %d failed\n", 
		       USBDEVNAME(sc->sc_dev), conf);
		sc->sc_dying = 1;
		USB_ATTACH_ERROR_RETURN;
	}

	USB_ATTACH_SUCCESS_RETURN;
}

Static int
ugen_set_config(sc, configno)
	struct ugen_softc *sc;
	int configno;
{
	usbd_device_handle dev = sc->sc_udev;
	usbd_interface_handle iface;
	usb_endpoint_descriptor_t *ed;
	struct ugen_endpoint *sce;
	u_int8_t niface, nendpt;
	int ifaceno, endptno, endpt;
	usbd_status err;
	int dir;

	DPRINTFN(1,("ugen_set_config: %s to configno %d, sc=%p\n",
		    USBDEVNAME(sc->sc_dev), configno, sc));

	/* We start at 1, not 0, because we don't care whether the
	 * control endpoint is open or not. It is always present.
	 */
	for (endptno = 1; endptno < USB_MAX_ENDPOINTS; endptno++)
		if (sc->sc_is_open[endptno]) {
			DPRINTFN(1,
			     ("ugen_set_config: %s - endpoint %d is open\n",
			      USBDEVNAME(sc->sc_dev), endptno));
			return (USBD_IN_USE);
		}

	if (usbd_get_config_descriptor(dev)->bConfigurationValue != configno) {
		/* Avoid setting the current value. */
		err = usbd_set_config_no(dev, configno, 0);
		if (err)
			return (err);
	}

	err = usbd_interface_count(dev, &niface);
	if (err)
		return (err);
	memset(sc->sc_endpoints, 0, sizeof sc->sc_endpoints);
	for (ifaceno = 0; ifaceno < niface; ifaceno++) {
		DPRINTFN(1,("ugen_set_config: ifaceno %d\n", ifaceno));
		err = usbd_device2interface_handle(dev, ifaceno, &iface);
		if (err)
			return (err);
		err = usbd_endpoint_count(iface, &nendpt);
		if (err)
			return (err);
		for (endptno = 0; endptno < nendpt; endptno++) {
			ed = usbd_interface2endpoint_descriptor(iface,endptno);
			endpt = UE_GET_ADDR(ed->bEndpointAddress);
			dir = UE_GET_DIR(ed->bEndpointAddress) == UE_DIR_IN?
					IN : OUT;

			sce = &sc->sc_endpoints[endpt][dir];
			DPRINTFN(1,("ugen_set_config: endptno %d, endpt=0x%02x"
				    "(%d,%d), sce=%p\n", 
				    endptno, endpt, endpt, dir, sce));

			sce->sc = sc;
			sce->edesc = ed;
			sce->iface = iface;
		}
	}


#if defined(__FreeBSD__)
	/* the main device, ctrl endpoint */
	make_dev(&ugen_cdevsw, UGENMINOR(USBDEVUNIT(sc->sc_dev), 0),
		UID_ROOT, GID_OPERATOR, 0644, "%s", USBDEVNAME(sc->sc_dev));

	for (endptno = 1; endptno < USB_MAX_ENDPOINTS; endptno++) {
		if (sc->sc_endpoints[endptno][IN].sc != NULL ||
		    sc->sc_endpoints[endptno][OUT].sc != NULL ) {
			/* endpt can be 0x81 and 0x01, representing
			 * endpoint address 0x01 and IN/OUT directions.
			 * We map both endpts to the same device,
			 * IN is reading from it, OUT is writing to it.
			 *
			 * In the if clause above we check whether one
			 * of the structs is populated.
			 */
			make_dev(&ugen_cdevsw,
				UGENMINOR(USBDEVUNIT(sc->sc_dev), endptno),
				UID_ROOT, GID_OPERATOR, 0644,
				"%s.%d",
				USBDEVNAME(sc->sc_dev), endptno);
		}
	}
#endif

	return (USBD_NORMAL_COMPLETION);
}

int
ugenopen(dev, flag, mode, p)
	dev_t dev;
	int flag;
	int mode;
	struct proc *p;
{
	struct ugen_softc *sc;
	int unit = UGENUNIT(dev);
	int endpt = UGENENDPOINT(dev);
	usb_endpoint_descriptor_t *edesc;
	struct ugen_endpoint *sce;
	int dir, isize;
	usbd_status err;

	USB_GET_SC_OPEN(ugen, unit, sc);

 	DPRINTFN(5, ("ugenopen: flag=%d, mode=%d, unit=%d endpt=%d\n", 
		     flag, mode, unit, endpt));

	if (sc == NULL || sc->sc_dying)
		return (ENXIO);

	if (sc->sc_is_open[endpt])
		return (EBUSY);

	if (endpt == USB_CONTROL_ENDPOINT) {
		sc->sc_is_open[USB_CONTROL_ENDPOINT] = 1;
		return (0);
	}
	/* Make sure there are pipes for all directions. */
	for (dir = OUT; dir <= IN; dir++) {
		if (flag & (dir == OUT ? FWRITE : FREAD)) {
			sce = &sc->sc_endpoints[endpt][dir];
			if (sce == 0 || sce->edesc == 0)
				return (ENXIO);
		}
	}

	/* Actually open the pipes. */
	/* XXX Should back out properly if it fails. */
	for (dir = OUT; dir <= IN; dir++) {
		if (!(flag & (dir == OUT ? FWRITE : FREAD)))
			continue;
		sce = &sc->sc_endpoints[endpt][dir];
		sce->state = 0;
		sce->timeout = USBD_NO_TIMEOUT;
		DPRINTFN(5, ("ugenopen: sc=%p, endpt=%d, dir=%d, sce=%p\n", 
			     sc, endpt, dir, sce));
		edesc = sce->edesc;
		switch (edesc->bmAttributes & UE_XFERTYPE) {
		case UE_INTERRUPT:
			isize = UGETW(edesc->wMaxPacketSize);
			if (isize == 0)	/* shouldn't happen */
				return (EINVAL);
			sce->ibuf = malloc(isize, M_USBDEV, M_WAITOK);
			DPRINTFN(5, ("ugenopen: intr endpt=%d,isize=%d\n", 
				     endpt, isize));
			if (clalloc(&sce->q, UGEN_IBSIZE, 0) == -1)
				return (ENOMEM);
			err = usbd_open_pipe_intr(sce->iface, 
				edesc->bEndpointAddress, 
				USBD_SHORT_XFER_OK, &sce->pipeh, sce, 
				sce->ibuf, isize, ugenintr,
				USBD_DEFAULT_INTERVAL);
			if (err) {
				free(sce->ibuf, M_USBDEV);
				clfree(&sce->q);
				return (EIO);
			}
			DPRINTFN(5, ("ugenopen: interrupt open done\n"));
			break;
		case UE_BULK:
			err = usbd_open_pipe(sce->iface, 
				  edesc->bEndpointAddress, 0, &sce->pipeh);
			if (err)
				return (EIO);
			break;
		case UE_CONTROL:
		case UE_ISOCHRONOUS:
			return (EINVAL);
		}
	}
	sc->sc_is_open[endpt] = 1;
	return (0);
}

int
ugenclose(dev, flag, mode, p)
	dev_t dev;
	int flag;
	int mode;
	struct proc *p;
{
	int endpt = UGENENDPOINT(dev);
	struct ugen_softc *sc;
	struct ugen_endpoint *sce;
	int dir;

	USB_GET_SC(ugen, UGENUNIT(dev), sc);

	DPRINTFN(5, ("ugenclose: flag=%d, mode=%d, unit=%d, endpt=%d\n",
		     flag, mode, UGENUNIT(dev), endpt));

#ifdef DIAGNOSTIC
	if (!sc->sc_is_open[endpt]) {
		printf("ugenclose: not open\n");
		return (EINVAL);
	}
#endif

	if (endpt == USB_CONTROL_ENDPOINT) {
		DPRINTFN(5, ("ugenclose: close control\n"));
		sc->sc_is_open[endpt] = 0;
		return (0);
	}

	for (dir = OUT; dir <= IN; dir++) {
		if (!(flag & (dir == OUT ? FWRITE : FREAD)))
			continue;
		sce = &sc->sc_endpoints[endpt][dir];
		if (sce == NULL || sce->pipeh == NULL)
			continue;
		DPRINTFN(5, ("ugenclose: endpt=%d dir=%d sce=%p\n", 
			     endpt, dir, sce));
		
		usbd_abort_pipe(sce->pipeh);
		usbd_close_pipe(sce->pipeh);
		sce->pipeh = NULL;
		
		if (sce->ibuf != NULL) {
			free(sce->ibuf, M_USBDEV);
			sce->ibuf = NULL;
			ndflush(&sce->q, sce->q.c_cc);
			clfree(&sce->q);

		}
	}
	sc->sc_is_open[endpt] = 0;

	return (0);
}

Static int
ugen_do_read(sc, endpt, uio, flag)
	struct ugen_softc *sc;
	int endpt;
	struct uio *uio;
	int flag;
{
	struct ugen_endpoint *sce = &sc->sc_endpoints[endpt][IN];
	u_int32_t n, tn;
	char buf[UGEN_BBSIZE];
	usbd_xfer_handle xfer;
	usbd_status err;
	int s;
	int error = 0;
	u_char buffer[UGEN_CHUNK];

	DPRINTFN(5, ("%s: ugenread: %d\n", USBDEVNAME(sc->sc_dev), endpt));

	if (sc->sc_dying)
		return (EIO);

	if (endpt == USB_CONTROL_ENDPOINT)
		return (ENODEV);

#ifdef DIAGNOSTIC
	if (sce->edesc == NULL) {
		printf("ugenread: no edesc\n");
		return (EIO);
	}
	if (sce->pipeh == NULL) {
		printf("ugenread: no pipe\n");
		return (EIO);
	}
#endif

	switch (sce->edesc->bmAttributes & UE_XFERTYPE) {
	case UE_INTERRUPT:
		/* Block until activity occured. */
		s = splusb();
		while (sce->q.c_cc == 0) {
			if (flag & IO_NDELAY) {
				splx(s);
				return (EWOULDBLOCK);
			}
			sce->state |= UGEN_ASLP;
			DPRINTFN(5, ("ugenread: sleep on %p\n", sc));
			error = tsleep(sce, PZERO | PCATCH, "ugenri", 0);
			DPRINTFN(5, ("ugenread: woke, error=%d\n", error));
			if (sc->sc_dying)
				error = EIO;
			if (error) {
				sce->state &= ~UGEN_ASLP;
				break;
			}
		}
		splx(s);

		/* Transfer as many chunks as possible. */
		while (sce->q.c_cc > 0 && uio->uio_resid > 0 && !error) {
			n = min(sce->q.c_cc, uio->uio_resid);
			if (n > sizeof(buffer))
				n = sizeof(buffer);

			/* Remove a small chunk from the input queue. */
			q_to_b(&sce->q, buffer, n);
			DPRINTFN(5, ("ugenread: got %d chars\n", n));

			/* Copy the data to the user process. */
			error = uiomove(buffer, n, uio);
			if (error)
				break;
		}
		break;
	case UE_BULK:
		xfer = usbd_alloc_xfer(sc->sc_udev);
		if (xfer == 0)
			return (ENOMEM);
		while ((n = min(UGEN_BBSIZE, uio->uio_resid)) != 0) {
			DPRINTFN(1, ("ugenread: start transfer %d bytes\n",n));
			tn = n;
			err = usbd_bulk_transfer(
				xfer, sce->pipeh,
				sce->state & UGEN_SHORT_OK ? 
				    USBD_SHORT_XFER_OK : 0, 
				sce->timeout, buf, &tn, "ugenrb");
			if (err) {
				if (err == USBD_INTERRUPTED)
					error = EINTR;
				else if (err == USBD_TIMEOUT)
					error = ETIMEDOUT;
				else
					error = EIO;
				break;
			}
			DPRINTFN(1, ("ugenread: got %d bytes\n", tn));
			error = uiomove(buf, tn, uio);
			if (error || tn < n)
				break;
		}
		usbd_free_xfer(xfer);
		break;
	default:
		return (ENXIO);
	}
	return (error);
}

int
ugenread(dev, uio, flag)
	dev_t dev;
	struct uio *uio;
	int flag;
{
	int endpt = UGENENDPOINT(dev);
	struct ugen_softc *sc;
	int error;

	USB_GET_SC(ugen, UGENUNIT(dev), sc);

	sc->sc_refcnt++;
	error = ugen_do_read(sc, endpt, uio, flag);
	if (--sc->sc_refcnt < 0)
		usb_detach_wakeup(USBDEV(sc->sc_dev));
	return (error);
}

Static int
ugen_do_write(sc, endpt, uio, flag)
	struct ugen_softc *sc;
	int endpt;
	struct uio *uio;
	int flag;
{
	struct ugen_endpoint *sce = &sc->sc_endpoints[endpt][OUT];
	u_int32_t n;
	int error = 0;
	char buf[UGEN_BBSIZE];
	usbd_xfer_handle xfer;
	usbd_status err;

	DPRINTFN(5, ("%s: ugen_do_write: %d\n", USBDEVNAME(sc->sc_dev), endpt));

	if (sc->sc_dying)
		return (EIO);

	if (endpt == USB_CONTROL_ENDPOINT)
		return (ENODEV);

#ifdef DIAGNOSTIC
	if (sce->edesc == NULL) {
		printf("ugen_do_write: no edesc\n");
		return (EIO);
	}
	if (sce->pipeh == NULL) {
		printf("ugen_do_write: no pipe\n");
		return (EIO);
	}
#endif

	switch (sce->edesc->bmAttributes & UE_XFERTYPE) {
	case UE_BULK:
		xfer = usbd_alloc_xfer(sc->sc_udev);
		if (xfer == 0)
			return (EIO);
		while ((n = min(UGEN_BBSIZE, uio->uio_resid)) != 0) {
			error = uiomove(buf, n, uio);
			if (error)
				break;
			DPRINTFN(1, ("ugen_do_write: transfer %d bytes\n", n));
			err = usbd_bulk_transfer(xfer, sce->pipeh, 0, 
				  sce->timeout, buf, &n,"ugenwb");
			if (err) {
				if (err == USBD_INTERRUPTED)
					error = EINTR;
				else
					error = EIO;
				break;
			}
		}
		usbd_free_xfer(xfer);
		break;
	default:
		return (ENXIO);
	}
	return (error);
}

int
ugenwrite(dev, uio, flag)
	dev_t dev;
	struct uio *uio;
	int flag;
{
	int endpt = UGENENDPOINT(dev);
	struct ugen_softc *sc;
	int error;

	USB_GET_SC(ugen, UGENUNIT(dev), sc);

	sc->sc_refcnt++;
	error = ugen_do_write(sc, endpt, uio, flag);
	if (--sc->sc_refcnt < 0)
		usb_detach_wakeup(USBDEV(sc->sc_dev));
	return (error);
}

#if defined(__NetBSD__) || defined(__OpenBSD__)
int
ugen_activate(self, act)
	device_ptr_t self;
	enum devact act;
{
	struct ugen_softc *sc = (struct ugen_softc *)self;

	switch (act) {
	case DVACT_ACTIVATE:
		return (EOPNOTSUPP);
		break;

	case DVACT_DEACTIVATE:
		sc->sc_dying = 1;
		break;
	}
	return (0);
}
#endif

USB_DETACH(ugen)
{
	USB_DETACH_START(ugen, sc);
	struct ugen_endpoint *sce;
	int i, dir;
	int s;
#if defined(__NetBSD__) || defined(__OpenBSD__)
	int maj, mn;
#elif defined(__FreeBSD__)
	int endptno;
	dev_t dev;
	struct vnode *vp;
#endif

#if defined(__NetBSD__) || defined(__OpenBSD__)
	DPRINTF(("ugen_detach: sc=%p flags=%d\n", sc, flags));
#elif defined(__FreeBSD__)
	DPRINTF(("ugen_detach: sc=%p\n", sc));
#endif

	sc->sc_dying = 1;
	/* Abort all pipes.  Causes processes waiting for transfer to wake. */
	for (i = 0; i < USB_MAX_ENDPOINTS; i++) {
		for (dir = OUT; dir <= IN; dir++) {
			sce = &sc->sc_endpoints[i][dir];
			if (sce && sce->pipeh)
				usbd_abort_pipe(sce->pipeh);
		}
	}

	s = splusb();
	if (--sc->sc_refcnt >= 0) {
		/* Wake everyone */
		for (i = 0; i < USB_MAX_ENDPOINTS; i++)
			wakeup(&sc->sc_endpoints[i][IN]);
		/* Wait for processes to go away. */
		usb_detach_wait(USBDEV(sc->sc_dev));
	}
	splx(s);

#if defined(__NetBSD__) || defined(__OpenBSD__)
	/* locate the major number */
	for (maj = 0; maj < nchrdev; maj++)
		if (cdevsw[maj].d_open == ugenopen)
			break;

	/* Nuke the vnodes for any open instances (calls close). */
	mn = self->dv_unit * USB_MAX_ENDPOINTS;
	vdevgone(maj, mn, mn + USB_MAX_ENDPOINTS - 1, VCHR);
#elif defined(__FreeBSD__)
	/* destroy the device for the control endpoint */
	dev = makedev(UGEN_CDEV_MAJOR, UGENMINOR(USBDEVUNIT(sc->sc_dev), 0));
	vp = SLIST_FIRST(&dev->si_hlist);
	if (vp)
		VOP_REVOKE(vp, REVOKEALL);
	destroy_dev(dev);

	/* destroy all devices for the other (existing) endpoints as well */
	for (endptno = 1; endptno < USB_MAX_ENDPOINTS; endptno++) {
		if (sc->sc_endpoints[endptno][IN].sc != NULL ||
		    sc->sc_endpoints[endptno][OUT].sc != NULL ) {
			/* endpt can be 0x81 and 0x01, representing
			 * endpoint address 0x01 and IN/OUT directions.
			 * We map both endpoint addresses to the same device,
			 * IN is reading from it, OUT is writing to it.
			 *
			 * In the if clause above we check whether one
			 * of the structs is populated.
			 */
			dev = makedev(UGEN_CDEV_MAJOR,
				UGENMINOR(USBDEVUNIT(sc->sc_dev), endptno));
			vp = SLIST_FIRST(&dev->si_hlist);
			if (vp)
				VOP_REVOKE(vp, REVOKEALL);

			destroy_dev(dev);
		}
	}
#endif

	return (0);
}

Static void
ugenintr(xfer, addr, status)
	usbd_xfer_handle xfer;
	usbd_private_handle addr;
	usbd_status status;
{
	struct ugen_endpoint *sce = addr;
	/*struct ugen_softc *sc = sce->sc;*/
	u_int32_t count;
	u_char *ibuf;

	if (status == USBD_CANCELLED)
		return;

	if (status != USBD_NORMAL_COMPLETION) {
		DPRINTF(("ugenintr: status=%d\n", status));
		usbd_clear_endpoint_stall_async(sce->pipeh);
		return;
	}

	usbd_get_xfer_status(xfer, 0, 0, &count, 0);
	ibuf = sce->ibuf;

	DPRINTFN(5, ("ugenintr: xfer=%p status=%d count=%d\n", 
		     xfer, status, count));
	DPRINTFN(5, ("          data = %02x %02x %02x\n",
		     ibuf[0], ibuf[1], ibuf[2]));

	(void)b_to_q(ibuf, count, &sce->q);
		
	if (sce->state & UGEN_ASLP) {
		sce->state &= ~UGEN_ASLP;
		DPRINTFN(5, ("ugen_intr: waking %p\n", sce));
		wakeup(sce);
	}
	selwakeup(&sce->rsel);
}

Static usbd_status
ugen_set_interface(sc, ifaceidx, altno)
	struct ugen_softc *sc;
	int ifaceidx, altno;
{
	usbd_interface_handle iface;
	usb_endpoint_descriptor_t *ed;
	usbd_status err;
	struct ugen_endpoint *sce;
	u_int8_t niface, nendpt, endptno, endpt;
	int dir;

	DPRINTFN(15, ("ugen_set_interface %d %d\n", ifaceidx, altno));

	err = usbd_interface_count(sc->sc_udev, &niface);
	if (err)
		return (err);
	if (ifaceidx < 0 || ifaceidx >= niface)
		return (USBD_INVAL);
	
	err = usbd_device2interface_handle(sc->sc_udev, ifaceidx, &iface);
	if (err)
		return (err);
	err = usbd_endpoint_count(iface, &nendpt);
	if (err)
		return (err);
	for (endptno = 0; endptno < nendpt; endptno++) {
		ed = usbd_interface2endpoint_descriptor(iface,endptno);
		endpt = ed->bEndpointAddress;
		dir = UE_GET_DIR(endpt) == UE_DIR_IN ? IN : OUT;
		sce = &sc->sc_endpoints[UE_GET_ADDR(endpt)][dir];
		sce->sc = 0;
		sce->edesc = 0;
		sce->iface = 0;
	}

	/* change setting */
	err = usbd_set_interface(iface, altno);
	if (err)
		return (err);

	err = usbd_endpoint_count(iface, &nendpt);
	if (err)
		return (err);
	for (endptno = 0; endptno < nendpt; endptno++) {
		ed = usbd_interface2endpoint_descriptor(iface,endptno);
		endpt = ed->bEndpointAddress;
		dir = UE_GET_DIR(endpt) == UE_DIR_IN ? IN : OUT;
		sce = &sc->sc_endpoints[UE_GET_ADDR(endpt)][dir];
		sce->sc = sc;
		sce->edesc = ed;
		sce->iface = iface;
	}
	return (0);
}

/* Retrieve a complete descriptor for a certain device and index. */
Static usb_config_descriptor_t *
ugen_get_cdesc(sc, index, lenp)
	struct ugen_softc *sc;
	int index;
	int *lenp;
{
	usb_config_descriptor_t *cdesc, *tdesc, cdescr;
	int len;
	usbd_status err;

	if (index == USB_CURRENT_CONFIG_INDEX) {
		tdesc = usbd_get_config_descriptor(sc->sc_udev);
		len = UGETW(tdesc->wTotalLength);
		if (lenp)
			*lenp = len;
		cdesc = malloc(len, M_TEMP, M_WAITOK);
		memcpy(cdesc, tdesc, len);
		DPRINTFN(5,("ugen_get_cdesc: current, len=%d\n", len));
	} else {
		err = usbd_get_config_desc(sc->sc_udev, index, &cdescr);
		if (err)
			return (0);
		len = UGETW(cdescr.wTotalLength);
		DPRINTFN(5,("ugen_get_cdesc: index=%d, len=%d\n", index, len));
		if (lenp)
			*lenp = len;
		cdesc = malloc(len, M_TEMP, M_WAITOK);
		err = usbd_get_config_desc_full(sc->sc_udev, index, cdesc, len);
		if (err) {
			free(cdesc, M_TEMP);
			return (0);
		}
	}
	return (cdesc);
}

Static int
ugen_get_alt_index(sc, ifaceidx)
	struct ugen_softc *sc;
	int ifaceidx;
{
	usbd_interface_handle iface;
	usbd_status err;

	err = usbd_device2interface_handle(sc->sc_udev, ifaceidx, &iface);
	if (err)
			return (-1);
	return (usbd_get_interface_altindex(iface));
}

Static int
ugen_do_ioctl(sc, endpt, cmd, addr, flag, p)
	struct ugen_softc *sc;
	int endpt;
	u_long cmd;
	caddr_t addr; 
	int flag;
	struct proc *p;
{
	struct ugen_endpoint *sce;
	usbd_status err;
	usbd_interface_handle iface;
	struct usb_config_desc *cd;
	usb_config_descriptor_t *cdesc;
	struct usb_interface_desc *id;
	usb_interface_descriptor_t *idesc;
	struct usb_endpoint_desc *ed;
	usb_endpoint_descriptor_t *edesc;
	struct usb_alt_interface *ai;
	struct usb_string_desc *si;
	u_int8_t conf, alt;

	DPRINTFN(5, ("ugenioctl: cmd=%08lx\n", cmd));
	if (sc->sc_dying)
		return (EIO);

	switch (cmd) {
	case FIONBIO:
		/* All handled in the upper FS layer. */
		return (0);
	case USB_SET_SHORT_XFER:
		/* This flag only affects read */
		if (endpt == USB_CONTROL_ENDPOINT)
			return (EINVAL);
		sce = &sc->sc_endpoints[endpt][IN];
		if (sce == NULL)
			return (EINVAL);
#ifdef DIAGNOSTIC
		if (sce->pipeh == NULL) {
			printf("ugenioctl: USB_SET_SHORT_XFER, no pipe\n");
			return (EIO);
		}
#endif
		if (*(int *)addr)
			sce->state |= UGEN_SHORT_OK;
		else
			sce->state &= ~UGEN_SHORT_OK;
		return (0);
	case USB_SET_TIMEOUT:
		sce = &sc->sc_endpoints[endpt][IN];
		if (sce == NULL)
			return (EINVAL);
#ifdef DIAGNOSTIC
		if (sce->pipeh == NULL) {
			printf("ugenioctl: USB_SET_TIMEOUT, no pipe\n");
			return (EIO);
		}
#endif
		sce->timeout = *(int *)addr;
		return (0);
	default:
		break;
	}

	if (endpt != USB_CONTROL_ENDPOINT)
		return (EINVAL);

	switch (cmd) {
#ifdef UGEN_DEBUG
	case USB_SETDEBUG:
		ugendebug = *(int *)addr;
		break;
#endif
	case USB_GET_CONFIG:
		err = usbd_get_config(sc->sc_udev, &conf);
		if (err)
			return (EIO);
		*(int *)addr = conf;
		break;
	case USB_SET_CONFIG:
		if (!(flag & FWRITE))
			return (EPERM);
		err = ugen_set_config(sc, *(int *)addr);
		switch (err) {
		case USBD_NORMAL_COMPLETION:
			break;
		case USBD_IN_USE:
			return (EBUSY);
		default:
			return (EIO);
		}
		break;
	case USB_GET_ALTINTERFACE:
		ai = (struct usb_alt_interface *)addr;
		err = usbd_device2interface_handle(sc->sc_udev, 
			  ai->interface_index, &iface);
		if (err)
			return (EINVAL);
		idesc = usbd_get_interface_descriptor(iface);
		if (idesc == NULL)
			return (EIO);
		ai->alt_no = idesc->bAlternateSetting;
		break;
	case USB_SET_ALTINTERFACE:
		if (!(flag & FWRITE))
			return (EPERM);
		ai = (struct usb_alt_interface *)addr;
		err = usbd_device2interface_handle(sc->sc_udev, 
			  ai->interface_index, &iface);
		if (err)
			return (EINVAL);
		err = ugen_set_interface(sc, ai->interface_index, ai->alt_no);
		if (err)
			return (EINVAL);
		break;
	case USB_GET_NO_ALT:
		ai = (struct usb_alt_interface *)addr;
		cdesc = ugen_get_cdesc(sc, ai->config_index, 0);
		if (cdesc == NULL)
			return (EINVAL);
		idesc = usbd_find_idesc(cdesc, ai->interface_index, 0);
		if (idesc == NULL) {
			free(cdesc, M_TEMP);
			return (EINVAL);
		}
		ai->alt_no = usbd_get_no_alts(cdesc, idesc->bInterfaceNumber);
		free(cdesc, M_TEMP);
		break;
	case USB_GET_DEVICE_DESC:
		*(usb_device_descriptor_t *)addr =
			*usbd_get_device_descriptor(sc->sc_udev);
		break;
	case USB_GET_CONFIG_DESC:
		cd = (struct usb_config_desc *)addr;
		cdesc = ugen_get_cdesc(sc, cd->config_index, 0);
		if (cdesc == NULL)
			return (EINVAL);
		cd->desc = *cdesc;
		free(cdesc, M_TEMP);
		break;
	case USB_GET_INTERFACE_DESC:
		id = (struct usb_interface_desc *)addr;
		cdesc = ugen_get_cdesc(sc, id->config_index, 0);
		if (cdesc == NULL)
			return (EINVAL);
		if (id->config_index == USB_CURRENT_CONFIG_INDEX &&
		    id->alt_index == USB_CURRENT_ALT_INDEX)
			alt = ugen_get_alt_index(sc, id->interface_index);
		else
			alt = id->alt_index;
		idesc = usbd_find_idesc(cdesc, id->interface_index, alt);
		if (idesc == NULL) {
			free(cdesc, M_TEMP);
			return (EINVAL);
		}
		id->desc = *idesc;
		free(cdesc, M_TEMP);
		break;
	case USB_GET_ENDPOINT_DESC:
		ed = (struct usb_endpoint_desc *)addr;
		cdesc = ugen_get_cdesc(sc, ed->config_index, 0);
		if (cdesc == NULL)
			return (EINVAL);
		if (ed->config_index == USB_CURRENT_CONFIG_INDEX &&
		    ed->alt_index == USB_CURRENT_ALT_INDEX)
			alt = ugen_get_alt_index(sc, ed->interface_index);
		else
			alt = ed->alt_index;
		edesc = usbd_find_edesc(cdesc, ed->interface_index, 
					alt, ed->endpoint_index);
		if (edesc == NULL) {
			free(cdesc, M_TEMP);
			return (EINVAL);
		}
		ed->desc = *edesc;
		free(cdesc, M_TEMP);
		break;
	case USB_GET_FULL_DESC:
	{
		int len;
		struct iovec iov;
		struct uio uio;
		struct usb_full_desc *fd = (struct usb_full_desc *)addr;
		int error;

		cdesc = ugen_get_cdesc(sc, fd->config_index, &len);
		if (len > fd->size)
			len = fd->size;
		iov.iov_base = (caddr_t)fd->data;
		iov.iov_len = len;
		uio.uio_iov = &iov;
		uio.uio_iovcnt = 1;
		uio.uio_resid = len;
		uio.uio_offset = 0;
		uio.uio_segflg = UIO_USERSPACE;
		uio.uio_rw = UIO_READ;
		uio.uio_procp = p;
#if defined(__NetBSD__) || defined(__OpenBSD__)
		error = uiomove((caddr_t)cdesc, len, &uio);
#elif defined(__FreeBSD__)
		error = uiomove((void *)cdesc, len, &uio);
#endif
		free(cdesc, M_TEMP);
		return (error);
	}
	case USB_GET_STRING_DESC:
		si = (struct usb_string_desc *)addr;
		err = usbd_get_string_desc(sc->sc_udev, si->string_index, 
			  si->language_id, &si->desc);
		if (err)
			return (EINVAL);
		break;
	case USB_DO_REQUEST:
	{
		struct usb_ctl_request *ur = (void *)addr;
		int len = UGETW(ur->request.wLength);
		struct iovec iov;
		struct uio uio;
		void *ptr = 0;
		usbd_status err;
		int error = 0;

		if (!(flag & FWRITE))
			return (EPERM);
		/* Avoid requests that would damage the bus integrity. */
		if ((ur->request.bmRequestType == UT_WRITE_DEVICE &&
		     ur->request.bRequest == UR_SET_ADDRESS) ||
		    (ur->request.bmRequestType == UT_WRITE_DEVICE &&
		     ur->request.bRequest == UR_SET_CONFIG) ||
		    (ur->request.bmRequestType == UT_WRITE_INTERFACE &&
		     ur->request.bRequest == UR_SET_INTERFACE))
			return (EINVAL);

		if (len < 0 || len > 32767)
			return (EINVAL);
		if (len != 0) {
			iov.iov_base = (caddr_t)ur->data;
			iov.iov_len = len;
			uio.uio_iov = &iov;
			uio.uio_iovcnt = 1;
			uio.uio_resid = len;
			uio.uio_offset = 0;
			uio.uio_segflg = UIO_USERSPACE;
			uio.uio_rw =
				ur->request.bmRequestType & UT_READ ? 
				UIO_READ : UIO_WRITE;
			uio.uio_procp = p;
			ptr = malloc(len, M_TEMP, M_WAITOK);
			if (uio.uio_rw == UIO_WRITE) {
				error = uiomove(ptr, len, &uio);
				if (error)
					goto ret;
			}
		}
		err = usbd_do_request_flags(sc->sc_udev, &ur->request, 
			  ptr, ur->flags, &ur->actlen);
		if (err) {
			error = EIO;
			goto ret;
		}
		if (len != 0) {
			if (uio.uio_rw == UIO_READ) {
				error = uiomove(ptr, len, &uio);
				if (error)
					goto ret;
			}
		}
	ret:
		if (ptr)
			free(ptr, M_TEMP);
		return (error);
	}
	case USB_GET_DEVICEINFO:
		usbd_fill_deviceinfo(sc->sc_udev,
		    (struct usb_device_info *)addr);
		break;
	default:
		return (EINVAL);
	}
	return (0);
}

int
ugenioctl(dev, cmd, addr, flag, p)
	dev_t dev;
	u_long cmd;
	caddr_t addr; 
	int flag;
	struct proc *p;
{
	int endpt = UGENENDPOINT(dev);
	struct ugen_softc *sc;
	int error;

	USB_GET_SC(ugen, UGENUNIT(dev), sc);

	sc->sc_refcnt++;
	error = ugen_do_ioctl(sc, endpt, cmd, addr, flag, p);
	if (--sc->sc_refcnt < 0)
		usb_detach_wakeup(USBDEV(sc->sc_dev));
	return (error);
}

int
ugenpoll(dev, events, p)
	dev_t dev;
	int events;
	struct proc *p;
{
	struct ugen_softc *sc;
	struct ugen_endpoint *sce;
	int revents = 0;
	int s;

	USB_GET_SC(ugen, UGENUNIT(dev), sc);

	if (sc->sc_dying)
		return (EIO);

	/* XXX always IN */
	sce = &sc->sc_endpoints[UGENENDPOINT(dev)][IN];
	if (sce == NULL)
		return (EINVAL);
#ifdef DIAGNOSTIC
	if (!sce->edesc) {
		printf("ugenpoll: no edesc\n");
		return (EIO);
	}
	if (!sce->pipeh) {
		printf("ugenpoll: no pipe\n");
		return (EIO);
	}
#endif
	s = splusb();
	switch (sce->edesc->bmAttributes & UE_XFERTYPE) {
	case UE_INTERRUPT:
		if (events & (POLLIN | POLLRDNORM)) {
			if (sce->q.c_cc > 0)
				revents |= events & (POLLIN | POLLRDNORM);
			else
				selrecord(p, &sce->rsel);
		}
		break;
	case UE_BULK:
		/* 
		 * We have no easy way of determining if a read will
		 * yield any data or a write will happen.
		 * Pretend they will.
		 */
		revents |= events & 
			   (POLLIN | POLLRDNORM | POLLOUT | POLLWRNORM);
		break;
	default:
		break;
	}
	splx(s);
	return (revents);
}

#if defined(__FreeBSD__)
DRIVER_MODULE(ugen, uhub, ugen_driver, ugen_devclass, usbd_driver_load, 0);
#endif
