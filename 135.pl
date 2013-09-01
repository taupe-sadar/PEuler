use strict;
use warnings;
use Data::Dumper;
use Prime;

# The problem ( x )^2 - ( x - a )^2 - ( x - 2a )^2 = n
# with x > 2a and a > 1 is solved considering the divisors
# of n = n1*n2. They verify 
# a = (n1 + n2)/4
# x = (5n1 + n2)/4
# and n1 < sqrt( 3n ) <=> n2 > sqrt( n/3 ) <=> n1/n2 < 3
# plus : 
#    n1 % 4 = 0 and n2 % 4 = 0
# OR n1 % 4 = 2 and n2 % 4 = 2
# OR nx % 4 = 3 and ny % 4 = 1 <=> n % 4 = 3
#
# Here we need to find the n where there is exactly such N divisors n1/n2  
# We are considering all prime decompositions that are compatible
# the total number of divisors T must verify : N < T <= 2N 

my( $num_solutions ) = 10;
my( $max_solutions ) = 10**6;


my(@prime_patterns)=make_prime_patterns( $num_solutions );

my($count)=0;
$count += nb_solution_arithmetic_progression_difference( $max_solutions,         0, 1  );
$count += nb_solution_arithmetic_progression_difference( int($max_solutions/4) , 0, 0  );
$count += nb_solution_arithmetic_progression_difference( int($max_solutions/16), 1, 0  );

print $count;

sub nb_solution_arithmetic_progression_difference
{
  my( $max_integer, $allow_2_as_prime, $only_3_mod_4_odds ) =@_;
  
}

sub make_prime_patterns
{
  my($num_solutions)=@_;
  my(@patterns)=();
  for( my($num_divisors)=$num_solutions + 1; $num_solutions <= 2*$num_solutions; $num_solutions++ )
  {
    push(@patterns , (Prime::all_divisors_decompositions( $num_solutions ) ) );
  }
}
