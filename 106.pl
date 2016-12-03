use strict;
use warnings;
use Data::Dumper;
use Permutations;

my($n)=12;

my(@all_parenthesing)=([1]);

for(my($i)=1;$i<=int($n/2);$i++)
{
    $all_parenthesing[$i][0] = $all_parenthesing[$i-1][0];
    for(my($j)=1;$j<$i;$j++)
    {
	$all_parenthesing[$i][$j] = $all_parenthesing[$i-1][$j] + $all_parenthesing[$i][$j-1];
    }
    $all_parenthesing[$i][$i] = $all_parenthesing[$i][$i-1];
    
}

my($necessary_tests)=0;
for( my($size)=2;$size<= int($n/2); $size ++ )
{
    my($useless_tests)= 2*$all_parenthesing[$size][$size];
    my($useful_tests)= (Permutations::cnk( 2*$size, $size) - $useless_tests)/2;
    $necessary_tests += Permutations::cnk( $n, 2*$size)*$useful_tests;
}

print $necessary_tests;


