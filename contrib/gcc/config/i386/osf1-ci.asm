! crti.s for OSF/1, x86; derived from sol2-ci.asm.

!   Copyright (C) 1993, 1998 Free Software Foundation, Inc.
!   Written By Fred Fish, Nov 1992
! 
! This file is free software; you can redistribute it and/or modify it
! under the terms of the GNU General Public License as published by the
! Free Software Foundation; either version 2, or (at your option) any
! later version.
! 
! In addition to the permissions in the GNU General Public License, the
! Free Software Foundation gives you unlimited permission to link the
! compiled version of this file with other programs, and to distribute
! those programs without any restriction coming from the use of this
! file.  (The General Public License restrictions do apply in other
! respects; for example, they cover modification of the file, and
! distribution when not linked into another program.)
! 
! This file is distributed in the hope that it will be useful, but
! WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
! General Public License for more details.
! 
! You should have received a copy of the GNU General Public License
! along with this program; see the file COPYING.  If not, write to
! the Free Software Foundation, 59 Temple Place - Suite 330,
! Boston, MA 02111-1307, USA.
! 
!    As a special exception, if you link this library with files
!    compiled with GCC to produce an executable, this does not cause
!    the resulting executable to be covered by the GNU General Public License.
!    This exception does not however invalidate any other reasons why
!    the executable file might be covered by the GNU General Public License.
! 

! This file just supplies labeled starting points for the .init and .fini
! sections.  It is linked in before the values-Xx.o files and also before
! crtbegin.o.
 
	.file	"crti.s"
	.ident	"GNU C crti.s"

	.section .init
	.globl	_init
	.type	_init,@function
_init:

	.section .fini
	.globl	_fini
	.type	_fini,@function
_fini:

.globl _init_init_routine
.data
        .align 4
        .type    _init_init_routine,@object
        .size    _init_init_routine,4
_init_init_routine:
        .long _init
.globl _init_fini_routine
        .align 4
        .type    _init_fini_routine,@object
        .size    _init_fini_routine,4
_init_fini_routine:
        .long _fini
