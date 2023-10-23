#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor/;

my($rmax)=100;

#Case 1
my($count)=0;
my($p)=1;
while($p<500)
{
  my($q)=$p+1;
  my($q_incr)=($p%2 == 1)?1:2;
  while($q<3*$p)
  {
    my($qmax)= $p + 4*$rmax/$p/sqrt(3);
    
    if(Gcd::pgcd($p,$q) == 1)
    {
      my($coeff)=($p%2 == 1 && $q%2 == 1)?1:4;
      
      my($radius)=$p*($q-$p)*sqrt(3)/4;
      my($num)=floor($rmax/$radius/$coeff);
      $count+=$num;
      
      my($a)=($q*$q -3*$p*$p + 2*$p*$q)*$coeff/4;
      if($a > 0)
      {
        my($b)=$p*$q*$coeff;
        my($c)=(3*$p*$p + $q*$q) * $coeff/4;
        
        my($r2)= r2circle($a,$b,$c,$p,$q,$coeff);
        my($r)=sqrt($$r2[0]/$$r2[1]);
        print "$p,$q -> $a, $b, $c . R = $r => $num . (qmax : $q/$qmax)\n";
        # <STDIN>;
      }
    }
    last if($q>= $qmax);
    $q+=$q_incr;
  }
  $p++;
}
print $count;

sub r2circle
{
  my($a,$b,$c,$p,$q,$coeff)=@_;
  my($num)=($a+$b-$c)*($a+$c-$b)*($b+$c-$a);
  my($denom)=($a+$b+$c)*4;
  
  my($rwithp)=$p*$p*($q-$p)*($q-$p);
  my($ok) = ( $num * 16 == $denom * $rwithp *3* $coeff *$coeff );
  
  # print "$a,$b,$c $p,$q ($coeff)=> ".($ok?"ok":"pas ok")." \n";
  # <STDIN>;


  return [$num,$denom];
}