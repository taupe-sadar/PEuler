use strict;
use warnings;
use Data::Dumper;

my($max_digits)=1000;
my($n)=(($max_digits-1)*log(10)+log(5)/2)/log((sqrt(5)+1)/2);
$n=int($n)+1;
print $n;