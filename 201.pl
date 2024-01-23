#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use List::Util qw(max min);
use Sums;

# Let us split the interval [ 1 , n ] = [ 1 , 2k ] U [ 2k+1 , n ]
# such as d < L where : 
#  - the max difference between two adjacent squares : d = n² - (n-1)²
#  - if we list all the subsets of k elements [1,2k], and list all the sum of the squares of those subsets.
#       within this list, search the largest interval [a,b] of contiguous values which occurrence are at least 2.
#       then L = b - a
#  The minimum sum of squares of n/2 -k elements in [ 2k+1 , n ] is m = sum(i²) from (2k+1) to (k + n/2)
#  The maximum sum of squares of n/2 -k elements in [ 2k+1 , n ] is M = sum(i²) from (k + n/2 +1) to (n)
#  By increasing/decreasing 1 by 1 from one subset to another in [ 2k+1 , n ], we increase/decrease the sum value
#  of a value < d
#  Then we can construct all values from[a + m, b + M] by picking a subset in [ 2k+1 , n ] and adjusting with another 
#  subset in [ 1 , 2k ]
#  We can then use the bound (a+m) in the main algorithm.
#  
#  The main algorithm list all values and their occurrences using intermediate subsets, avoiding final possible 
#  values higher than the bound.
#  Finally we count the values lower than the bound which occur only once.
#  
#  Because of symetry of the problem, if a sum of suares of a subset occurs only once, the for the complementary subset
#  it occurs also once.
#  this is a duo whose sum is : sum(i²) from (1) to (n)
#  Finally we multiply this sum to the previous counting

my($num_elts)=100;
my($sub_num_elts)=$num_elts/2;

my($maximum_bound)=0;

my($subset_set)=1;
while(1)
{
  my($middle) = int((offset_square_sum($subset_set+1,$subset_set*2)+offset_square_sum(1,$subset_set))/2);
  my($final)=all_sums(1,$subset_set*2);

  my($min_twice)=$middle;
  $min_twice-- while($$final{$min_twice});
  my($max_twice)=$middle;
  $max_twice++ while($$final{$max_twice});
  
  if($max_twice - $min_twice > ($num_elts *2 - 1))
  {
    $maximum_bound = offset_square_sum($subset_set*2 + 1,$num_elts/2+$subset_set) + $min_twice;
    last;
  }
  $subset_set++;
}

my(@all_sets_values)=({0=>1});

my($count)=0;
for(my($n)=$num_elts;$n>=1;$n--)
{
  my($max_set)=$num_elts-$n+1;
  
  my($square)=$n*$n;
  
  push(@all_sets_values,{}) if($max_set <= $sub_num_elts);
  for(my($set_size)=min($max_set,$sub_num_elts)-1;$set_size>=max(0,$max_set-$sub_num_elts-1);$set_size--)
  {
    my($rprev_values)=$all_sets_values[$set_size];
    foreach my $v (keys(%$rprev_values))
    {
      my($sum)=$v + $square;
      next if($sum > $maximum_bound);
      Hashtools::increment($all_sets_values[$set_size+1],$sum, $$rprev_values{$v});
    }
    
    if($set_size == $sub_num_elts - 1)
    {
      while(exists($all_sets_values[$sub_num_elts]{$maximum_bound}) && $all_sets_values[$sub_num_elts]{$maximum_bound} >= 2)
      {
        $maximum_bound--;
      }
    }
  }
}

my($count_low_half)=0;
foreach my $v (keys(%{$all_sets_values[$sub_num_elts]}))
{
  if($all_sets_values[$sub_num_elts]{$v} == 1)
  {
    $count_low_half++;
  }
}

my($all_sum)=offset_square_sum(1,$num_elts);
print ($count_low_half*$all_sum);

sub all_sums
{
  my($start,$end)=@_;
  
  my($max_sub_elements)=int(($end-$start+1)/2);

  my(@all_sets_values)=({0=>1});
  for(my($n)=$end;$n>=$start;$n--)
  {
    my($max_set)=$end-$n+1;
    my($square)=$n*$n;
    push(@all_sets_values,{}) if($max_set <= $max_sub_elements);
    for(my($set_size)=min($max_set,$sub_num_elts)-1;$set_size>=max(0,$max_set-$sub_num_elts-1);$set_size--)
    {
      my($rprev_values)=$all_sets_values[$set_size];
      foreach my $v (keys(%$rprev_values))
      {
        my($sum)=$v + $square;
        Hashtools::increment($all_sets_values[$set_size+1],$sum, $$rprev_values{$v});
      }
    }
  }
  
  return $all_sets_values[$max_sub_elements];
}

sub offset_square_sum
{
  my($start,$end)=@_;
  return Sums::int_square_sum($end) - Sums::int_square_sum($start-1);
}
