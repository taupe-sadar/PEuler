#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

# Brute force : 1598174770174689458
# bug :         1598174769467582681

# (x-r/8)^2 + (y-r/8)^2 = (r/8)^2*2
# (8x-r)^2 = (r)^2*2 - (8y-r)^2
# (8x-r)^2 = (r*sqrt(2) - 8y + r )*(r*sqrt(2) + 8y - r)
# 8x = r +/- sqrt(...)
my($r)=10**9;

my($external_points)=($r/2)*($r/2)*6;
my($border_circle_points)=0;
my($diagonal)=$r/4-1;

my($internal_points)=circle_points($r*$r/32);



print ($external_points + $internal_points - $diagonal);

sub internal_points_bf
{
  my($r)=@_;
  my($r2)=$r*sqrt(2);

  my($internal_points)=0;
  my($y_min,$y_max)=(ceil(-$r2/8+$r/8),floor($r2/8+$r/8));
  for(my($y)=$y_min;$y<=$y_max;$y++)
  {
    my($yd)=8*$y - $r;
    my($x_base)=sqrt(($r2 - $yd)*($r2 + $yd));
    
    my($xmin)=floor(($r-$x_base)/8+1);
    my($xmax)=ceil(($r+$x_base)/8-1);

    # print "$y $xmin $xmax\n";
    my($points)=$xmax-$xmin+1;
    # $points-- if($xmin == ($r-$x_base)/8);
    # $points-- if($xmax == ($r+$x_base)/8);
    
    $internal_points += $points;
    print "$y\n" if($y%100000 == 0);
  }
  
}


sub circle_points
{
  my($r2)=@_;
  my($x_middle)=floor(sqrt($r2/2));
  my($x_end)=floor(sqrt($r2));
  
  my($x2)=($x_middle+1)**2;
  my($y)=floor(sqrt($r2 - $x2));
  my($y2)=$y**2;
  
  my($count)=0;
  for(my($x)=$x_middle+1;$x<= $x_end; $x++)
  {
    
    while( $y2 + $x2 >= $r2 )
    {
      $y2 += -$y*2 + 1;
      $y--;
    }
    print "$x : $y\n" if( $x%100000 == 0);
    $count += $y;
    $x2+=2*$x + 1;
  }
  return 8*$count + 4*$x_middle**2;
}

