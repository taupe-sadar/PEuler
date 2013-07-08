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

my($num_layers)=150;

my(@cuboids)=({},{},{});
my(@layer_occurence_div2)=();

my($target_reached)=0;

my($S) = 3;
my($min_counting) = 3;
my($milestone_layer)= 10;

while( !$target_reached )
{
  visit_a_b_c_cuboids( $S , $milestone_layer  );
  if( (2*$S - 3) > $milestone_layer )
  {
    count_cuboids_no_greater( $min_counting, $S,  $milestone_layer  );
    #print Dumper \@cuboids;<STDIN>;
  
    $target_reached = find_target_occurence( $num_layers, $min_counting, $milestone_layer  );
    
    $min_counting = $milestone_layer+1 ;
    $milestone_layer*=10;
    @cuboids = ({},{},{});
    $S = 2;
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
  my($sum,$triomax)=@_;
  my($maxa)=$sum/3;
  if( $triomax < ($sum**2)/3 )
  {
    $maxa = floor( ( $sum - sqrt( $sum**2 - 3*$triomax ) )/3 );
  }

  my(%cuboids_sum)=();
  for(my($a)=1;$a<= $maxa; $a++)
  {
    my($sum_minus_a)= $sum-$a;
    my($maxb)=$sum_minus_a/2;
    for(my($b)=$a;$b<= $maxb; $b++)
    {
      my($c)= $sum_minus_a-$b;
      my($trio)=$a*$b + $c*($a + $b);
      last if $trio > $triomax;

      
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

