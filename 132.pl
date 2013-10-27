use strict;
use warnings;
use Data::Dumper;
use SmartMult;
use Prime;
use List::Util qw( max min );

my($num_factors)=40;

my($max_exp)=9;
my($base)=10;

Prime::init_crible(200000);
Prime::reset_prime_index(1);
my($p)= Prime::next_prime(1);#2 not a facor
$p    = Prime::next_prime(1);#3 not a facor
$p    = Prime::next_prime(1);#5 not a facor

my($count_factors)=0;
my($sum_factors)=0;

while( $count_factors < $num_factors )
{
  $p    = Prime::next_prime(1);
  
  
  my( $pval_2 ) = Prime::p_valuation( $p-1, 2 );
  my( $pval_5 ) = Prime::p_valuation( $p-1, 5 );
  

  my( $order_candidate ) = 2** min( $pval_2, $max_exp ) * 5** min( $pval_5, $max_exp );
  my( $product ) = SmartMult::smart_mult_modulo( $base, $order_candidate, $p );
  if($product == 1)
  {
    $count_factors++;
    $sum_factors += $p;
  }
  
}

print $sum_factors;
