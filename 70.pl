use strict;
use warnings;
use Data::Dumper;
use Prime;

my($max)=10**7;
my($middle)=sqrt($max);
my(@ptab)=();
my($p)=0;
Prime::init_crible(10**5);
while(($p=Prime::next_prime())<11 ){}; #We start with 11
push(@ptab,$p);

do
{
    $p=Prime::next_prime();
    if($p%3 == 2)
    {
	
	push(@ptab,$p);
    }
}
while($p<$middle);
my($first_idx)=$#ptab-1;

# 87109 = 11 * 7919 -> phi(87109) = 7918 * 10
my($bestp,$bestphip) = (87109,79180);

#On commence par les premiers par paire
my($stop_idx)=0;
for( my($idx)=$first_idx; $idx>=$stop_idx; $idx--)
{
    my($pp)= $ptab[$idx];
    if( is_auto_perm( $pp**2 , $pp*($pp-1)  ) )
    {
	if( compare_numbers( $pp**2, $pp*($pp-1), $bestp, $bestphip))
	{
	    $stop_idx = $idx; # On peut pas faire mieux
	    $bestp = $pp**2;
	    $bestphip = $pp*($pp-1);
	    
	}
    }
    
    my($qidx)=$idx+1;
    my($q)=$ptab[$qidx];
    my($stop)=0;
    while( 1 )
    {	
	my($prod1,$prod2)= ( $q * $pp, ($q-1) * ($pp-1 ));
	if( $prod1 >= $max )
	{
	    last;
	}
	if( is_auto_perm( $prod1 , $prod2  ) )
	{
	    if( compare_numbers( $prod1, $prod2, $bestp, $bestphip))
	    {
		my($go_no_less) = $pp*$q/($pp+$q-1);
		my($will_stop_idx) = $idx;
		while( ($will_stop_idx>0) && $ptab[$will_stop_idx-1]>= $go_no_less )
		{
		    $will_stop_idx--;
		}
		
		$stop_idx = $will_stop_idx; # Pas la peine d'utiliser des nombres premiers plus faibles
		$bestp = $prod1;
		$bestphip = $prod2;
	    
	    }
	}
	$qidx++;
	$q=get_high_prime(\@ptab,$qidx);
    }
}
#Le vrai test est cense verifier les triplets egalement. Mais avec le resultat precedent, il est facile de voir qu'aucun produit de nombre premiers convenable serait inferieur au max
print $bestp;

sub compare_numbers
{
    my($p,$phip,$q,$phiq)=@_;
    return (($p * $phiq) < ($q*$phip));
}

sub is_auto_perm
{
    my($a,$b)=@_;
    return (join("",sort(split('',$a))) eq join("",sort(split('',$b))));
}

sub get_high_prime
{
    my($ref,$idx)=@_;
    while($#$ref < $idx)
    {
	for(my($i)=0;$i<50;$i++)
	{
	    $p=Prime::next_prime();
	    if($p%3 == 2)
	    {
		push(@$ref,$p);
	    }
	}
    }
    return $$ref[$idx];
}
