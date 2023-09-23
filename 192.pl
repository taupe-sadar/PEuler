#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use List::Util qw/min max/;
use ContinueFraction;

my($denom_max)=10**12;
my($max_n)=10**5;

my($sum_q)=0;

for(my($n)=1;$n<=$max_n;$n++)
{
  my($squ)=sqrt($n);
  my($isqu)=int($squ);
  next if($isqu*$isqu == $n);

  my($gen)=ContinueFraction::generator_from_integer($n);
  
  my(@qns)=(0,1);
  
  my($a)=ContinueFraction::gen_next($gen);
  my($q)=$a * $qns[0] + $qns[1];
  my($i)=0;
  while($q <= $denom_max )
  {
    @qns = ($q,$qns[0]);
    $a=ContinueFraction::gen_next($gen);
    $q = $a * $qns[0] + $qns[1];
    $i++;
  }
  
  my($b)=floor(($denom_max-$qns[1])/$qns[0]);
  my($ret)=0;
  my($secondary)=$b * $qns[0] + $qns[1];
  if(2*$b < $a )
  {
    $ret = $qns[0];
  }
  elsif( 2*$b > $a )
  {
    $ret = $secondary;
  }
  else
  {
    my($sign)=1;
    my($irr_idx)=$i+1;
    my($q_idx)=$i-1;
    while($q_idx > 0 )
    {
      my($irr_coeff) = ContinueFraction::gen_get($gen,$irr_idx);
      my($q_coeff) = ContinueFraction::gen_get($gen,$q_idx);
      if($irr_coeff != $q_coeff )
      {
        if( $sign * ($irr_coeff - $q_coeff ) > 0 )
        {
          $ret = $secondary;
        }
        else
        {
          $ret = $qns[0];
        }
        last;
      }
      $sign = -$sign;
      $irr_idx++;
      $q_idx--;
    }
    if( $q_idx == 0 )
    {
      if($sign < 0 )
      {
        $ret = $secondary;
      }
      else
      {
        $ret = $qns[0];
      }
    }
  }
  
  $sum_q += $ret;
  
}

print $sum_q;
