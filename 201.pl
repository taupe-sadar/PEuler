#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use List::Util qw(max min);

my(@all_sets_values)=({0=>1});

for(my($n)=1;$n<=100;$n++)
{
  my($square)=$n*$n;
  push(@all_sets_values,{}) if($n <= 50);
  print "--- $n ---\n";
  for(my($set_size)=min($n,50)-1;$set_size>=max(0,$n-50);$set_size--)
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
foreach my $v (keys(%{$all_sets_values[50]}))
{
  if($all_sets_values[50]{$v} == 1)
  {
    push(@all,$v);
    $sum+=$v;
  }
}
@all=sort({$a<=>$b}@all);
print Dumper \@all;
print "# $#all\n";
print $sum;
