#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use List::Util qw(max min);

my($num_elts)=100;
my($sub_num_elts)=$num_elts/2;

my(@all_sets_values)=({0=>1});

my(@example)=(0,1,3,6,8,10,11);

for(my($n)=1;$n<=$num_elts;$n++)
{
  my($square)=$n*$n;
  # my($square)=$example[$n];
  push(@all_sets_values,{}) if($n <= 50);
  print "--- $n ---\n";
  for(my($set_size)=min($n,$sub_num_elts)-1;$set_size>=max(0,$n-$sub_num_elts-1);$set_size--)
  {
    my($rprev_values)=$all_sets_values[$set_size];
    foreach my $v (keys(%$rprev_values))
    {
      my($sum)=$v + $square;
      next if($sum >= 50000);
      # $all_sets_values[$set_size+1]{$sum}+=$$rprev_values{$v};
      Hashtools::increment($all_sets_values[$set_size+1],$sum, $$rprev_values{$v});
    }
  }
  # print Dumper \@all_sets_values;
  # <STDIN>;
}

my($sum)=0;
my(@all)=();
foreach my $v (keys(%{$all_sets_values[$sub_num_elts]}))
{
  if($all_sets_values[$sub_num_elts]{$v} == 1)
  {
    push(@all,$v);
    $sum+=$v;
  }
}
# print Dumper \@all_sets_values;

@all=sort({$a<=>$b}@all);
# print Dumper \@all;
print "# $#all\n";

# Half : 
# #339 / 679
# 15016516 / 115039000

print $sum;
