#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( min max );

my($num_codes)=500;

my(@skew)=(0,0,5);
my(@diffs)=(-1,-1,5);

my(@milestones)=(0)x$skew[-1];
push(@milestones,$#skew);

for(my($n)=3;$n<=$num_codes;$n++)
{
  my($minimum)=$n*4 + $skew[-1];
  for(my($i)=1;$i<$n;$i++)
  {
    $minimum = min($minimum, 4*$i + ( $n - $i ) + $skew[$i] + $skew[$n - $i]);
  }
  
  push(@skew,$minimum);
  my($diff)=($skew[-1] - $skew[-2]);
  my($mile_str)="";
  if( $diff > $diffs[-1] )
  {
    $mile_str = " -> (m_$diff : $n)";
    push(@milestones,$n);
  }
  push(@diffs,$diff);
  print "$n : $minimum ($diff)$mile_str\n";
}

print "-----------\n";

for(my($i)=0; $i <= $#milestones; $i++)
{
  print "m_$i : $milestones[$i]\n";
}

print "-----------\n";

my(@lm)=(1)x4;

my($d)=9;
my($mm)=6;
while($mm<=$num_codes)
{
  my($new_l)=$lm[3]+$lm[0];
  shift(@lm);
  push(@lm,$new_l);
  $d++;
  $mm+=$new_l;
  print "$d : $new_l -> $mm\n";
  # print Dumper \@lm;<STDIN>;
  
}







