use strict;
use warnings;
use Data::Dumper;
use Permutations;

# Consider the problem of seeking string of size n 
# in an alphabet of size n, with all chars different
# Except, the adjacent chars, all chars will be sorted
# There are only 2 parameters, considering the interst neighbors :
# - value of the left neighbor (left)
# - value of the right neighbor (right)
# 
# For a couple of neighbors (left,right), all possible arrangements will be determined 
# by the chars whose values are between left and right
# ie : 
#      Sum(k,0,right - left - 1)( Cnk( right - left - 1, k ) ) = 2^(right - left - 1)
#
# Then, by counting all values for left and right :
#
#   Sum(i,0,n-1)(Sum(j,i+1,n)(2^(j - i - 1))) = 2^n - n - 1

my($alpha_size)=26;

my($max)=0;

for(my($size)=1;$size<=26;$size++)
{
  my($count) = count_lexileft($size,$alpha_size);
  $max = $count if($max < $count);
}

print $max;

sub count_lexileft
{
  my($n,$S)=@_;
  return count_lexileft_all_chars($n)*Permutations::cnk($S, $n);
}

sub count_lexileft_all_chars
{
  my($n)=@_;
  return (2**$n - $n - 1);
}

