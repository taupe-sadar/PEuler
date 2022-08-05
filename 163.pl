use strict;
use warnings;
use Data::Dumper;
use Sums;
use POSIX qw/floor/;

my($size)=36;
my($o,$r,$e)=(obtuse_triangles($size) , rectangle_triangles($size) , equilateral_triangles($size));
# print "$o + $r + $e\n";
print $o + $r + $e;

sub obtuse_triangles
{
  my($n)=@_;
  my($s)=sum_of_sum($n);
  $s += sum_of_sum_with_step($n - 1, 2);
  $s += sum_of_sum_with_step($n - 1, 4) + sum_of_sum_with_step($n - 2, 4) + sum_of_sum_with_step($n - 3, 4);
  $s += sum_of_sum_with_step($n - 1, 2);
  return $s * 3;
}

sub rectangle_triangles
{
  my($n)=@_;
  my($s)=sum_of_sum($n) + sum_of_sum_with_step($n - 1, 2);
  $s += sum_of_sum($n);

  $s += sum_of_sum_with_step($n - 1, 5) + sum_of_sum_with_step($n - 3, 5);
  $s += sum_of_sum_with_step($n - 1, 5) + sum_of_sum_with_step($n - 4, 5);
  $s += sum_of_sum_with_step($n - 2, 5) + sum_of_sum_with_step($n - 4, 5);
  
  $s += sum_of_sum_with_step($n - 1, 3) + sum_of_sum_with_step($n - 2, 3);

  return $s * 6;
}

sub equilateral_triangles
{
  my($n)=@_;
  my($straight)=sum_of_sum($n);
  $straight += sum_of_sum_with_step($n - 1, 2);
  
  my($shifted)= sum_of_sum_with_step($n - 1, 3) + sum_of_sum_with_step($n - 2, 3) + sum_of_sum_with_step($n - 2, 3);
  $shifted +=   sum_of_sum_with_step($n - 1, 3) + sum_of_sum_with_step($n - 2, 3) + sum_of_sum_with_step($n - 4, 3);
  $shifted +=   sum_of_sum_with_step($n - 1, 3) + sum_of_sum_with_step($n - 2, 3) + sum_of_sum_with_step($n - 3, 3);
  
  return $straight + $shifted * 2;
}

sub sum_of_sum
{
  my($n)=@_;
  return 0 if $n <= 0;
  return (Sums::int_sum($n) + Sums::int_square_sum($n))/2;
}

sub sum_of_sum_with_step
{
  my($n,$step)=@_;
  return 0 if $n <= 0;
  my($f)=floor($n/$step);
  return (Sums::int_square_sum($f)*$step**2 - Sums::int_sum($f) * $step * (2*$n+1) + ($f+1)*($n+1)*$n )/2;
}
