package TriangleData;
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );

sub get_max_path
{
  my($ref)=@_;

  my(@MAXSUM)=();
  $MAXSUM[0][0]=$$ref[0][0];
  for(my($i)=1;$i<=$#$ref;$i++)
  {
    $MAXSUM[$i][0]=$MAXSUM[$i-1][0]+$$ref[$i][0];
    for(my($j)=1;$j<$i;$j++)
    {
      $MAXSUM[$i][$j]=max($MAXSUM[$i-1][$j-1],$MAXSUM[$i-1][$j])+$$ref[$i][$j];
    }
    $MAXSUM[$i][$i]=$MAXSUM[$i-1][$i-1]+$$ref[$i][$i];
  }
  
  my($max)=0;
  
  for(my($i)=0;$i<=$#{$MAXSUM[$#MAXSUM]};$i++)
  {
    $max=max($max,$MAXSUM[$#MAXSUM][$i]);
  }
  return $max;
}

1;
