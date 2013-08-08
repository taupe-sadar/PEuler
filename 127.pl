use strict;
use warnings;
use Data::Dumper;
use Radical;
use POSIX qw/floor ceil/;
use Prime;
use Gcd;

# we have to find the triplets (a,b,c)
# such that rad( a x b x c ) < c a^b = b^c = a^c = 1
# with convention :
# a = rad_a x ka
# b = rad_b x kb
# c = rad_c x kc
# we must find a,b,c st rad_a x rad_b < kc

my( $max_for_c ) = 120000;

Radical::init_set( $max_for_c );

my( $sum_c )= 0;

while( 1 )
{
  my($radical_c,$rdecomposition_c) = Radical::next_radical(0);
  
  my($max_for_kc)= floor( $max_for_c/ $radical_c );
  last if( $max_for_kc <= 2 );
  my( $rkcs ) = Radical::list_composites( $max_for_kc,@$rdecomposition_c );
  
  my($p1,$p2)= smallest_two_primes_prime_with_c( $radical_c );
  my($min_for_kc)=  $p1 * $p2; 

  
  for( my($i)= 0; $i <= $#$rkcs; $i++ )
  {
    # Case b = 1
    my( $kc ) = $$rkcs[$i];
    next if( $kc <= 2); 
    my( $a_with_b1 ) = $radical_c * $kc - 1;
    my( $rad_a);
    if(  ($rad_a = is_a_valid_for_abc_hit( $a_with_b1, 1 , $kc ))> 0 )
    {
      $sum_c += $radical_c * $kc;
    }
    
    next if( $kc <= $min_for_kc ); #because excluding special case.
    
    # Other cases for b
    Radical::reset_iterator(1);
    my($max_for_rad_b)= floor( sqrt($kc) );
    my(%b_hiting_with_c)=();
    
    while( 1 )
    {
      my($radical_b,$rdecomposition_b) = Radical::next_radical(1);
      last if ($radical_b > $max_for_rad_b);
      next if ( Gcd::pgcd( $radical_b  , $radical_c )!=1 );
      my($max_for_kb)= floor( ($kc*$radical_c - 2)/ $radical_b );
      my( $rkbs ) = Radical::list_composites( $max_for_kb,@$rdecomposition_b );
      
      
      for( my($j)= 0; $j <= $#$rkbs; $j++ )
      {
        my($kb)= $$rkbs[$j];
        my($a) = $radical_c * $kc - $radical_b * $kb;
        next if(exists($b_hiting_with_c{$a}));
        my($radical_a);
        if(  ($radical_a = is_a_valid_for_abc_hit( $a , $radical_b , $kc ))> 0 )
        {
          $sum_c += $radical_c * $kc;
          $b_hiting_with_c{$radical_b*$kb}=1;
        }
        
      }
    }
  }
  
}
print $sum_c;

sub smallest_two_primes_prime_with_c
{
  my($rad_c)=@_;
  Prime::reset_prime_index(1);
  
  my(@ps)=();
  do
  {
    my( $p )= Prime::next_prime(1);
    push( @ps, $p ) if( $rad_c%$p != 0);
  }
  while( $#ps < 1);

  return @ps;
}

sub is_a_valid_for_abc_hit
{
  my($a,$radb,$kc)=@_;
  my($limit_rad_a ) = ceil( $kc / $radb );
  my($rad_a)=1;
  my( $nb )= $a;
   
  do
  {
    if($nb<0)
    {
      my($a)=0;
      $a++;
    }
    
    my( $p ,$pfactor, $left ) = Prime::partial_decompose( $nb );
    #print "($p, $pfactor, $left) -> $rad_a < $limit_rad_a\n";
    $rad_a *= $p;
    return 0 if $rad_a >= $limit_rad_a;
    $nb = $left;
  }
  while( $nb > 1  );
  return $rad_a;
}
