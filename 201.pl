#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use List::Util qw(max min);
use Sums;

my($num_elts)=100;
my($sub_num_elts)=$num_elts/2;

my($maximum_bound)=0;

if( 1 )
{
  my($subset_set)=1;
  while(1)
  {
    my($middle) = int((offset_square_sum($subset_set+1,$subset_set*2)+offset_square_sum(1,$subset_set))/2);
    my($final)=all_sums(1,$subset_set*2);

    # print_set($final,0);
    my($min_twice)=$middle;
    $min_twice-- while($$final{$min_twice});
    my($max_twice)=$middle;
    $max_twice++ while($$final{$max_twice});
    
    print "$subset_set : [$min_twice $max_twice]\n";
    # <STDIN>;
    if($max_twice - $min_twice > ($num_elts *2 + 1))
    {
      print "[$min_twice $max_twice]\n";
      print offset_square_sum($subset_set*2 + 1,$num_elts/2+$subset_set);
      $maximum_bound = offset_square_sum($subset_set*2 + 1,$num_elts/2+$subset_set) + $min_twice;
      last;
    }
    $subset_set++;
  }

  # exit( 0 );
}



sub print_set
{
  my($s,$m)=@_;
  foreach my $k (sort({$a<=>$b}keys(%$s)))
    {
      my($delta)=$k - $m;
      print "$delta -> $$s{$k}\n";
    }
}

my(@bound_for_set)=(0,1);
for(my($i)=2;$i<=$sub_num_elts;$i++)
{
  push(@bound_for_set,$bound_for_set[-1],$i*$i);
}

my(@all_sets_values)=({0=>1});
my(@all_sets_details)=({0=>[[]]});

my(@example)=(0,1,3,6,8,10,11);

my($count)=0;

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
    # my($corrected_bound)=$maximum_bound - $bound_for_set[$sub_num_elts - $set_size - 1];
    foreach my $v (keys(%$rprev_values))
    {
      if( $v > $maximum_bound)
      {
        delete $$rprev_values{$v};
      }
      else
      {
        my($sum)=$v + $square;
        next if($sum > $maximum_bound);
        # next if($sum > 47050);
        # $all_sets_values[$set_size+1]{$sum}+=$$rprev_values{$v};
        Hashtools::increment($all_sets_values[$set_size+1],$sum, $$rprev_values{$v});
        # $count++;
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
print "Complex : $count\n";
#11634272
#11772220

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

my($all_sum)=offset_square_sum(1,$num_elts);

print "$sum\n";
print "".(($#all+1)*$all_sum)."\n";

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
  return Sums::int_square_sum($end) - Sums::int_square_sum($start-1);
}
