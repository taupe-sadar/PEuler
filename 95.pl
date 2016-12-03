use strict;
use warnings;
use Data::Dumper;
use Divisors;
use List::Util qw( max min );

my($max) = 10**6;


Divisors::calc_all_until( $max);

# For each entry [ length of chain, smallest number in chain]. Length is zero if the chain goes over $max.

my(%tree_of_divisor_sums)= ( 1 => [  1, 1 ]  );

my($longest_chain)=0;
my($smallest_of_longest_chain);

for(my($a)=$max;$a>=1;$a--)
{
    my($endloop) = get_recursive_lower_in_chain( $a );
    next if( $$endloop[0] == 0 );
       

    if( $$endloop[0] > $longest_chain )
    {
	$longest_chain = $$endloop[0];
	$smallest_of_longest_chain = $$endloop[1];
    }
    
    
}

print "$smallest_of_longest_chain\n";

sub get_recursive_lower_in_chain
{
    my( $n )=@_;
        
    if ( ! exists($tree_of_divisor_sums{$n} ) )
    {
	$tree_of_divisor_sums{$n} = [ -1, -1 ];
	my( $next_in_tree )= Divisors::get_sum_prop_div( $n );
	if( $next_in_tree > $max)
	{
	    $tree_of_divisor_sums{$n} = [ 0 , -1];
	}
	else
	{
	$tree_of_divisor_sums{$n} = get_recursive_lower_in_chain( $next_in_tree );
	}
    }
    elsif( $tree_of_divisor_sums{$n}[ 0 ] == -1 ) # We reach $n twice already
    {
	my(  $length, $smallest)= find_length_and_smallest( $n );	
	$tree_of_divisor_sums{$n} = [ $length , $smallest];
    }
    
    
    return $tree_of_divisor_sums{$n};
}

sub find_length_and_smallest 
{
    my($n)=@_;
    
    my($current_sum_div)=$n;
    my($smallest)= $n;
    my($length) = 0;
    do
    {
	$current_sum_div = Divisors::get_sum_prop_div( $current_sum_div );
	$length ++;
	$smallest = min( $smallest, $current_sum_div );
    }
    while( $current_sum_div != $n);

    return ( $length, $smallest);
}

