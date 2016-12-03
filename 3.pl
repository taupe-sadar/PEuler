use strict;
use warnings;
use Data::Dumper;
use Prime;

my($n)=600851475143;
my(@tab)=Prime::decompose_tab($n);
print $tab[$#tab]; 

