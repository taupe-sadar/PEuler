use strict;
use warnings;
use Data::Dumper;
use integer;

# We consider the bianry representation of numbers. We can notice that
# Long sequence of zeros may lead to several representations if two powers of 2 are allowed
# Example : 10000 = 02000 = 01200 = 01120 = 01112
#
# Then, the quantity of representations depends of the series of zeros in a binary form of a numbers
# Let us consider (a_i) the sequence of the continuous zeros.
# Example : for n = 1000110100, a_i = (2,1,0,3)
#
# Then we can see that (f(n),g(n)) is equal to the product of the matrixes 
#
# M_i = | 1   a_i    |
#       | 1  a_i + 1 |  , starting with (f(0),g(0))=(1,1)

print power2_ways((5**5)**5,25); #means 5^25 * 2^25

sub power2_ways
{
  my($n,$zeros)=@_;
  $zeros = 0 if(!defined($zeros));
  
  my($nb)=$n;
  my($current_zeros)=$zeros;
  my(@zeros_binary_list)=();
  while($nb>0)
  {
    if(($nb & 0x1) == 0)
    {
      $current_zeros++;
    }
    else
    {
      unshift(@zeros_binary_list,$current_zeros);
      $current_zeros = 0;
    }
    $nb >>= 1;
  }

  my($f)=1;
  my($g)=1;

  for my $ai (@zeros_binary_list)
  {
    ($f,$g) = ($f + $ai*$g, $f + ($ai+1)*$g);
  }
  return $f;
}