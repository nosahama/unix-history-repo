#!/usr/local/bin/perl

$prog="des686.pl";

# base code is in microsft
# op dest, source
# format.
#

# WILL NOT WORK ANYMORE WITH desboth.pl
require "desboth.pl";

if (	($ARGV[0] eq "elf"))
	{ require "x86unix.pl"; }
elsif (	($ARGV[0] eq "a.out"))
	{ $aout=1; require "x86unix.pl"; }
elsif (	($ARGV[0] eq "sol"))
	{ $sol=1; require "x86unix.pl"; }
elsif ( ($ARGV[0] eq "cpp"))
	{ $cpp=1; require "x86unix.pl"; }
elsif (	($ARGV[0] eq "win32"))
	{ require "x86ms.pl"; }
else
	{
	print STDERR <<"EOF";
Pick one target type from
	elf	- linux, FreeBSD etc
	a.out	- old linux
	sol	- x86 solaris
	cpp	- format so x86unix.cpp can be used
	win32	- Windows 95/Windows NT
EOF
	exit(1);
	}

&comment("Don't even think of reading this code");
&comment("It was automatically generated by $prog");
&comment("Which is a perl program used to generate the x86 assember for");
&comment("any of elf, a.out, Win32, or Solaris");
&comment("It can be found in SSLeay 0.6.5+ or in libdes 3.26+");
&comment("eric <eay\@cryptsoft.com>");
&comment("");

&file("dx86xxxx");

$L="edi";
$R="esi";

&des_encrypt("des_encrypt1",1);
&des_encrypt("des_encrypt2",0);

&des_encrypt3("des_encrypt3",1);
&des_encrypt3("des_decrypt3",0);

&file_end();

sub des_encrypt
	{
	local($name,$do_ip)=@_;

	&function_begin($name,"EXTRN   _des_SPtrans:DWORD");

	&comment("");
	&comment("Load the 2 words");
	&mov("eax",&wparam(0));
	&mov($L,&DWP(0,"eax","",0));
	&mov($R,&DWP(4,"eax","",0));

	$ksp=&wparam(1);

	if ($do_ip)
		{
		&comment("");
		&comment("IP");
		&IP_new($L,$R,"eax");
		}

	&comment("");
	&comment("fixup rotate");
	&rotl($R,3);
	&rotl($L,3);
	&exch($L,$R);

	&comment("");
	&comment("load counter, key_schedule and enc flag");
	&mov("eax",&wparam(2));	# get encrypt flag
	&mov("ebp",&wparam(1));	# get ks
	&cmp("eax","0");
	&je(&label("start_decrypt"));

	# encrypting part

	for ($i=0; $i<16; $i+=2)
		{
		&comment("");
		&comment("Round $i");
		&D_ENCRYPT($L,$R,$i*2,"ebp","des_SPtrans","ecx","edx","eax","ebx");

		&comment("");
		&comment("Round ".sprintf("%d",$i+1));
		&D_ENCRYPT($R,$L,($i+1)*2,"ebp","des_SPtrans","ecx","edx","eax","ebx");
		}
	&jmp(&label("end"));

	&set_label("start_decrypt");

	for ($i=15; $i>0; $i-=2)
		{
		&comment("");
		&comment("Round $i");
		&D_ENCRYPT($L,$R,$i*2,"ebp","des_SPtrans","ecx","edx","eax","ebx");
		&comment("");
		&comment("Round ".sprintf("%d",$i-1));
		&D_ENCRYPT($R,$L,($i-1)*2,"ebp","des_SPtrans","ecx","edx","eax","ebx");
		}

	&set_label("end");

	&comment("");
	&comment("Fixup");
	&rotr($L,3);		# r
	&rotr($R,3);		# l

	if ($do_ip)
		{
		&comment("");
		&comment("FP");
		&FP_new($R,$L,"eax");
		}

	&mov("eax",&wparam(0));
	&mov(&DWP(0,"eax","",0),$L);
	&mov(&DWP(4,"eax","",0),$R);

	&function_end($name);
	}


