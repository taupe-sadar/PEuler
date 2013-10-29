use strict;
use warnings;
use Data::Dumper;
use Prime;
use Permutations;

my( $max_solutions ) = 50*10**6;
Prime::init_crible( $max_solutions );

my($count)=0;
$count += nb_solution_arithmetic_progression_difference( $max_solutions,         0, 1  );
$count += nb_solution_arithmetic_progression_difference( int($max_solutions/4) , 0, 0  );
$count += nb_solution_arithmetic_progression_difference( int($max_solutions/16), 1, 0  );

print $count;

sub nb_solution_arithmetic_progression_difference
{
  my( $max_integer, $allow_2_as_prime, $only_3_mod_4 ) = @_;
  my( $counting ) = 0;
  my( $idx)= 1; #2 is never allowed since its imply at least two solutions ...
  while( 1 )
  {
        
    my($pr)=  Prime::getNthPrime( $idx ++ );
    #print "$pr\n";
    if( $pr >= $max_integer )
    {
      last;
    }
    elsif( $only_3_mod_4 && $pr%4 != 3 )
    {
      
    }
    else
    {
      $counting++;
    }
    $idx ++;
    
  }
  return $counting;
}
