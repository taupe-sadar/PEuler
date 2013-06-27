use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum max min );
use Hashtools;

# Visiting all a >= b >= c >=1,
# Looping over S = a + b + c.
# After each S we have all cuboids with 
# trio(a,b,c) = ab + ac + bc <= 2S + 1 

my($num_layers)=10;

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
    count_cuboids_no_greater( $min_counting, $S, 2*$S - 3   );
    #print Dumper \@cuboids;<STDIN>;
  
    $target_reached = find_target_occurence( $num_layers, $min_counting, 2*$S  -3 );
    
    $milestone*=2;
    $min_counting = 2*$S - 2;
     
  }
  $S++;
}

for(my($i)=3;$i<=$#layer_occurence_div2;$i++)
{
  print "".(2*$i)." : ".($layer_occurence_div2[$i])."\n";
}

print $target_reached*2;

sub visit_a_b_c_cuboids
{
  my($sum)=@_;
  my($mina)=$sum/3;
  my(%cuboids_sum)=();
  for(my($a)=$sum-2;$a>= $mina; $a--)
  {
    my($sum_minus_a)= $sum-$a;
    my($minb)=$sum_minus_a/2;
    my($firstb)= min($a, $sum_minus_a - 1);
    for(my($b)=$firstb;$b>= $minb; $b--)
    {
      my($c)= $sum_minus_a-$b;
      my($trio)=$a*$b + $c*($a + $b);
      if( !exists( $cuboids_sum{ $trio } ) )
      {
        $cuboids_sum{$trio}={ "occurence" => 1 ,"layer" => 0 ,"value"=> 0 }; 
      }
      else
      {
        $cuboids_sum{$trio}{ "occurence" }++;
      }
      # sum( $a, $b,$c )== $sum or die " sum( $a, $b,$c ) != $sum ";
      # print "ABC : ($a,$b,$c)\n";
    }
  }
  $cuboids[$sum] = \%cuboids_sum;
}

sub count_cuboids_no_greater
{
  my($min, $max , $max_layer ) = @_;
  for(my($i)=$min;$i<=$max_layer;$i++)
  {
    $layer_occurence_div2[ $i ] = 0;
  }
  
  
  for(my($i)=3;$i<=$max;$i++)
  {
    my($trio)=0;
    foreach  $trio (keys( %{$cuboids[$i]} ))
    {
      next if( $trio > $max_layer );
      my($occ)= $cuboids[$i]{$trio}{"occurence"};
      if( $cuboids[$i]{$trio}{"layer"} == 0 )
      {
        $cuboids[$i]{$trio}{"layer"} = 1;
        $cuboids[$i]{$trio}{"value"} = $trio;
      }
      
      while( $cuboids[$i]{$trio}{"value"} <= $max_layer )
      {
        $layer_occurence_div2[ $cuboids[$i]{$trio}{"value"} ] += $occ  ;
        my($new_value) = $cuboids[$i]{$trio}{"value"} + $i * 2 + ( $cuboids[$i]{$trio}{"layer"} - 1 )*4;

        $cuboids[$i]{$trio}{"layer"} ++;
        $cuboids[$i]{$trio}{"value"} = $new_value;
        
      }
    }
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

