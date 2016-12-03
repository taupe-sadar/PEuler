use strict;
use warnings;
use Data::Dumper;
use Permutations;

#Using Lagrange polynomial interpolation
# Shortly :
# Given f the function to interpolate, the k points 1, .., k are the interpolation points
# the polynomial OPk( i, X) = sum Lj( X )
# where Lj( X ) = prod( X - i)/prod( j - i ) (i!=j).
# The FIT is calculated for OPk, at the point X = k+1, and after calculus
# FIT = sum (Cnk ( k , i -1 ) * f( i) * (-1)^(k - i) ) i : 1 .. k 

my($max_order)= 10;
my($bop_sum)=0;
for( my($d)= 1; $d<= $max_order; $d++ )
{
    my( $potential_fit)= first_incorrect_term( $d );
    if($potential_fit != function_to_interpolate( $d+1) )
    {
	$bop_sum += $potential_fit;
    }
    else
    {
	die "The BOP $d : $potential_fit as not trivial FIT\n";
    }
}
print $bop_sum;


sub first_incorrect_term
{
    my($order)=@_;
    my($fit)=0;
    for( my($i)=1;$i<=$order; $i++ )
    {
	my( $sign)= (($order - $i)%2 == 0) ? 1 : -1 ;
	$fit += Permutations::cnk($order, $i -1 ) * function_to_interpolate( $i ) * $sign ; 
    }
    return $fit;
}


sub function_to_interpolate
{
    my($n)=@_;
    return ( ( $n**10 -1)/($n+1)*$n +1);
}
