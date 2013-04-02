use strict;
use warnings;
use Data::Dumper;
use Bouncy;
use Math::BigInt;
no warnings 'recursion';

my($power)=100;

my($gogol)=10**(Math::BigInt->new($power));
print ($gogol - Bouncy::count_bouncy_power10( $power ));
