use strict;
use warnings;
use Data::Dumper;
use Prime;
use Permutations;

for( my($f)= 105; 1 ; $f+=2 )
{
  my( @tab ) = get_divisors_prime_pairs( $f );
  print "--------------\n$f\n";
  print Dumper \@tab;
  <STDIN>;
  
  
}

sub get_divisors_prime_pairs
{
  my($n)=@_;
  
  my(%decomp)= Prime::decompose( $n );
  my(@base_primes)= keys( %decomp );
  my($num_diff_primes ) = $#base_primes + 1;
  return() if($num_diff_primes <= 1 );
  
  my( @collection_of_ind_prime_pair_divisors ) = ();
  for( my($subset_size) = 1 ; $subset_size <= $num_diff_primes; $subset_size ++ )
  {
    my( $num_possible_subsets ) = Permutations::cnk( $num_diff_primes, $subset_size );
    for( my($idx_subset)= 0 ; $idx_subset < $num_possible_subsets ; $idx_subset++ )
    {
      my( @subset ) = Permutations::subset( $num_diff_primes, $subset_size, $idx_subset );
      next if( $subset[0] != 0 );
      my($p ) = 1;
      for( my($i)=0; $i<= $#subset; $i++ )
      {
        my($prime) = $base_primes[$subset[$i]];
        $p*= $prime**$decomp{$prime};
      }
      push( @collection_of_ind_prime_pair_divisors, [ $p, $n/$p ] )
    }
  }
  return @collection_of_ind_prime_pair_divisors;
}