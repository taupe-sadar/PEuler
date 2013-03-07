package Permutations;
use strict;
use warnings;
use Data::Dumper;
use Math::BigInt;
use List::Util qw( sum );

our(@facts)=(1,1);

#Retourne le j-ieme sous ensemble de k elements parmi n 
sub subset
{
    my($n,$k,$j)=@_;
    (($k>=0)&&($n>0)&&($n>=$k)) or die "Out of range $j-th subset of size $k in $n";
    if($k==0)
    {
	return ();
    }
    if($n==1)
    {
	(($k==1)&&($j==0)) or die "Out of range $j-th subset of size $k in $n";
	return (0);
    }
    if($n==$k)
    {
	($j==0) or die "Out of range $j-th subset of size $k in $n";
	return (0..$n-1);
    }
    if($k==1)
    {
	(($j>=0)&&($j<$n)) or die "Out of range $j-th subset of size $k in $n";
	return ($j);
    }
    my($maxmin)=$n-$k+1;
    my($size_subset)=cnk($n-1,$k-1);
    my($idx)=$j;
    for(my($a)=0;$a<$maxmin;$a++)
    {
	if($idx<$size_subset)
	{
	    my(@perm)=subset($n-1-$a,$k-1,$idx);
	    for(my($b)=0;$b<=$#perm;$b++)
	    {
		$perm[$b]+=$a+1;
	    }
	    return ($a,@perm);
	}
	$idx-=$size_subset->bstr();
	$size_subset*=($n-$k-$a);
	$size_subset/=($n-$a-1);
    }
    die "Out of range $j in ($n,$k). Max ".cnk($n,$k);
}

#retourne le coefficient binomial C(n,k) = nombre de subsets k parmi n 
sub cnk
{
	my($n,$k)=@_;
	my($val)=new Math::BigInt(1);
	my($i)=0;
	for($i=0;$i<$k;$i++)
	{
		$val*=($n-$i);
		$val/=($i+1);
	}
	return $val;
}

#returns the numbers of permutations in a given set, where some elements are identical
# the input entry is the array of "identical elements.
# Ex : the set { 1,2,1,5,6,3,5} may be represented by : the perl array ( 2,1,2,1,1).
sub permutations_with_identical
{
	my(@identicals)=@_;
	my( $n )= sum( @identicals);
	my($permutations)=1;
	for(my($i)=0;$i<= $#identicals; $i ++ )
	{
	    $permutations*= cnk( $n, $identicals[$i]);
	    $n -= $identicals[$i];
	}
	return $permutations;
}
 


#Retoure le n-ieme arrangement. Un arrangement de 'k' chiffres parmi 'fact' 
sub arrangement
{
	my($fact,$n,$k)=@_;
	my(@perm);
	if(!defined($k))
	{
	    $k=$fact;
	}
	if($fact==1){
		@perm=(0);
	}
	elsif($k<=1)
	{
	    return ($n);
	}
	else
	{
		my($f)=factorielle($fact-1)/factorielle($fact-$k);
		my($first)=int($n/$f);
		@perm=arrangement($fact-1,$n%$f,$k-1);
		my($i);
		for($i=0;$i<=$#perm;$i++)
		{
			if($perm[$i]>=$first)
			{
				$perm[$i]++;
			}
		}
		unshift(@perm,$first);
	}
	return @perm;
}

sub factorielle
{
	my($n)=@_;
	if($n<=0)
	{
		return 1;
	}
	if($n>$#facts)
	{
	  my($i);
	  for($i=$#facts+1;$i<=$n;$i++)
	  {
	      $facts[$i]=$i*$facts[$i-1];
	  }
	}
	return $facts[$n];
}
#Decompose in factorial base
sub dec_base_fact
{
    my($n)=@_;
    my(@t)=(0);
    my($base)=2;
    while($n>0)
    {
	my($r)=$n%$base;
	push(@t,$r);
	$n=($n-$r)/$base;
	$base++;
    }
    return @t;
}

#Add two numbers in factorial decomposition (with coeffs a and b)
sub comb_facts
{
    my($refa,$refb,$coeffa,$coeffb)=@_;
    my($a)=0;
    my($retenue)=0;
    my(@sum)=(0);
    if(!defined($coeffa))
    {
	$coeffa=1;
    }
    if(!defined($coeffb))
    {
	$coeffb=1;
    }
    if(($#{$refa}<$#{$refb})||(($#{$refa}==$#{$refb})&&($$refa[-1]<$$refb[-1])))
    {
	my($r)=$refa;
	$refa=$refb;
	$refb=$r;
    }
    for($a=1;$a<=$#{$refb};$a++)
    {
	my($s)=$coeffa*$$refa[$a]+$coeffb*$$refb[$a]+$retenue;
	$sum[$a]=$s%$a;
	$retenue=($s-$sum[$a])/$a;
    }
    for($a=$#{$refb}+1;$a<=$#{$refa};$a++)
    {
	my($s)=$coeffa*$$refa[$a]+$retenue;
	$sum[$a]=$s%$a;
	$retenue=($s-$sum[$a])/$a;
    }
    while($retenue>0)
    {
	$sum[$a]=($retenue)%$a;
	$retenue=($retenue-$sum[$a])/$a;
	$a++;
    }
    return @sum;
    
}

1;
