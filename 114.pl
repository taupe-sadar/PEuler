use strict;
use warnings;
use Data::Dumper;
use Sequence;

# Let F(m,n) be the number of ways to place red bars
# no less than 3 long with a black square delimiting the bars
# this is the same thing to solve G(m+1,n+1), where G(m,n)
# is the problem : solving the same thing without the black square constraint
#
# Then we may compute that G(m,n) = 2*G(m,n-1) - G(m,n - 2) + G( n - m )

my( $sequence) = Sequence->new([2,-1,0,1],[1,1,1,1]);

print $sequence->calc(51);

