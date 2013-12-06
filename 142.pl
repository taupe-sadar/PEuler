use strict;
use warnings;
use Data::Dumper;
use Prime;
use Permutations;
use Math::BigInt;
use Gcd;

my( @primes_1_mod_8) =();

my( %square_components ) = ();

for( my($i)=1;$i<1000;$i+=2 )
{
  my($i4) = Math::BigInt->new($i)**4;
  
  for( my($j)=1;$j<$i;$j+=2 )
  {
    next if( Gcd::pgcd( $i, $j ) > 1 );
    
    my($n) = ( $i4 + Math::BigInt->new($j)**4)/2;
    my(%dec2) = Prime::decompose( $n );
    my(%dec) = decompose_with_primes_1_mod_8( $n );
    
    
    my($squ_component)=1;
    
    foreach my $k (keys(%dec))
    {
      $squ_component *= $k if( $dec{$k} %2 == 1 );
    }

    print( "$i - $j -> $squ_component\n" );
    # print "  ".(join(" ",keys(%dec)))." => ".(join(" ",values(%dec)))."\n";<STDIN>;
    # print "  ".(join(" ",keys(%dec2)))." => ".(join(" ",values(%dec2)))."\n";<STDIN>;
    
    if( !exists( $square_components{ $squ_component } ) )
    {
      $square_components{ $squ_component } = [ [$i,$j] ];
    }
    else
    {
      push( @{$square_components{ $squ_component }} ,  [$i,$j] ) ;
      print "$squ_component\n";
      print Dumper $square_components{ $squ_component };
      exit( 0 );
     <STDIN>;      
    }    
  }
}

sub decompose_with_primes_1_mod_8
{
  my( $n )= @_;
  
  my(%dec)=();
  
  my($limit) = sqrt( $n );
  my( $idx_prime ) = 0;
  my( $p ) = get_prime_1_mod_8( $idx_prime );
  while( $p <= $limit )
  {
    if( $n % $p == 0 )
    {
      $dec{ $p } = 1;
      $n/=$p;
      while( $n % $p == 0 )
      {
        $dec{ $p }++;
        $n/=$p;
      }
      $limit = sqrt( $n );
    }
    
    $idx_prime++;
    $p = get_prime_1_mod_8( $idx_prime );
  }
  $dec{$n} = 1 if( $n> 1 );
  
  return %dec;
}

sub get_prime_1_mod_8
{
  my($idx)=@_;
  while( $#primes_1_mod_8 < $idx )
  {
    my($p)=Prime::next_prime();
    push( @primes_1_mod_8 , $p ) if( $p %8 == 1 );
  }
  return $primes_1_mod_8[ $idx ];
}

#First impl. Pourri !!!

# "f = 141089 : 10853 13 141089 1";
my($n) = (new Math::BigInt(10853)**4 + 13**4 + 141089**4 + 1)/4;
print "$n ".(sqrt($n))." ".(new Math::BigInt(9953227201)**2)."\n";
exit();

for( my($f)= 15; 1 ; $f+=2 )
{
  my( @divisors_prime_pairs ) = get_divisors_prime_pairs( $f );
  
  next if( $#divisors_prime_pairs <= 0);
  
  for( my($i)=0; $i < $#divisors_prime_pairs; $i++ )
  {
    my( $p , $q ) = max_then_min ( @{$divisors_prime_pairs[$i]} );
    for( my($j)=$i+1; $j <= $#divisors_prime_pairs; $j++ )
    {
      my( $r , $s ) = max_then_min( @{$divisors_prime_pairs[$j]} );
      print "f = $f : $p $q $r $s\n"; 
      
      my($n)= ($p**4 + $q**4 + $r**4 + $s**4)/4;
      if( !(sqrt( $n ) =~m/\./ ) )
      {
        print "$n\n";<STDIN>;
      }      
    }
  }
  
}

sub max_then_min
{
  my( $a, $b ) = @_;
  return ( $a, $b ) if ($a > $b );
  return ( $b, $a )  
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