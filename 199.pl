#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/round/;

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