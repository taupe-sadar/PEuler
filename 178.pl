use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min sum);

# Iterating over length of numbers
# For a length of number k :
#   The array step_numbers[i][j] represents all numbers  of length k,
#   that use i different digits, and highest digit is j
#
# For example , at step 13, the number
#    2345434565654 
# is in step_numbers[5][2], because it used the 5 digits 2,3,4,5,6 and the highest digit is 2
# 
# Finally dont count numbers starting with a 0


my($size)=40;
my($base)=10;

my($step_numbers)=[[],[1]];

my($total)=0;

for(my($length)=2;$length<=$size; $length++)
{
  my(@new_steps_numbers)=([]);
  for(my($num_digits_used)=1;$num_digits_used<=min($base,($#$step_numbers+1)); $num_digits_used++)
  {
    my(@tab)=();
    for(my($last_digit)=0;$last_digit<$num_digits_used; $last_digit++)
    {
      my($val)=0;
      if($last_digit == 0)
      {
        $val += $$step_numbers[$num_digits_used][1] if($num_digits_used <= $#$step_numbers && $num_digits_used > 1);
        $val += $$step_numbers[$num_digits_used-1][0] if($num_digits_used > 1);
      }
      elsif($last_digit == $num_digits_used - 1)
      {
        $val += $$step_numbers[$num_digits_used][$last_digit - 1] if($num_digits_used <= $#$step_numbers);
        $val += $$step_numbers[$num_digits_used-1][$last_digit - 1];
      }
      else
      {
        $val += $$step_numbers[$num_digits_used][$last_digit-1] if($num_digits_used <= $#$step_numbers);
        $val += $$step_numbers[$num_digits_used][$last_digit+1] if($num_digits_used <= $#$step_numbers);
      }
      push(@tab,$val);
    }
    push(@new_steps_numbers,\@tab);
  }
  
  if( $#new_steps_numbers == $base)
  {
    my($pandigital_step_numbers)=$new_steps_numbers[$base];
    $total += sum(@$pandigital_step_numbers[1..($base-1)]);
  }
  
  $step_numbers = \@new_steps_numbers;
}


print $total;
