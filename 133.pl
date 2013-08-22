use strict;
use warnings;
use Data::Dumper;
use SmartMult;
use Prime;

my($max_prime)=10**5;

my($base)=10;

Prime::init_crible($max_prime + 500);
my($p)= Prime::next_prime(1);#2 not a facor
$p    = Prime::next_prime(1);#3 not a facor
$p    = Prime::next_prime(1);#5 not a facor

my($sum_never_factors)= 2 + 3 + 5;

$p    = Prime::next_prime(1);
while( $p < $max_prime )
{
  my( $pval_2 ) = Prime::p_valuation( $p-1, 2 );
  my( $pval_5 ) = Prime::p_valuation( $p-1, 5 );
  

  my( $order_candidate ) = 2**  $pval_2 * 5** $pval_5;
  my( $product ) = SmartMult::smart_mult_modulo( $base, $order_candidate, $p );
  if($product != 1)
  {
    $sum_never_factors += $p;
  }
  $p    = Prime::next_prime(1);
}

print $sum_never_factors;
