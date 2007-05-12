%union {
	char	*str;
	int	val;
	struct	file_list *file;
}

%token	ARCH
%token	COMMA
%token	CONFIG
%token	CPU
%token	NOCPU
%token	DEVICE
%token	NODEVICE
%token	ENV
%token	EQUALS
%token	HINTS
%token	IDENT
%token	MAXUSERS
%token	PROFILE
%token	OPTIONS
%token	NOOPTION
%token	MAKEOPTIONS
%token	NOMAKEOPTION 
%token	SEMICOLON
%token	INCLUDE
%token	FILES

%token	<str>	ID
%token	<val>	NUMBER

%type	<str>	Save_id
%type	<str>	Opt_value
%type	<str>	Dev

%{

/*
 * Copyright (c) 1988, 1993
 *	The Regents of the University of California.  All rights reserved.
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
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)config.y	8.1 (Berkeley) 6/6/93
 * $FreeBSD$
 */

#include <assert.h>
#include <ctype.h>
#include <err.h>
#include <stdio.h>
#include <string.h>

#include "config.h"

struct	device_head dtab, rmdtab;
char	*ident;
char	*env;
int	envmode;
int	hintmode;
int	yyline;
const	char *yyfile;
struct  file_list_head ftab;
struct  files_name_head fntab;
char	errbuf[80];
int	maxusers;

#define ns(s)	strdup(s)
int include(const char *, int);
void yyerror(const char *s);
int yywrap(void);

static char *
devopt(char *dev)
{
	char *ret = malloc(strlen(dev) + 5);
	
	sprintf(ret, "DEV_%s", dev);
	raisestr(ret);
	return ret;
}

static void	rmoptall(struct opt_head *list, struct opt_head *torem);
static void	rmdevall(struct device_head *dh, struct device_head *torem);

%}
%%
Configuration:
	Many_specs
		;

Many_specs:
	Many_specs Spec
		|
	/* lambda */
		;

Spec:
	Device_spec SEMICOLON
		|
	Config_spec SEMICOLON
		|
	INCLUDE ID SEMICOLON
	      = {
	          if (incignore == 0)
		  	include($2, 0);
		};
		|
	FILES ID SEMICOLON
	      = { newfile($2); };
	        |
	SEMICOLON
		|
	error SEMICOLON
		;

Config_spec:
	ARCH Save_id
	    = {
		if (machinename != NULL && !eq($2, machinename))
		    errx(1, "%s:%d: only one machine directive is allowed",
			yyfile, yyline);
		machinename = $2;
		machinearch = $2;
	      } |
	ARCH Save_id Save_id
	    = {
		if (machinename != NULL &&
		    !(eq($2, machinename) && eq($3, machinearch)))
		    errx(1, "%s:%d: only one machine directive is allowed",
			yyfile, yyline);
		machinename = $2;
		machinearch = $3;
	      } |
	CPU Save_id
	      = {
		struct cputype *cp =
		    (struct cputype *)calloc(1, sizeof (struct cputype));
		cp->cpu_name = $2;
		SLIST_INSERT_HEAD(&cputype, cp, cpu_next);
	      } |
	NOCPU Save_id
	      = {
		struct cputype *cp, *cp2;
		SLIST_FOREACH_SAFE(cp, &cputype, cpu_next, cp2) {
			if (eq(cp->cpu_name, $2)) {
				SLIST_REMOVE(&cputype, cp, cputype, cpu_next);
				free(cp);
			}
		}
	      } |
	OPTIONS Opt_list
		|
	NOOPTION Save_id
	      = { rmopt_schedule(&rmopts, $2); } |
	MAKEOPTIONS Mkopt_list
		|
	NOMAKEOPTION Save_id
	      = { rmopt_schedule(&mkopt, $2); } |
	IDENT ID
	      = { ident = $2; } |
	System_spec
		|
	MAXUSERS NUMBER
	      = { maxusers = $2; } |
	PROFILE NUMBER
	      = { profiling = $2; } |
	ENV ID
	      = {
		env = $2;
		envmode = 1;
		} |
	HINTS ID
	      = {
		struct hint *hint;

		hint = (struct hint *)calloc(1, sizeof (struct hint));
		hint->hint_name = $2;
		STAILQ_INSERT_TAIL(&hints, hint, hint_next);
		hintmode = 1;
	        }

System_spec:
	CONFIG System_id System_parameter_list
	  = { errx(1, "%s:%d: root/dump/swap specifications obsolete",
	      yyfile, yyline);}
	  |
	CONFIG System_id
	  ;

System_id:
	Save_id
	      = { newopt(&mkopt, ns("KERNEL"), $1); };

System_parameter_list:
	  System_parameter_list ID
	| ID
	;

Opt_list:
	Opt_list COMMA Option
		|
	Option
		;

Option:
	Save_id
	      = {
		newopt(&opt, $1, NULL);
		if (strchr($1, '=') != NULL)
			errx(1, "%s:%d: The `=' in options should not be "
			    "quoted", yyfile, yyline);
	      } |
	Save_id EQUALS Opt_value
	      = {
		newopt(&opt, $1, $3);
	      } ;

Opt_value:
	ID
		= { $$ = $1; } |
	NUMBER
		= {
			char buf[80];

			(void) snprintf(buf, sizeof(buf), "%d", $1);
			$$ = ns(buf);
		} ;

