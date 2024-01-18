#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use List::Util qw(max min);
use Sums;

my($num_elts)=100;
my($sub_num_elts)=$num_elts/2;

if( 1 )
{
  my($first)=1;
  my($last)=6;
  
  my($mid)=($last + $first -1)/2;
  my($middle)=int((offset_square_sum($mid+1,$last)+offset_square_sum($first,$mid))/2);
  my($final)=all_sums($first,$last);
  
  foreach my $k (sort({$a<=>$b}keys(%$final)))
  {
    my($delta)=$k - $middle;
    print "$delta -> $$final{$k}\n";
  }
  
  # print Dumper $final;
  exit( 0 );
}



my(@all_sets_values)=({0=>1});
my(@all_sets_details)=({0=>[[]]});

my(@example)=(0,1,3,6,8,10,11);

my($maximum_bound)=Sums::int_square_sum($num_elts)/2;

for(my($n)=$num_elts;$n>=1;$n--)
{
  my($max_set)=$num_elts-$n+1;
  
  # my($square)=$max_set*$max_set;
  my($square)=$n*$n;
  
  # my($square)=$maping*$maping;
  
  
  # my($square)=$example[$n];
  push(@all_sets_values,{}) if($max_set <= $sub_num_elts);
  # push(@all_sets_details,{}) if($max_set <= $sub_num_elts);
  print "--- $n ---\n";
  for(my($set_size)=min($max_set,$sub_num_elts)-1;$set_size>=max(0,$max_set-$sub_num_elts-1);$set_size--)
  {
    my($rprev_values)=$all_sets_values[$set_size];
    foreach my $v (keys(%$rprev_values))
    {
      # if( $v > $maximum_bound)
      # {
        # delete $$rprev_values{$v};
      # }
      # else
      {
        my($sum)=$v + $square;
        next if($sum > $maximum_bound);
        # next if($sum > 47050);
        # $all_sets_values[$set_size+1]{$sum}+=$$rprev_values{$v};
        Hashtools::increment($all_sets_values[$set_size+1],$sum, $$rprev_values{$v});
      }
    }
    
    if($set_size == $sub_num_elts - 1)
    {
      while(exists($all_sets_values[$sub_num_elts]{$maximum_bound}) && $all_sets_values[$sub_num_elts]{$maximum_bound} >= 2)
      {
        $maximum_bound--;
      }
      print "Max bound : $maximum_bound\n";
    }

    next;

    #detailed;
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

# foreach my $v (sort({$a<=>$b} (keys(%{$all_sets_values[$sub_num_elts]}))))
# {
  # print "$v : => $all_sets_values[$sub_num_elts]{$v}\n";
  # if(exists($all_sets_details[$sub_num_elts]{$v}))
  # {
    # my($rall)=$all_sets_details[$sub_num_elts]{$v};
    # for(my($d)=0;$d<=$#$rall;$d++)
    # {
      # print ("    ".join(" ",@{$$rall[$d]})."\n");
    # }
  # }
  # <STDIN>;
# }

# Half : 
# #339 / 679
# 15016516 / 115039000

print $sum;

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
  # for(my($i)=$start;$i<=$end;$i++)
  # {
    # print "$i² ";
  # }
  # print "\n";
  
  return ($end - $start + 1) * ((2*$end + 1)*($start+$end) + 2*$start*($start-1))/6;
}
