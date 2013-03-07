use strict;
use warnings;
use Data::Dumper;
use Prime;

# Not used ?
use Pythagoriciens;
use Hashtools;
use POSIX qw/floor ceil/;

# The number of solutions S(n) of 1/x + 1/y = 1/n may be calculated :
# If n = prod( pi^ki ), S(n) = (prod( 2*ki + 1) + 1)/2.
# The idea is to find the least number n with S(n) >= M.
# The equivalent problem PROB(m) solves :
# minimize C= sum(Xi) such that  P >=  prod(Xi)
# with :
# Xi = (2ki+1)*ln(pi)
# P = (2*M - 1)/prod( ln(pi))
 

my($stop_at_first_ocuurence_of)= 1000;

my($max_for_odd_product)=( $stop_at_first_ocuurence_of )*2 -1;
my($num_primes)=ceil( log($max_for_odd_product)/log(3) );
    
my($p)= Prime::next_prime();
my(@prime_tab)=($p);
my(@prime_prod_cumulated)=($p);

my(@kis)=(1);
while( $#prime_tab+1 < $num_primes )
{
    $p= Prime::next_prime();
    push( @prime_tab, $p);
    push( @prime_prod_cumulated, $p * $prime_prod_cumulated[-1] );
    push( @kis, 1 );
}
    
my($best_prod)= $prime_prod_cumulated[-1];

recursive_solve_PROB( $#kis + 1, \$best_prod,  

sub recursive_solve_PROB
{
    my($m,$rbest_prod,
}



while(1) #Bleh
{
    next_kis( \@kis, \$best_prod );
    
}

sub prime_for_kis
{
    my($rkis,$rprimes_cumulated)=@_;
    my($product)=1;
    my($step)=0;
    for(my($i)=$#$rkis;$i>=0;$i--)
    {
	if( $$rkis[$i] == $step)
	{
	    next;
	}
	$product*=($$rprimes_cumulated[$i])**($$rkis[$i] - $step);
	$step+=$$rkis[$i];
    }
    return $product;
}



sub prod_kis
{
    my($rkis)=@_;
    my($product)=1;
    for(my($i)=0;$i<=$#$rkis;$i++)
    {
	$product*=(2*$$rkis[$i]+1); 
    }
    return $product;
}

   

