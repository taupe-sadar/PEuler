#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/round/;

# Having 3 tangeants circles of radius (a,b,c), of centers ABC, and the inner tangeant, with radius r , and center R.
# The projection Pb of B on (AR) gives : 
# APb = ((a+b)^2 - (b+r)^2 - (a+r)^2)/( 2*(a+r) )
# BPb = sqrt((a+b+r)*a*b*r)*2/(a+r)
# 
# Simillary : The projection Pc of C on (AR) gives : 
# APc = ((a+c)^2 - (c+r)^2 - (a+r)^2)/( 2*(a+r) )
# CPc = sqrt((a+c+r)*a*c*r)*2/(a+r)
#
# Then by calculating BC^2 = (APb - APc)^2 + (BPb + CPc)^2, we obtain : 
#   (a+r)^2*(b+c)^2 = (a-r)^2*(b-c)^2 + 4*a*r*(sqrt((a+c+r)*c) - sqrt((a+b+r)*b))^2
#   r^2(bc-ac-ab) - r*a^2(b+c) + a^2*bc = -2ar*sqrt((a+c+r)(a+b+r)*bc)
# This leads to a 4th degree equation(in r), factorisable by (a+r)^2
#     r^4(b^2c^2 + b^2a^2 + c^2a^2 - 2*a^2*bc - 2*ab^2c - 2*abc^2)
#   + r^3(-6a^2*b^2*c -6a^2*b*c^2 - 4*a^3*bc + 2a^3*c^2 + 2a^2*c^3)
#   + r^2(-2*a^2*b^2*c^2 - 6*a^3*b^2*c - 6*a^3*b*c^2 - 2*a^4*bc + a^4*c^2 + a^2*c^4)
#   + r (-2*a^4*b^2*c -2*a^4*b*c^2 )
#   + a^4*b^2*bc^2 = 0
#   <=>
#   (r+a)^2 * (r^2*(b^2c^2 + b^2a^2 + c^2a^2 - 2*a^2*bc - 2*ab^2c - 2*abc^2) - 2r(a^2*b^2*c + a^2*b*c^2 + a*b^2*c^2) + a^2*b^2*c^2) = 0
# The second factor may be rewritten as (dividing by (abc)^2): 
#    (r^2*(1/a^2 + 1/b^2 + 1/c^2 - 2/ab - 2/ac - 2/bc) - 2r(1/a + 1/b + 1/c) + 1) = 0
# Which is almost the Decartes theoreme about 4 tangeants cicles, written as : 
#    (1/a + 1/b + 1/c + 1/d)^2 = 2*(1/a^2 + 1/b^2 + 1/c^2 + 1/d^2)
#
# Then its more interesting to consider the curvature instead of the radius, with (ca=1/a cb=1/b cc=1/c cr=1/r)
#    cr^2 -2cr*(ca+cb+cc) + (1/ca^2 + 1/cb^2 + 1/cc^2 - 2/ca*cb - 2/ca*cc - 2/cb*cc) = 0
# And finally : 
#    1/r = cr = ca + cb + cc + 2*sqrt(1/ca*cb + 1/ca*cc + 1/cb*cc) = 1/a + 1/b +1/c + 2*sqrt(1/ab + 1/ac + 1/bc)
# 
# The same method may be applied for the space between 2 circles and bigger circle containing it, by replacing a by -a,(a being the radius of the bigger circle)


my($max_iteration)=10;
my($precision)=10**8;

my($c0)=1+2*sqrt(3)/3;
my($c1)=tangeant_circle_curvature($c0,$c0,$c0);

my($surface_ratio)=1;
$surface_ratio -= 3/($c0*$c0) + 3 * sum_square_radius($c0,$c0,-1,1,1,$max_iteration);
$surface_ratio -= 1/($c1*$c1) + 3 * sum_square_radius($c0,$c0,$c1,1,2,$max_iteration);

print round($surface_ratio*$precision)/$precision;

sub tangeant_circle_curvature
{
  my($ca,$cb,$cc)=@_;
  return $ca+$cb+$cc+ 2*sqrt($ca*$cb+$ca*$cc+$cb*$cc);
}

sub sum_square_radius
{
  my($ca,$cb,$cc,$symetry_ab,$depth,$max_depth)=@_;
  
  my($curv)=tangeant_circle_curvature($ca,$cb,$cc);
  my($sum_square_rad)= 1/($curv*$curv);
  if( $depth < $max_depth)
  {
    if( $symetry_ab )
    {
      $sum_square_rad += sum_square_radius($ca,$cb,$curv,1,$depth+1,$max_depth);
      $sum_square_rad += 2*sum_square_radius($ca,$cc,$curv,0,$depth+1,$max_depth);
    }
    else
    {
      $sum_square_rad += sum_square_radius($ca,$cb,$curv,0,$depth+1,$max_depth);
      $sum_square_rad += sum_square_radius($ca,$cc,$curv,0,$depth+1,$max_depth);
      $sum_square_rad += sum_square_radius($cb,$cc,$curv,0,$depth+1,$max_depth);
    }
  }
  return $sum_square_rad;
}