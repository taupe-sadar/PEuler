use strict;
use warnings;
use Data::Dumper;
use Permutations;
use List::Util qw( min );

# Recursive approach : At step i, the array will contain the quantity
# of numbers that can be written with i diffent digits, with no more 
# than 3 each

my($max_size)=18;
my($max_occurence)=3;

my($rquantities_numbers)=[1];
for(my($i)=1;$i<=10;$i++)
{
  my($rwith_less_digits)=$rquantities_numbers;
  my($limited_size)=min($#$rwith_less_digits,$max_size);
  
  my(@quantities)=(0)x min($#$rwith_less_digits + $max_occurence+1,$max_size);
  for(my($j)=0;$j<=min($#$rwith_less_digits,$max_size);$j++)
  {
    for(my($occ)=0;$occ<=min($max_occurence,$max_size-$j);$occ++)
    {
      if($i<10)
      {
        $quantities[$j+$occ] += $$rwith_less_digits[$j] * Permutations::cnk($j+$occ,$occ);
      }
      else
      {
        $quantities[$j+$occ] += $$rwith_less_digits[$j] * Permutations::cnk($j+$occ -1,$occ);
      }
    }
  }
  $rquantities_numbers = \@quantities;
}

print $$rquantities_numbers[$max_size];