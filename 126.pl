use strict;
use warnings;
use Data::Dumper;

# Visiting all a >= b >= c >=1,
# Looping over S = a + b + c.
# After each S we have all cuboids with 
# trio(a,b,c) = ab + ac + bc <= 2S + 1 

my($num_layers)=100;

my(@cuboids)=({},{},{});
my(@layer_occurence_div2)=();

my($target_reached)=0;

my($S) = 3;
my($min_counting) = 3;
my($milestone)= 10;

while( $target_reached )
{
  visit_a_b_c_cuboids( $S );
  if( $S >= $milestone )
  {
    count_cuboids_no_greater( $min_counting, 2*$S + 1  );
    $milestone*=2;
    $min_counting = 2*$S+2;
    $target_reached = find_target_occurence( $num_layers); 
  }
  $S++;
}

sub visit_a_b_c_cuboids
{
  
}

sub count_cuboids_no_greater
{

}

sub find_target_occurence
{
  return 1;
}

