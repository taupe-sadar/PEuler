use strict;
use warnings;
use Data::Dumper;
use Prime;
use Permutations;

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
# $count += nb_solution_arithmetic_progression_difference( int($max_solutions/4) , 0, 0  );
# $count += nb_solution_arithmetic_progression_difference( int($max_solutions/16), 1, 0  );

print $count;

sub nb_solution_arithmetic_progression_difference
{
  my( $max_integer, $allow_2_as_prime, $only_3_mod_4_odds ) =@_;
  
  for( my($i)=0; $i<= $#prime_patterns; $i++ )
  {
    my( @prime_exponents ) = map( {$_ - 1}  sort( { $a <=> $b }   @{ $prime_patterns[ $i ] } ));
    my( %groups ) = build_groups_of_exponents( @prime_exponents );
    my( @group_keys ) =   keys  ( %groups );
    my( @group_values ) = values( %groups );     
    my( $num_permutations ) = Permutations::nb_permutations_with_identical( @group_values );
    for( my($j)=0; $j < $num_permutations; $j++ )
    {
      my(@perm) =  Permutations::permutations_not_ordered( \@group_values, $j );
      
    }
  }
}

sub make_prime_patterns
{
  my($num_sols)=@_;
  my(@patterns)=();
  for( my($num_divisors)=$num_sols + 1; $num_divisors <= 2*$num_sols; $num_divisors++ )
  {
    push(@patterns , (Prime::all_divisors_decompositions( $num_divisors ) ) );
  }
  return @patterns;
}

sub build_groups_of_exponents
{
  my( @prime_exponents ) = @_;
  my(%groups_exponents)=();
  my($current)= undef;
  for( my($i)=0; $i<= $#prime_exponents; $i++ )
  {
    if( !defined($current) || $prime_exponents[ $i ] != $current )
    {
      $current = $prime_exponents[ $i ];
      $groups_exponents{ $current } = 1;
    }
    else
    {
      $groups_exponents{ $current } ++;
    }
  }
  return %groups_exponents;
  
}

sub loop_on_primes
{
  my( $rprimes, $nb_primes_to_loop, $fget_prime, $faction ) = @_;
  my(@prime_array) = (0 .. $nb_primes_to_loop-1);
  while( 1 )
  {
    my($result) = $faction( \@prime_array );  
  }
}
