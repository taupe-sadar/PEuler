package Solver;
use strict;

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

1;