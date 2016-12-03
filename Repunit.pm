package Repunit;
use strict;
use warnings;
use Data::Dumper;
use Prime;
use EulerTotient;
use SmartMult;

my($base)= 10 ;

sub set_base
{
  my($b)=@_;
  $base = $b;
}


sub group_unity_order
{
  my($znz_size)=@_;
  
  return 1 if $base % $znz_size == 1;
  
  my(%decomposition) = EulerTotient::phi_decomposition( $znz_size );
  my(@divisors ) = sort( {$a<=>$b} Prime::all_divisors_no_larger( \%decomposition ) );
  my($product)= $base % $znz_size ; 
  my($order ) = 1;
  for( my($i)= 1; $i<= $#divisors; $i++ )
  {
    my( $order_diff )= $divisors[$i] - $divisors[$i - 1];
    $product = ( $product * SmartMult::smart_mult( $base, $order_diff, $znz_size ) )% $znz_size;
    return $divisors[$i] if $product == 1;
  }
  die "Impossible : at least phi($znz_size) should be an order of $base. Unless $base ^ $znz_size != 1 ...";
}

1;
