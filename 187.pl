use strict;
use warnings;
use Data::Dumper;
use Prime;

Prime::init_crible(10**8+1000);
my($p)=Prime::next_prime();
my($i)=1;
while(($p=Prime::next_prime()) < 10**8)
{
  $i++;
  print "$i : $p\n" if($i%1000 == 0);
}
