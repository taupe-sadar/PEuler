#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use List::Util qw(max min);

my($num_elts)=20;
my($sub_num_elts)=$num_elts/2;

my(@all_sets_values)=({0=>1});
my(@all_sets_details)=({0=>[[]]});

my(@example)=(0,1,3,6,8,10,11);

for(my($n)=1;$n<=$num_elts;$n++)
{
  my($square)=$n*$n;
  # my($square)=$example[$n];
  push(@all_sets_values,{}) if($n <= $sub_num_elts);
  push(@all_sets_details,{}) if($n <= $sub_num_elts);
  print "--- $n ---\n";
  for(my($set_size)=min($n,$sub_num_elts)-1;$set_size>=max(0,$n-$sub_num_elts-1);$set_size--)
  {
    my($rprev_values)=$all_sets_values[$set_size];
    foreach my $v (keys(%$rprev_values))
    {
      my($sum)=$v + $square;
      # next if($sum >= 46000);
      # $all_sets_values[$set_size+1]{$sum}+=$$rprev_values{$v};
      Hashtools::increment($all_sets_values[$set_size+1],$sum, $$rprev_values{$v});
    }
    
    my($rprev_detailed)=$all_sets_details[$set_size];
    foreach my $v (keys(%$rprev_detailed))
    {
      my($sum)=$v + $square;
      if( $sum <= 700 )
      {
        if(!exists($all_sets_details[$set_size+1]{$sum}))
        {
          $all_sets_details[$set_size+1]{$sum} = [];
        }
        my($rall)=$$rprev_detailed{$v};
        for(my($d)=0;$d<=$#$rall;$d++)
        {
          push(@{$all_sets_details[$set_size+1]{$sum}},[@{$$rall[$d]},$n]);
        }
      }
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

foreach my $v (sort({$a<=>$b} (keys(%{$all_sets_values[$sub_num_elts]}))))
{
  print "$v : => $all_sets_values[$sub_num_elts]{$v}\n";
  if(exists($all_sets_details[$sub_num_elts]{$v}))
  {
    my($rall)=$all_sets_details[$sub_num_elts]{$v};
    for(my($d)=0;$d<=$#$rall;$d++)
    {
      print ("    ".join(" ",@{$$rall[$d]})."\n");
    }
  }
  <STDIN>;
}

# Half : 
# #339 / 679
# 15016516 / 115039000

print $sum;

sub offset_square_sum
{
  my($start,$end)=@_;
  for(my($i)=$start;$i<=$end;$i++)
  {
    print "$i² ";
  }
  print "\n";
  
  return ($end - $start + 1) * ((2*$end + 1)*($start+$end) + 2*$start*($start-1))/6;
}
