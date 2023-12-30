#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

# We use continued fraction notations as in the 192 problem.
# the continued fraction of x can be written [a0, a1, a2, ... ]
# With a_0 = int(x) , x = x_0 = a_0 + x_1
#      a_n = int(1/x_n), x_n = a_n + x_n+1
#
# The reduced fraction are defined : p_n / q_n with
# p_-1 = 1 , p_-2 = 0, p_n = p_n-1 * a_n + p_n-2
# q_-1 = 0 , q_-2 = 1, q_n = q_n-1 * a_n + q_n-2
#
# For rationals, the continued fraction is finite : 
# p/q = [a0,...., an]
#
# A best approximation (p/q = [a0,...,a_n-1,b]) of x verifies : 
# [ a_n, a_n+1, ... ] < [ 2b, a_n-1, ..., a1 ]
#
# Ambiguous numbers are those x were the previous inequality is an equality instead.
# then the ambiguous number is : 
#   [a0,a1,...,a_n-1, an = 2*b, an_-1,...,a1]
# And the best approximations are :
#   [a0,...,a_n-1,b] and [a0,...,a_n-1]


my($max_denom)=10**8;

my($a1)=100;
my($num)=0;
while(1)
{
  my($n)=count_ambiguious_starting_with([$a1]);
  last if($n == 0);
  $num+=$n;
  $a1++;
}
$num += ($max_denom - 100)/2;
print $num;

sub count_ambiguious_starting_with
{
  my($frac)=@_;
  my($count)=0;
  
  my($middle)=2;
  while(1)
  {
    my($c)=calc_denom($frac,$middle);
    last if($c > $max_denom);
    $count ++;
    $middle+=2;
  }
  return 0 if($middle==2);
  
  my($a)=1;
  while(1)
  {
    my($c) = count_ambiguious_starting_with([@$frac,$a]);
    last if( $c == 0 );
    $count+=$c;
    $a++;
  }
  return $count;
}

sub calc_denom
{
  my($f,$mid)=@_;
  my($qn,$qn_1) = (0 , 1);
  ($qn,$qn_1) = ($qn_1,$qn);
  for(my($i)=0;$i<=$#$f;$i++)
  {
    ($qn,$qn_1) = ($qn * $$f[$i] + $qn_1,$qn);
  }
  ($qn,$qn_1) = ($qn * $mid + $qn_1,$qn);
  for(my($i)=$#$f;$i>=0;$i--)
  {
    ($qn,$qn_1) = ($qn * $$f[$i] + $qn_1,$qn);
  }
  return $qn;
}