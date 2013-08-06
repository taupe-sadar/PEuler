use strict;
use warnings;
use Data::Dumper;
use Radical;
use POSIX qw/floor ceil/;
use Prime;

# we have to find the triplets (a,b,c)
# such that rad( a x b x c ) < c a^b = b^c = a^c = 1
# with convention :
# a = rad_a x ka
# b = rad_b x kb
# c = rad_c x kc
# we must find a,b,c st rad_a x rad_b < kc

my( $max_for_c ) = 1000;

Radical::init_set( $max_for_c );

# There is a special case a = 1, b = 2**n, c = 3**m
# There is only one solution b = 8 and c = 9 (easy to proove)

my( $sum_c )= 9;

while( 1 )
{
  my($radical_c,$rdecomposition) = Radical::next_radical(0);
  
  
  
  my($max_for_kc)= floor( $max_for_c/ $radical_c );
  last if( $max_for_kc <= 3 );
  my( $rkcs ) = Radical::list_composites( $max_for_kc,@$rdecomposition );
  
  for( my($i)= 0; $i <= $#$rkcs; $i++ )
  {
    # Case b = 1
    my( $kc ) = $$rkcs[$i];
    next if( $kc <= 3); #because excluding special case.
    my( $a_with_b1 ) = $radical_c * $kc - 1;
    my( $rad_a);
    if(  ($rad_a = is_a_valid_for_abc_hit( $a_with_b1, 1 , $kc ))> 0 )
    {
      my($c)= $radical_c * $kc;
      print "$a_with_b1 , 1 , $c | $rad_a < $kc \n";
    }
    
    
    
  }
  
}

sub is_a_valid_for_abc_hit
{
  my($a,$radb,$kc)=@_;
  my($limit_rad_a ) = ceil( $kc / $radb );
  my($rad_a)=1;
  my( $nb )= $a;
   
  do
  {
    
    my( $p ,$pfactor, $left ) = Prime::partial_decompose( $nb );
    #print "($p, $pfactor, $left) -> $rad_a < $limit_rad_a\n";
    $rad_a *= $p;
    return 0 if $rad_a >= $limit_rad_a;
    $nb = $left;
  }
  while( $nb > 1  );
  return $rad_a;
}
