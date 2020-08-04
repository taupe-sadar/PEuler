package Gcd;
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );

sub ppcm
{
  my($a,$b)=@_;
  return $a*$b/pgcd($a,$b);
}

sub pgcd
{
  my($ar1,$ar2)=@_;
  if($ar1 == 0 || $ar2 == 0)
  {
    return 1;
  }
  my($b,$a)=sort(abs($ar1),abs($ar2));
  return optim_pgcd($a,$b);
}

##Assumes that $a > $b > 0
## needed for performance
sub optim_pgcd
{
  my($a,$b)=@_;
  my($r)=$b;
  while($r>0)
  {
    $r=$a%$b;
    $a=$b;
    $b=$r;
  }
  return $a;

}

1;
