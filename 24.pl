use strict;
use warnings;
use Data::Dumper;
use Permutations;

my($factorielle)=10;
my($num)=1000000;

my($fin)=join("",Permutations::arrangement($factorielle,$factorielle,$num-1));
print $fin;

