use strict;
use warnings;
use Data::Dumper;
use SmartMult;

my($factor1) = 28433;
my($base) = 2;
my($exp)= 7830457;
my($modulo)=10**10;

my( $factor2)= SmartMult::smart_mult_modulo( 2, $exp, $modulo);

my($prod) = ( $factor1*$factor2+1 ) % $modulo;

print $prod;



