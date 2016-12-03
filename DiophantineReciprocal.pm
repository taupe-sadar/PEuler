package DiophantineReciprocal;
use strict;
use warnings;
use Data::Dumper;

use Prime;
use POSIX qw/floor ceil/;
use List::Util qw( sum min max );
use Math::BigInt;

# The number of solutions S(n) of 1/x + 1/y = 1/n may be calculated :
# If n = prod( pi^ki ), S(n) = (prod( 2*ki + 1) + 1)/2.
# The idea is to find the least number n with S(n) >= M.
# The equivalent problem PROB(m) solves :
# minimize C= sum(ai x Xi) such that  P >=  prod(Xi)
# with :
# Xi = (2ki+1)
# P = (2*M - 1)
# ai = log( pi )

my($max_for_odd_product)=0;
my(@prime_prod_cumulated)=();
my(@prime_tab)=();

sub set_max_for_odd_product
{
    my($stop_at_first_ocuurence_of)=@_;
    $max_for_odd_product=( $stop_at_first_ocuurence_of )*2 -1;
}

sub init_prime_arrays
{
    my($num_primes)=@_;
    Prime::init_crible(20000);
    my($p)= Prime::next_prime();
    @prime_tab=($p);
    @prime_prod_cumulated=($p);
    
    
    while( $#prime_tab+1 < $num_primes )
    {
	$p= Prime::next_prime();
	push( @prime_tab, $p);
	push( @prime_prod_cumulated, $p * $prime_prod_cumulated[-1] );
    }

}

sub number_solutions_diophantine_reciprocal( )
{
    my($num_primes)=ceil( log($max_for_odd_product)/log(3) );
    
    if($#prime_tab +1 < $num_primes)
    {
	init_prime_arrays($num_primes);
    }
    my(@kis)=();
    for(my($i)=0;$i<$num_primes;$i++)
    {
	$kis[$i]=0;
    }
    
    my($best_prod)= Math::BigInt->new($prime_prod_cumulated[-1]);
    recursive_solve_PROB( $#kis-1, 0  , \@kis,  Math::BigInt->new(1), \$best_prod  );  
    
    return $best_prod;
}

sub recursive_solve_PROB
{
  my($idx, $base_ki, $rkis, $current_prod, $rbestprod ) = @_;
  my($max_ki) = calc_max_ki ( $rbestprod, $current_prod, $idx ) + $base_ki;
  
  # print Dumper \@_; 
  # print "MAX_ki : $max_ki\n";<STDIN>;
  
  if( $idx == 0 )
  {
    my($curent_ki_prod)= prod_kis( $rkis );
    my( $min_Xi ) =  $max_for_odd_product/ ($curent_ki_prod/ (2*$base_ki+1) ) ;
    my( $min_ki ) =  max( $base_ki, ceil( ($min_Xi -1)/2 ) );
    
    if( $min_ki > $max_ki )
    {
      return 0;
    }
    else
    {
      
      $$rbestprod = $current_prod * ($prime_prod_cumulated[ $idx ] ** ($min_ki - $base_ki) );
      return 1;
    }
  }
  else
  {
    $current_prod*= $prime_prod_cumulated[ $idx ] ** ($max_ki - $base_ki);
    for(my($ki)=$max_ki;$ki>=$base_ki;$ki--)
    {
        for(my($j)=0;$j<=$idx;$j++)
        {
          $$rkis[$j] = $ki;
        }
        
        recursive_solve_PROB( $idx - 1, $ki, $rkis, $current_prod, $rbestprod ); 
        $current_prod/= $prime_prod_cumulated[ $idx ];
    }
  }
}

sub calc_max_ki
{
  my( $rbestprod, $current_prod, $idx ) =@_;
  return floor( log($$rbestprod->bstr/$current_prod->bstr) / log( $prime_prod_cumulated[ $idx ] ) );
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


1;
