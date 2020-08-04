use strict;
use warnings;
use Data::Dumper;
use Prime;

my($ratio_min)=0.1;

my($side_m1_by2)=1;
my($nb_primes)=0;
my($num_diag)=1;
my($ratio)=1;
Prime::init_crible(200000);
while($ratio>=$ratio_min)
{
  my($square)=(2*$side_m1_by2+1)**2;
  $nb_primes+=Prime::fast_is_prime($square-2*$side_m1_by2)+Prime::fast_is_prime($square-4*$side_m1_by2)+Prime::fast_is_prime($square-6*$side_m1_by2);
  
  $num_diag+=4;
  $ratio=$nb_primes/$num_diag;
  $side_m1_by2++;
}

print (2*$side_m1_by2 - 1);
