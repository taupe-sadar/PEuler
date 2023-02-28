use strict;
use warnings;
use Data::Dumper;
use Gcd;

# First, if a triangle is valid, any triangle obtained by moving one point along its radius 
# is a valid triangle. Let us find all radius, and how many points it contains.
#
# Next if we consider 3 distincts diameters, each diameter containing exactly one summit of triangles.
# There are two possibilities for a summit on each diameter, so there are 2*2*2 = 8 ways to build 
# a triangle that way.
# It can be seen that only 2 / 8 triangles are valid. Exactly 1 of the 2, has 2 summits in radius which 
# angles radius are in [0, pi[, (the other has summits in [pi, 2pi[, by symetry).
#
# If we order the possible radius with their angle, r_0 < r_1 < ... < r_n
# If we take 2 summits on 2 of these differents radius, r_i < r_j, then a valid summit 
# is on the opposite of radius r_k, with r_i < r_k < r_j, so k is in [ i+1 , j-1 ]
# 
# If a radius r_i contains p_i points, all possible triangles (with radius angle in [0 , pi[ )are :
# T = sum( p_i * p_j * p_k ) with i < j < k, and our solution is 2 * T
# 
# With S = sum(p_i), Q = sum(p_i^2), C = sum(p_i^3)
# By derivating S^3, we have : 
# S^3 = 6T + 3QS - 2C
#
# Finally
#
# T = ((S^2 - 3Q) * S + 2C)/6

my($radius)=105;

my(%ratios)=("0/1" => {"num"=> $radius-1, "ratio" => [0,1]});

my($y)=1;
my($sqy)=$y*$y;
my($sqradius)=$radius*$radius;
while( 2*$sqy < $sqradius )
{
  my($x)=$y;
  while($x*$x + $sqy < $sqradius)
  {
    my($d)=Gcd::pgcd($x,$y);
    my($numerator,$denominator)=($y/$d,$x/$d);
    my($key)="$numerator/$denominator";
    if(!exists($ratios{$key}))
    {
      $ratios{$key} = {"num"=> 0, "ratio" => [$numerator,$denominator]};
    }
    $ratios{$key}{"num"}++;
    $x++;
  }
  $y++;
  $sqy=$y*$y;
}

my(@ratios_occ)=();
foreach my $rv (sort sort_radius_fn values(%ratios))
{
  push(@ratios_occ,$$rv{"num"});
}

my($num_angles)=$#ratios_occ;

# print "$num_angles\n";

my($sum,$squares,$cubes)=(0,0,0);
for(my($i)=1;$i<$#ratios_occ;$i++)
{
  my($x)=$ratios_occ[$i];
  my($xx) = $x*$x;
  $sum+=$x;
  $squares+=$xx;
  $cubes+=$xx*$x;
}
my($S)=$sum*4 + $ratios_occ[0]*2 + $ratios_occ[-1]*2;
my($Q)=$squares*4 + $ratios_occ[0]*$ratios_occ[0]*2 + $ratios_occ[-1]*$ratios_occ[-1]*2;
my($C)=$cubes*4 + $ratios_occ[0]*$ratios_occ[0]*$ratios_occ[0]*2 + $ratios_occ[-1]*$ratios_occ[-1]*$ratios_occ[-1]*2;

my($all) = (( $S * $S -3 * $Q )*$S + 2 * $C)/6 * 2;

print $all;

sub sort_radius_fn
{
  return $$a{"ratio"}[0]* $$b{"ratio"}[1] <=> $$b{"ratio"}[0]*$$a{"ratio"}[1];
}