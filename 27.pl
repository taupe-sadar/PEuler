use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor ceil/;
use List::Util qw( max min );

my($max)=1000;

my(@blist)=();
my($a,$i)=0;
my($n_max)=1;
my($prod_max)=0;
$i=Prime::next_prime();#on elimine 2 qui est ... particulier
while($i<$max)
{
    push(@blist,$i);
    $i=Prime::next_prime();
}

#Et la on fait le cas -1/1
for($a=(-$max+1)+($max%2);$a<=($max-1)-($max%2);$a+=2)
{
    my($n1)=quadratic_max($a,1);
    my($n2)=quadratic_max($a,-1);
    if($n1>$n_max)
    {
	$prod_max=$a;
	$n_max=$n1;
    }
    if($n2>$n_max)
    {
	$prod_max=-$a;
	$n_max=$n2;
    }
}
for($i=$#blist;$i>=0;$i--)
{
    for($a=(-$max+1)+($max%2);$a<=($max-1)-($max%2);$a+=2)
    {
	my($pred_max_n)=($blist[$i]-($a%$blist[$i]))-1;
    
	if($pred_max_n<=$n_max)
	{
	    next;
	}
	
	my($n1)=quadratic_max($a,$blist[$i]);
	my($n2)=quadratic_max($a,-$blist[$i]);
	if($n1>$n_max)
	{
	    $prod_max=$a*$blist[$i];
	    $n_max=$n1;
	}
	if($n2>$n_max)
	{
	    $prod_max=$a*-$blist[$i];
	    $n_max=$n2;
	}
    }
}

print $prod_max;



sub quadratic_max
{
    my($aa,$p)=@_;
    my($x)=$p;
    my($n)=0;
    do
    {
	$n++;
	$p+=2*$n - 1 + $aa;
	
    }
    while(Prime::protected_is_prime($p));
    return $n-1;
}

