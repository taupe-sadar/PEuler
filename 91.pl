use strict;
use warnings;
use Data::Dumper;
use Hashtools;
my($max)=50;


#There are three kind of solutions
#  Right angle in O,P,Q
# For 0 : 
my($right_angle_at_0)= $max**2;

# For P and Q, there exactly the same amount 
# of solutions, as the problem is symetric
# One may calculate that a solution with right 
# angle in P must verify :
# xp ( xq -xp ) = yp ( yp - yq) = Prod
# with P is a product characteristic.
# There is a special case for Prod =0

my($prod_equals_0)= $max**2;

my(%prods_for_x);
my(%prods_for_y);

my($count_prods)=0;

my($limit_i)= ($max**2)/4;
for( my($i)=1 ; $i <= $limit_i; $i++ )
{
    my($limit_j)= int( ($max**2)/(4 * $i) );
    for( my($j)=1 ; $j <= $limit_j; $j++ )
    {
	my($prod)= $i*$j;
	
	if( ($i + $j)  <= $max )
	{
	   Hashtools::increment(\%prods_for_x,$prod);
	}
	if( $j<= $max && $i <= $j )
	{
	   Hashtools::increment(\%prods_for_y,$prod);
	}
	
    }
}


my($k);

foreach $k (keys( %prods_for_x) )
{
    if( exists( $prods_for_y{$k} ) )
    {
	$count_prods += $prods_for_x{$k} * $prods_for_y{$k};
    }
}

my($count_triangle) = $right_angle_at_0 + 2*( $prod_equals_0 + $count_prods);

print $count_triangle;
