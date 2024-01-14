#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use List::Util qw(max min);

my($num_elts)=20;
my($sub_num_elts)=$num_elts/2;

my(%receipe_sums)=();
if( 1 )
{
  #Pattern light
  # for(my($a)=$sub_num_elts-3;$a>=0;$a--)
  # {
    # print "------- $a ----------\n";
    # my($right_border)=$num_elts + $a - $sub_num_elts + 4;
    # my($sum)=offset_square_sum(1,$a) + offset_square_sum($right_border,$num_elts);
    # for(my($offset)=$a+1;$offset+5 < $right_border;$offset++)
    # {
      # my($pattern_sum) = $sum + light_pattern($offset);
      # print "$pattern_sum\n";
      # Hashtools::increment(\%receipe_sums,$pattern_sum, 1);
    # }
    # print "---------------------\n";
    # <STDIN>;
  # }
  
  #Pattern big
  for(my($a)=$sub_num_elts-4;$a>=0;$a--)
  {
    # print "------- $a ----------\n";
    my($right_border)=$num_elts + $a - $sub_num_elts + 5;
    my($sum)=offset_square_sum(1,$a) + offset_square_sum($right_border,$num_elts);
    for(my($offset1)=$a+1;$offset1+6 < $right_border; $offset1++)
    {
      for(my($offset2)=$offset1+4;$offset2+2 < $right_border;$offset2++)
      {
        my($pattern_sum) = $sum + big_pattern($offset1,$offset2);
        print "$pattern_sum\n";
        Hashtools::increment(\%receipe_sums,$pattern_sum, 1);
      }
    }
    # print "---------------------\n";
    # <STDIN>;
  }
  
  
  # exit(0);
}



my(@all_sets_values)=({0=>1});

my(@example)=(0,1,3,6,8,10,11);

for(my($n)=1;$n<=$num_elts;$n++)
{
  my($square)=$n*$n;
  # my($square)=$example[$n];
  push(@all_sets_values,{}) if($n <= $sub_num_elts);
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
  my($rec)="";
  $rec = $receipe_sums{$v} if(exists($receipe_sums{$v}));
  print "$v : => $all_sets_values[$sub_num_elts]{$v}       $rec\n";
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

sub light_pattern
{
  my($offset)=@_;
  
  print "$offset² ".($offset+3)."² ".($offset+4)."² (".($offset+5)."²)\n";


  return squ($offset) + squ($offset+3) + squ($offset + 4);
}

sub big_pattern
{
  my($offset1,$offset2)=@_;
  print "$offset1² ".($offset1+3)."² ".($offset2)."² ".($offset2+1)."² (".($offset2+2)."²)\n";
  return squ($offset1) + squ($offset1+3) + squ($offset2) + squ($offset2 + 1);
}

sub squ
{
  my($x)=@_;
  return $x*$x;
}

