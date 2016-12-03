use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use List::Util qw( sum max min );
use Hashtools;

# Visiting all 1 <= a <= b <= c ,
# Looping over S = a + b + c.
# After each S we have all cuboids with 
# trio(a,b,c) = ab + ac + bc <= 2S - 3 

my($num_layers)=1000;

my(@layer_occurence_div2)=();

my($target_reached)=0;

my($S) = 3;
my($min_counting) = 3;
my($milestone_layer)= 10;

init_layer_occ( $milestone_layer );

while( 1 )
{
  visit_a_b_c_cuboids( $S , $milestone_layer  );
  if( (2*$S - 3) > $milestone_layer )
  {
  
    $target_reached = find_target_occurence( $num_layers, $min_counting, $milestone_layer  );
    last if $target_reached;

    $min_counting = $milestone_layer+1 ;
    $milestone_layer*=10;
    init_layer_occ( $milestone_layer );
    $S = 2;
  }
  $S++;
}


print ($target_reached*2);

sub visit_a_b_c_cuboids
{
  my($sum,$triomax)=@_;
  my($maxa)=$sum/3;
  if( $triomax < ($sum**2)/3 )
  {
    $maxa = floor( ( $sum - sqrt( $sum**2 - 3*$triomax ) )/3 );
  }

  for(my($a)=1;$a<= $maxa; $a++)
  {
    my($sum_minus_a)= $sum-$a;
    my($maxb)=$sum_minus_a/2;
    for(my($b)=$a;$b<= $maxb; $b++)
    {
      my($c)= $sum_minus_a-$b;
      my($trio)=$a*$b + $c*($a + $b);
      last if $trio > $triomax;

      
      count_cuboids_no_greater( $sum,$trio,$triomax );
    }
  }
}

sub count_cuboids_no_greater
{
  my( $sum, $trio, $max_value_for_layer )= @_;
  my($layer)=1;
  my($layer_count)=$trio;
  while( $layer_count <= $max_value_for_layer)
  {
    $layer_occurence_div2[ $layer_count ] ++  ;
    $layer_count +=  $sum * 2 + ( $layer - 1 )*4;
    $layer++;
  }
}

sub find_target_occurence
{
  my($asked_layers,$min,$max)=@_;
  for( my($i)=$min;$i<=$max;$i++)
  {
    return $i if(defined( $layer_occurence_div2[ $i ]) && $layer_occurence_div2[ $i ] == $asked_layers );
  }
  return 0;
}

sub init_layer_occ
{
  my($max)= @_;
  for(my($i)=3;$i<=$max;$i++ )
  {
    $layer_occurence_div2[$i] = 0;
  }
}