# The logic is to load R into 2 registers and operate on both at the same time.
# We also load the 2 R's into 2 more registers so we can do the 'move word down a byte'
# while also masking the other copy and doing a lookup.  We then also accumulate the
# L value in 2 registers then combine them at the end.
sub D_ENCRYPT
	{
	local($L,$R,$S,$ks,$desSP,$u,$t,$tmp1,$tmp2,$tmp3)=@_;

	&mov(	$u,		&DWP(&n2a($S*4),$ks,"",0));
	&mov(	$t,		&DWP(&n2a(($S+1)*4),$ks,"",0));
	&xor(	$u,		$R		);
	&xor(	$t,		$R		);
	&rotr(	$t,		4		);

	# the numbers at the end of the line are origional instruction order
	&mov(	$tmp2,		$u		);			# 1 2
	&mov(	$tmp1,		$t		);			# 1 1
	&and(	$tmp2,		"0xfc"		);			# 1 4
	&and(	$tmp1,		"0xfc"		);			# 1 3
	&shr(	$t,		8		);			# 1 5
	&xor(	$L,		&DWP("0x100+$desSP",$tmp1,"",0));	# 1 7
	&shr(	$u,		8		);			# 1 6
	&mov(	$tmp1,		&DWP("      $desSP",$tmp2,"",0));	# 1 8

	&mov(	$tmp2,		$u		);			# 2 2
	&xor(	$L,		$tmp1		);			# 1 9
	&and(	$tmp2,		"0xfc"		);			# 2 4
	&mov(	$tmp1,		$t		);			# 2 1
	&and(	$tmp1,		"0xfc"		);			# 2 3
	&shr(	$t,		8		);			# 2 5
	&xor(	$L,		&DWP("0x300+$desSP",$tmp1,"",0));	# 2 7
	&shr(	$u,		8		);			# 2 6
	&mov(	$tmp1,		&DWP("0x200+$desSP",$tmp2,"",0));	# 2 8
	&mov(	$tmp2,		$u		);			# 3 2

	&xor(	$L,		$tmp1		);			# 2 9
	&and(	$tmp2,		"0xfc"		);			# 3 4

	&mov(	$tmp1,		$t		);			# 3 1 
	&shr(	$u,		8		);			# 3 6
	&and(	$tmp1,		"0xfc"		);			# 3 3
	&shr(	$t,		8		);			# 3 5
	&xor(	$L,		&DWP("0x500+$desSP",$tmp1,"",0));	# 3 7
	&mov(	$tmp1,		&DWP("0x400+$desSP",$tmp2,"",0));	# 3 8

	&and(	$t,		"0xfc"		);			# 4 1
	&xor(	$L,		$tmp1		);			# 3 9

	&and(	$u,		"0xfc"		);			# 4 2
	&xor(	$L,		&DWP("0x700+$desSP",$t,"",0));		# 4 3
	&xor(	$L,		&DWP("0x600+$desSP",$u,"",0));		# 4 4
	}

sub PERM_OP
	{
	local($a,$b,$tt,$shift,$mask)=@_;

	&mov(	$tt,		$a		);
	&shr(	$tt,		$shift		);
	&xor(	$tt,		$b		);
	&and(	$tt,		$mask		);
	&xor(	$b,		$tt		);
	&shl(	$tt,		$shift		);
	&xor(	$a,		$tt		);
	}

sub IP_new
	{
	local($l,$r,$tt)=@_;

	&PERM_OP($r,$l,$tt, 4,"0x0f0f0f0f");
	&PERM_OP($l,$r,$tt,16,"0x0000ffff");
	&PERM_OP($r,$l,$tt, 2,"0x33333333");
	&PERM_OP($l,$r,$tt, 8,"0x00ff00ff");
	&PERM_OP($r,$l,$tt, 1,"0x55555555");
	}

sub FP_new
	{
	local($l,$r,$tt)=@_;

	&PERM_OP($l,$r,$tt, 1,"0x55555555");
        &PERM_OP($r,$l,$tt, 8,"0x00ff00ff");
        &PERM_OP($l,$r,$tt, 2,"0x33333333");
        &PERM_OP($r,$l,$tt,16,"0x0000ffff");
        &PERM_OP($l,$r,$tt, 4,"0x0f0f0f0f");
	}

sub n2a
	{
	sprintf("%d",$_[0]);
	}
