#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

my($max)=2**50;
my($max_sq2)=floor(sqrt($max));

my($crible_size)=ceil(($max_sq2+1)/6)*2;
my(@crible)=(0)x$crible_size;

my($num_squared)=0;

my($p)=5;
for(my($i)=1;$i<$crible_size;$i++)
{
  if( $crible[$i] == -1)
  {
    $p+=($i%2==0)?4:2;
    next;
  }
  
  my($p2)=$p*$p;
  if( $crible[$i] == 0)
  {
    #remove squares
    
    for(my($square_idx)=($p2-1)/3;$square_idx<=$#crible;$square_idx+=2*$p2)
    {
      $crible[$square_idx]=-1;
    }
    
    for(my($square_idx)=(5*$p2-2)/3;$square_idx<=$#crible;$square_idx+=2*$p2)
    {
      $crible[$square_idx]=-1;
    }

    #remember p multiples
    my($doublep)=2*$p;
    my($modp)=$p%3;
    for(my($pidx)=($p - $modp)/3;$pidx<=$#crible;$pidx+=$doublep)
    {
      $crible[$pidx]++ if( $crible[$pidx] != -1);
    }
    for(my($pidx)=(5*$p + $modp)/3 - 1;$pidx<=$#crible;$pidx+=$doublep)
    {
      $crible[$pidx]++ if( $crible[$pidx] != -1);
    }
  }

  #count squared
  my($sign)=(($crible[$i]%2==0)?-1:1);
  $num_squared += $sign*floor($max/$p2);
  $num_squared -= $sign*floor($max/$p2/4);
  $num_squared -= $sign*floor($max/$p2/9);
  $num_squared += $sign*floor($max/$p2/36);

  $p+=($i%2==0)?4:2;
}
$num_squared += floor($max/4);
$num_squared += floor($max/9);
$num_squared -= floor($max/36);

print ($max - $num_squared);
