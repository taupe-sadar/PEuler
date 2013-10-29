use strict;
use warnings;
use Data::Dumper;
use Prime;
use Permutations;

#It is the same problem as #135.
# But in much simpler. So copy pasted, and simplified

my( $max_solutions ) = 50*10**6;
Prime::init_crible( $max_solutions );

my($count)=0;
$count += nb_solution_arithmetic_progression_difference( $max_solutions,         0, 1  );
$count += nb_solution_arithmetic_progression_difference( int($max_solutions/4) , 0, 0  );
$count += nb_solution_arithmetic_progression_difference( int($max_solutions/16), 1, 0  );

# For the solution : 1 is missing : Not valid in first seek ( 1 % 4 != 3 )
# But there are valid solutions : 1 * 4 and 1 * 16 
$count += 2;
print $count;

sub nb_solution_arithmetic_progression_difference
{
  my( $max_integer, $allow_2_as_prime, $only_3_mod_4 ) = @_;
  my( $counting ) = 0;
  my( $idx)= 1; #2 is never allowed since its imply at least two solutions ...
  my($pr)=  Prime::getNthPrime( $idx ++  );
  while( $pr < $max_integer )
  {
    if( !$only_3_mod_4 || $pr%4 == 3 )
    {
      $counting++;
    }

    $pr = Prime::getNthPrime( $idx ++ );
    
  }
  return $counting;
}


