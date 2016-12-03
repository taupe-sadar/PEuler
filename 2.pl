use strict;
use warnings;
use Data::Dumper;

#u_3(n+2)=4*u_3(n+1)+u_3n

my($u0)=0;
my($u1)=2;
my($u2)=8;
my($s)=$u1;


while($u2 <= 4000000)
{
	$s += $u2;
	$u0=$u1;
	$u1=$u2;
	$u2 = 4*$u1 + $u0 ;
}

print $s;