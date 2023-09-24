#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use List::Util qw/min max/;
use ContinueFraction;

# A continued fraction of x can be written [a0, a1, a2, ... ]
# With a_0 = int(x) , x = x_0 = a_0 + x_1
#      a_n = int(1/x_n), x_n = a_n + x_n+1
#
# The reduced fraction are defined : p_n / q_n with
# p_-1 = 1 , p_-2 = 0, p_n = p_n-1 * a_n + p_n-2
# q_-1 = 0 , q_-2 = 1, q_n = q_n-1 * a_n + q_n-2
#
# we have the property that p_n+1 * q_n - q_n+1 * p_n = (-1)^(n+1) (*)
# we means that p_n / q_n is irreductible
#
# We also have p_n-2/q_n-2 < p_n/q_n < x < p_n-1/q_n-1  if n is even (same with inequalities reverse if n is odd)
#
# Introducing the secondary reduced fraction p/q = (p_n-1 * b + p_n-2) / (q_n-1 * b + q_n-2) with b in [1,a_n]
# it is in the path between p_n-2/q_n-2 and  p_n/q_n, i.e.
# p_n-2/q_n-2 < p/q <= p_n/q_n < x < p_n-1/q_n-1 (for even n case)
# 
# Looking if p/q is a best approximation of x, (i.e. |p/q -x| > |p'/q' - x| => q' > q)
# 1) If p/q is not in all intervals [p_n-2/q_n-2, p_n/q_n], then there is a  p_n/q_n which is are better approx
# 2) If p/q is in an interval [p_n-2/q_n-2, p_n/q_n], then it is at least a secondary reduced.
#    In order to be a best approximation, we must verify :
#    (**) x - p/q < p_n-1/q_n-1 - x . if not p_n-1/q_n-1 is a better approximation since q_n-1 < q = q_n-2 + b * q_n-1
#    using that x = [ a_0,..,a_n-1, x_n ] = (p_n-2 + p_n-1 * x_n) / (q_n-2 + q_n-1 * x_n)
#          and p/q = (p_n-1 * b + p_n-2)/ (q_n-1 * b + q_n-2)
#          and using (*)
#    (**) <=> (x_n - b)/(q_n-1 * b + q_n-2) < 1/q_n-1
#    (**) <=> x_n  < 2 * b + q_n-2/q_n-1
# which means [ a_n, a_n+1, ... ] < [ 2b, a_n-1, ..., a1 ]
# 
# Conclusion the best approximation are the secondary reduced verifying that last property


my($denom_max)=10**12;
my($max_n)=10**5;

my($sum_q)=0;

for(my($n)=1;$n<=$max_n;$n++)
{
  my($squ)=sqrt($n);
  my($isqu)=int($squ);
  next if($isqu*$isqu == $n);

  my($gen)=ContinueFraction::generator_from_integer($n);
  
  my(@qns)=(0,1);
  
  my($a)=ContinueFraction::gen_next($gen);
  my($q)=$a * $qns[0] + $qns[1];
  my($i)=0;
  while($q <= $denom_max )
  {
    @qns = ($q,$qns[0]);
    $a=ContinueFraction::gen_next($gen);
    $q = $a * $qns[0] + $qns[1];
    $i++;
  }
  
  my($b)=floor(($denom_max-$qns[1])/$qns[0]);
  my($ret)=0;
  my($secondary)=$b * $qns[0] + $qns[1];
  if(2*$b < $a )
  {
    $ret = $qns[0];
  }
  elsif( 2*$b > $a )
  {
    $ret = $secondary;
  }
  else
  {
    my($sign)=1;
    my($irr_idx)=$i+1;
    my($q_idx)=$i-1;
    while($q_idx > 0 )
    {
      my($irr_coeff) = ContinueFraction::gen_get($gen,$irr_idx);
      my($q_coeff) = ContinueFraction::gen_get($gen,$q_idx);
      if($irr_coeff != $q_coeff )
      {
        if( $sign * ($irr_coeff - $q_coeff ) > 0 )
        {
          $ret = $secondary;
        }
        else
        {
          $ret = $qns[0];
        }
        last;
      }
      $sign = -$sign;
      $irr_idx++;
      $q_idx--;
    }
    if( $q_idx == 0 )
    {
      if($sign < 0 )
      {
        $ret = $secondary;
      }
      else
      {
        $ret = $qns[0];
      }
    }
  }
  
  $sum_q += $ret;
  
}

print $sum_q;
