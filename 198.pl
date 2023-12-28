#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my($max_denom)=10**8;

my($a1)=100;
my($num)=0;
while(1)
{
  my($n)=count_ambiguious_starting_with([$a1]);
  last if($n == 0);
  $num+=$n;
  $a1++;
}
$num += ($max_denom - 100)/2;
print $num;

sub count_ambiguious_starting_with
{
  my($frac)=@_;
  my($count)=0;
  
  my($middle)=2;
  while(1)
  {
    my($c)=calc_denom($frac,$middle);
    last if($c > $max_denom);
    $count ++;
    $middle+=2;
  }
  return 0 if($middle==2);
  
  my($a)=1;
  while(1)
  {
    my($c) = count_ambiguious_starting_with([@$frac,$a]);
    last if( $c == 0 );
    $count+=$c;
    $a++;
  }
  return $count;
}

sub calc_denom
{
  my($f,$mid)=@_;
  my($qn,$qn_1) = (0 , 1);
  ($qn,$qn_1) = ($qn_1,$qn);
  for(my($i)=0;$i<=$#$f;$i++)
  {
    ($qn,$qn_1) = ($qn * $$f[$i] + $qn_1,$qn);
  }
  ($qn,$qn_1) = ($qn * $mid + $qn_1,$qn);
  for(my($i)=$#$f;$i>=0;$i--)
  {
    ($qn,$qn_1) = ($qn * $$f[$i] + $qn_1,$qn);
  }
  return $qn;
}