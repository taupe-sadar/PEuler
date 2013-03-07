package Pythagoriciens;
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );
use POSIX qw/floor ceil/;
use Prime;
use Gcd;

#Caracterisation of  a^2 + b^2 = c^2 with 0 < a,0 < b, 0 < c
#On a forcement a,b parite differentes et c impair. Prenons a pair
# a = m *( l^2 - k^2) /2
# b = m * k * l
#  c = m *( l^2 + k^2) /2
# Les triplets primitifs sont obtenus pour m = 1 et l^k = 1
# avec k,l IMPAIRS
# alors a + b + c = l *( k + l)

#Tout ce qu'on veut ce sont les couples (l,k) tel que l(l+k)<$max avec l^k =1 Un triplet non primitif est proportionel a un primitifs

sub primitive_triplets_from_min_value
{
    my($lowest_min,$highest_min)=@_;
    
    my(@rettab)=();
    
    
    my($l,$k);
    #First part of the seeking set 
    my($start_l1,$end_l1)=( ceil(sqrt($lowest_min*(sqrt(2)+1))) , $highest_min );
    if($start_l1%2 == 0)
    {
	$start_l1++;
    }
    
    for($l=$start_l1;$l<=$end_l1;$l+=2)
    {
	my($start_k,$end_k)=( ceil($lowest_min/$l) , min ( floor(sqrt($l**2 - 2*$lowest_min)) , floor($highest_min/$l)) );
	if( $start_k%2 == 0)
	{
	    $start_k ++;
	}
	for($k=$start_k;$k<=$end_k;$k+=2)
	{
	    #La on teste que l^k=1
	    if(Gcd::pgcd($l,$k)!=1)
	    {
		next;
	    }
	    push(@rettab,[$l,$k]);	    	    
	}
    }
    #Second part of the seeking set 
    my($start_l2,$end_l2)=( ceil(sqrt($lowest_min+sqrt($lowest_min**2 + ($highest_min+1)**2 ))) , floor($highest_min+1/2) );
    if($start_l2%2 == 0)
    {
	$start_l2++;
    }
    for($l=$start_l2;$l<=$end_l2;$l+=2)
    {
	
	my($start_k,$end_k)=( max( ceil(sqrt(max($l**2 - 2*$highest_min,0))) ,ceil(($highest_min+1)/$l)) , floor(sqrt($l**2 - 2*$lowest_min) ) );
	if( $start_k%2 == 0)
	{
	    $start_k ++;
	}
	
	for($k=$start_k;$k<=$end_k;$k+=2)
	{
	    #La on teste que l^k=1
	    if(Gcd::pgcd($l,$k)!=1)
	    {
		next;
	    }
	    push(@rettab,[$l,$k]);	    	    
	}
    }

    
    
    return \@rettab;
}

sub primitive_triplets_from_perimeter
{
    my($max)=@_;
    
    my(@rettab)=();

    my($limit_l)=sqrt($max);
    my($l,$lk);
    for($l=1;$l<=$limit_l;$l+=2)
    {
	my($limit_lk)=min($max/$l,2*$l-2);# Le maximum pour k est  l-2
	for($lk=$l+1;$lk<=$limit_lk;$lk+=2)
	{
	    #La on teste que l^lk=1
	    if(Gcd::pgcd($l,$lk)!=1)
	    {
		next;
	    }
	    push(@rettab,[$l,$lk-$l]);	    	    
	}
    }
    return \@rettab;
}

#return the triplet a, b ,c 
sub value_triplet
{
    my($l,$k)=@_;
    return (($l*$l-$k*$k)/2,$l*$k,($l*$l+$k*$k)/2);
}

#return the perimeter a, b ,c 
sub value_perimeter
{
    my($l,$k)=@_;
    return $l*($l+$k);
}

1;
