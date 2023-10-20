#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Gcd;

my($rmax)=100;

#Case 1
my($p)=1;
while($p<100)
{
  my($q)=1;
  my($q_incr)=($p%2 == 1)?1:2;
  while($q<20)
  {
    if(Gcd::pgcd($p,$q) == 1)
    {
      my($coeff)=($p%2 == 1 && $q%2 == 1)?1:4;
      my($a)=($q*$q -3*$p*$p + 2*$p*$q)*$coeff/4;
      if($a > 0)
      {
        my($b)=$p*$q*$coeff;
        my($c)=(3*$p*$p + $q*$q) * $coeff/4;
        
        my($ok)=check60($a,$b,$c)?"ok":"bad";
        my($r2)= r2circle($a,$b,$c);
        my($r)=sqrt($$r2[0]/$$r2[1]);
        print "$p,$q -> $a, $b, $c . R = $r ($ok)\n";
        <STDIN>;
      }
    }
    $q+=$q_incr;
  }
  $p++;
}

sub check60
{
  my($a,$b,$c)=@_;
  return ( $a*$a + $b*$b - $a*$b == $c*$c );
}


sub r2circle
{
  my($a,$b,$c)=@_;
  my($num)=($a+$b-$c)*($a+$c-$b)*($b+$c-$a);
  my($denom)=($a+$b+$c)*4;
  return [$num,$denom];
}