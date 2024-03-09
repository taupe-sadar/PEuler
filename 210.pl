#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

# The region defined by |x| + |y| <= r, is a square centered in O, rotated by pi/4
# which summits are (0,r), (r,0), (0,-r), (-r,0).
#
# There are 3 ways to a OBC to be obtuse
#  - x + y > r/2 ( C angle obtuse )
#  - x + y < 0   ( 0 angle obtuse )
#  - (x,y) is strictly inside the circle of diameter OC
# Within all those points, the ones in the line (OC) must be excluded, O,B,C cant be aligned.
#
# We suppose that r is divisible by 8 so that the circle is centered on a integer point.
#
# The first 2 sets can be divided into 6 regions of r/2*r/2
#
# 
# For the calculation of the points into the circle (of radius R=sqrt(2)*r/8). 3 area are considered : 
# - The 8 rounded parts, one of them such that x is in [ R/sqrt(2); R], y > 0. (the other are obtained by symetry)
#   for all x in this set we look for y(x) maximizing y^2 + x^2 < R^2.
# - The 4 squares such that 0 < x < R/sqrt(2) , 0 < y < R/sqrt(2). (the other are obtained by symetry)
#   Their size is R^2/2, and we must verify that the upper corner is not exactly on the circle.
# - The 2 diameters (of 4 radius), and the center, also verifying to not include a point exactly in the circle.
#
# With that way of counting, no sqrt or multiplication is made, as a good optimization, using 
# (y-1)^2 = y^2 - 2*y + 1 


my($r)=10**9;

my($external_points)=($r/2)*($r/2)*6;
my($border_circle_points)=0;
my($diagonal)=$r/4-1;
my($internal_points)=circle_points($r*$r/32);


print ($external_points + $internal_points - $diagonal);

sub circle_points
{
  my($r2)=@_;
  my($x_middle)=opposite_floor(sqrt($r2/2));
  my($x_end)=opposite_floor(sqrt($r2));
  
  my($x2)=($x_middle+1)**2;
  my($y)=($r2 >= $x2)?opposite_floor(sqrt($r2 - $x2)):0;
  my($y2)=$y**2;
  
  
  my($count)=0;
  if( $y2 + $x2 < $r2 )
  {
    $y2 += $y*2 + 1;
    $y++;
  }
  
  for(my($x)=$x_middle+1;$x<= $x_end; $x++)
  {
    $y2 += -$y*2 + 1;
    $y --;
    
    while( $y2 + $x2 >= $r2 )
    {
      $y2 += -$y*2 + 1;
      $y--;
    }
    $count += $y;
    $x2+=2*$x + 1;
  }
  
  return 8*$count + 4*$x_middle**2 + 4*$x_end + 1;
}

sub opposite_floor
{
  my($x)=@_;
  return -floor(-$x)-1;
}

