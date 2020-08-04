use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );
use EulerTotient;
use Prime;

my($max)=12000;
my($totalsum)= EulerTotient::sum_phi($max); 

my($sum_in_first_tier)=EulerTotient::sum_phi_x($max,3);

#intervalle [0;1] - ( [0;1/3] + [ 2/3 ;1])
# on enleve 1/2, 1  et on divise par deux 
my($sum)= $totalsum - 2*$sum_in_first_tier - 2;
$sum/=2;
print "$sum";


