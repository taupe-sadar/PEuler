use strict;
use warnings;
use Data::Dumper;
use DiophantineReciprocal;

my($stop_at_first_ocuurence_of)= 4000000;
DiophantineReciprocal::set_max_for_odd_product( $stop_at_first_ocuurence_of );

print DiophantineReciprocal::number_solutions_diophantine_reciprocal( );
