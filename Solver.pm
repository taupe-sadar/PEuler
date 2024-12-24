package Solver;
use strict;
use POSIX qw/floor ceil/;

sub solve
{
  my($func,$min,$max,$step,$precision)=@_;
  my(@sampling)=();
  for(my($p)=$min;$p<$max;$p+=$step)
  {
    push(@sampling,[$p,$func->($p)]);
  }
  push(@sampling,[$max,$func->($max)]);
  my(@sols)=();
  for(my($s)=0;$s<$#sampling;$s++)
  {
    if($sampling[$s][1] >= 0 && $sampling[$s+1][1] <= 0)
    {
      push(@sols,dicho_solve($func,$sampling[$s+1][0],$sampling[$s][0],$precision));
    }
    elsif( $sampling[$s][1] <= 0 && $sampling[$s+1][1] >= 0 )
    {
      push(@sols,dicho_solve($func,$sampling[$s][0],$sampling[$s+1][0],$precision));
    }
  }
  return @sols;
}

sub dicho_solve
{
  my($func,$low,$high,$precision)=@_;
  while(abs($high-$low) > $precision)
  {
    
    my($mid)=($low+$high)/2;
    
    my($mid_val)=$func->($mid);
    
    if( $mid_val > 0 )
    {
      $high = $mid;
    }
    elsif( $mid_val < 0 )
    {
      $low = $mid;
    }
    else
    {
      return $mid;
    }
  }
  return ($low+$high)/2;
}

# Assuming increasing function, gives largest integer
# strictly inferior to a given max

sub solve_no_larger_integer
{
  use integer;
  my($func,$start,$max)=@_;
  $max = 0 unless(defined($max));
  my($low,$high)=(0,0);
  my($first_val)=$func->($start);
  if($first_val >= $max)
  {
    $high = $start;
    my($val)=floor($start/2);
    while($func->($val) >= $max)
    {
      $high = $val;
      return -1 if($val == 0);
      $val = floor($val/2);
    }
    $low = $val;
  }
  else
  {
    $low = $start;
    my($val)=$start*2;
    while($func->($val) < $max)
    {
      $low = $val;
      return -1 if($val >= (1<<31));
      $val = $val*2;
    }
    $high = $val;
  }
  
  while(($high-$low) > 1)
  {
    my($mid)=floor(($low+$high)/2);
    if( $func->($mid) >= $max )
    {
      $high = $mid;
    }
    else
    {
      $low = $mid;
    }
  }
  return $low;
}

1;