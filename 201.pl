#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use List::Util qw(max min);
use Sums;

# 

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
  
  if($max_twice - $min_twice > ($num_elts *2 + 1))
  {
    $maximum_bound = offset_square_sum($subset_set*2 + 1,$num_elts/2+$subset_set) + $min_twice;
    last;
  }
  $subset_set++;
}

my(@all_sets_values)=({0=>1});
my(@all_sets_details)=({0=>[[]]});

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
