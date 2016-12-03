use strict;
use warnings;
use Data::Dumper;
use SmartMult;

my($limit)=1000;
my($mod)=10000000000;
my($sum)=0;
for(my($a)=1;$a<=$limit;$a++)
{
    my($pow)=SmartMult::smart_mult_modulo($a,$a,$mod);
    $sum=($sum+$pow)%$mod;
}

print $sum;
