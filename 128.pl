use strict;
use warnings;
use Data::Dumper;
use Prime;

# The idea is that yhe only tile where there may have prime 
# differences are the two columns :
# (1,2), 8, 20, 38, 62 ... 
#   (7),19, 37, 61  ...
# On all others, there are 2 differences equal to 1, and 2 other differences are even
#
# The particular cases are the 7 first tiles. With a hand calculation, only 1 and 2 are valid.

my( $tile_count_wanted ) = 2000; 

my($tile_count) = 2; #counting numbers 1 and 2
my($current_tile) = 7;
my($layer)= 2 ;


Prime::init_crible( 1000 );
my( $is_prime_last_inter_layer_diff ) = Prime::fast_is_prime( 19 - 2 );

while( $tile_count < $tile_count_wanted )
{
  #do firsts of layer column
  $current_tile++;
  my( $is_prime_common ) = Prime::fast_is_prime( 6*$layer - 1 );
  my( $is_prime_inter_layer_diff ) = Prime::fast_is_prime( 12*$layer + 5 );
  if( $is_prime_common && $is_prime_inter_layer_diff )
  {
    $tile_count ++ if( Prime::fast_is_prime( 6*$layer + 1 ) );
  }
  
  
  next if( $tile_count == $tile_count_wanted );
  #do lasts of layer column
  $current_tile+= 6*$layer - 1;
  if( $is_prime_common && $is_prime_last_inter_layer_diff )
  {
    $tile_count ++ if( Prime::fast_is_prime( 6*$layer + 5 ) );
  }
  $is_prime_last_inter_layer_diff = $is_prime_inter_layer_diff;
  
  $layer++;
}
print $current_tile;