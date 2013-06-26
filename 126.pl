use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );
use Hashtools;

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

while( !$target_reached )
{
  visit_a_b_c_cuboids( $S );
  if( $S >= $milestone )
  {
    count_cuboids_no_greater( $min_counting, 2*$S + 1  );
    
    $target_reached = find_target_occurence( $num_layers, $min_counting, 2*$S +1 );
    
    $milestone*=2;
    $min_counting = 2*$S+2;
     
  }
  $S++;
}

print $target_reached;

sub visit_a_b_c_cuboids
{
  my($sum)=@_;
  my($mina)=max( 2, $sum/3 );
  my(%cuboids_sum)=();
  for(my($a)=$sum-2;$a>= $mina; $a--)
  {
    my($sum_minus_a)= $sum-$a;
    for(my($b)=$a;$b>= $sum_minus_a/2; $b--)
    {
      my($sum_minus_a_b)= $sum_minus_a-$b;
      my($trio_ab)= $a*$b;
      for(my($c)=$b;$c>=1; $c--)
      {
        my($trio)=$trio_ab + $c*($a + $b);
        if( !exists( $cuboids_sum{ $trio } ) )
        {
          $cuboids_sum{$trio}={ "occurence" => 1 ,"layer" => 0 ,"value"=> 0 }; 
        }
        else
        {
          $cuboids_sum{$trio}{ "occurence" }++;
        }
      }
    }
  }
  $cuboids[$sum] = \%cuboids_sum;
}

sub count_cuboids_no_greater
{
  my($min, $max ) = @_;
  for(my($i)=$min;$i<=$max;$i++)
  {
    $layer_occurence_div2[ $i ] = 0;
  }
  
  
  for(my($i)=3;$i<=$max;$i++)
  {
    my($trio)=0;
    foreach  $trio (keys( %{$cuboids[$i]} ))
    {
      next if( $trio > $max );
      my($occ)= $cuboids[$i]{$trio}{"occurence"};
      if( $cuboids[$i]{$trio}{"layer"} == 0 )
      {
        $cuboids[$i]{$trio}{"layer"} = 1;
        $cuboids[$i]{$trio}{"value"} = $trio;
        $layer_occurence_div2[ $trio ] += $occ  ;
      }
      
      while( $cuboids[$i]{$trio}{"value"} <= $max )
      {
        my($new_value) = $cuboids[$i]{$trio}{"value"} + $trio * 2 + ( $cuboids[$i]{$trio}{"layer"} - 1 )*6;

        $cuboids[$i]{$trio}{"layer"} ++;
        $cuboids[$i]{$trio}{"value"} = $new_value;
        $layer_occurence_div2[ $new_value ] += $occ  ;
      }
    }
  }
}

sub find_target_occurence
{
  my($asked_layers,$min,$max)=@_;
  for( my($i)=$min;$i<=$max;$i++)
  {
    return $i if $layer_occurence_div2[ $i ] = $asked_layers;
  }
  return 0;
}