Save_id:
	ID
	      = { $$ = $1; }
	;

Mkopt_list:
	Mkopt_list COMMA Mkoption
		|
	Mkoption
		;

Mkoption:
	Save_id
	      = { newopt(&mkopt, $1, ns("")); } |
	Save_id EQUALS Opt_value
	      = { newopt(&mkopt, $1, $3); } ;

Dev:
	ID
	      = { $$ = $1; }
	;

Device_spec:
	DEVICE Dev_list
		|
	NODEVICE NoDev_list
		;

Dev_list:
	Dev_list COMMA Device
		|
	Device
		;

NoDev_list:
	NoDev_list COMMA NoDevice
		|
	NoDevice
		;

Device:
	Dev
	      = {
		newopt(&opt, devopt($1), ns("1"));
		/* and the device part */
		newdev($1);
		}

NoDevice:
	Dev
	      = {
		char *s = devopt($1);

		rmopt_schedule(&rmopts, s);
		free(s);
		/* and the device part */
		rmdev_schedule(&rmdtab, $1);
		} ;

%%

void
yyerror(const char *s)
{

	errx(1, "%s:%d: %s", yyfile, yyline + 1, s);
}

int
yywrap(void)
{

	if (found_defaults == 0 && incignore == 0) {
		if (freopen("DEFAULTS", "r", stdin) == NULL)
			return 1;
		yyfile = "DEFAULTS";
		yyline = 0;
		found_defaults = 1;
		return 0;
	}
	rmoptall(&opt, &rmopts);
	rmdevall(&dtab, &rmdtab);
	return 1;
}

/*
 * Add a new file to the list of files.
 */
static void
newfile(char *name)
{
	struct files_name *nl;
	
	nl = (struct files_name *) calloc(1, sizeof *nl);
	nl->f_name = name;
	STAILQ_INSERT_TAIL(&fntab, nl, f_next);
}
	
/*
 * Find a device in the list of devices.
 */
static struct device *
finddev(struct device_head *dlist, char *name)
{
	struct device *dp;

	STAILQ_FOREACH(dp, dlist, d_next)
		if (eq(dp->d_name, name))
			return (dp);

	return (NULL);
}
	
/*
 * Add a device to the list of devices.
 */
static void
newdev(char *name)
{
	struct device *np;

	if (finddev(&dtab, name)) {
		printf("WARNING: duplicate device `%s' encountered.\n", name);
		return;
	}

	np = (struct device *) calloc(1, sizeof *np);
	np->d_name = name;
	STAILQ_INSERT_TAIL(&dtab, np, d_next);
}

/*
 * Schedule a device to removal.
 */
static void
rmdev_schedule(struct device_head *dh, char *name)
{
	struct device *dp;

	dp = calloc(1, sizeof(struct device));
	dp->d_name = strdup(name);
	assert(dp->d_name != NULL);
	STAILQ_INSERT_HEAD(dh, dp, d_next);
}

/*
 * Take care a devices previously scheduled for removal.
 */
static void
rmdevall(struct device_head *dh, struct device_head *torem)
{
	struct device *dp, *rdp;

	while (!STAILQ_EMPTY(torem)) {
		dp = STAILQ_FIRST(torem);
		STAILQ_REMOVE_HEAD(torem, d_next);
		rdp = finddev(dh, dp->d_name);
		if (rdp != NULL) {
			STAILQ_REMOVE(dh, rdp, device, d_next);
			free(rdp->d_name);
			free(rdp);
		}
		free(dp);
	}
}

/*
 * Find an option in the list of options.
 */
static struct opt *
findopt(struct opt_head *list, char *name)
{
	struct opt *op;

	SLIST_FOREACH(op, list, op_next)
		if (eq(op->op_name, name))
			return (op);

	return (NULL);
}

/*
 * Add an option to the list of options.
 */
static void
newopt(struct opt_head *list, char *name, char *value)
{
	struct opt *op;

	/*
	 * Ignore inclusions listed explicitly for configuration files.
	 */
	if (eq(name, OPT_AUTOGEN)) {
		incignore = 1;
		return;
	}

	if (findopt(list, name)) {
		printf("WARNING: duplicate option `%s' encountered.\n", name);
		return;
	}

	op = (struct opt *)calloc(1, sizeof (struct opt));
	op->op_name = name;
	op->op_ownfile = 0;
	op->op_value = value;
	SLIST_INSERT_HEAD(list, op, op_next);
}

/*
 * Remove an option from the list of options.
 */
static void
rmopt_schedule(struct opt_head *list, char *name)
{
	struct opt *op;

	op = calloc(1, sizeof(*op));
	op->op_name = ns(name);
	SLIST_INSERT_HEAD(list, op, op_next);
}

/*
 * Remove all options that were scheduled for removal.
 */
static void
rmoptall(struct opt_head *list, struct opt_head *torem)
{
	struct opt *op, *rop;

	op = rop = NULL;
	while (!SLIST_EMPTY(torem)) {
		op = SLIST_FIRST(torem);
		SLIST_REMOVE_HEAD(torem, op_next);
		rop = findopt(list, op->op_name);
		if (rop != NULL) {
			SLIST_REMOVE(list, rop, opt, op_next);
			free(rop->op_name);
			if (rop->op_value != NULL)
				free(rop->op_value);
			free(rop);
		}
		free(op);
	}
}
