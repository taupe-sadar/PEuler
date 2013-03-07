use strict;
use warnings;
use Data::Dumper;
use SmartMult;
use List::Util qw( max min );
use POSIX qw/floor ceil/;

my($pow_max)=99;
my($factor_max)=99;
my($max_sum_digits)=0;
my($a_min)=1;
for(my($a)=$factor_max;$a>=$a_min;$a--)
{
    my($b_min)=ceil(($max_sum_digits/9 + 1)*(log(10)/log($a)));
    my($change_a)=0;
    my($biggest)=SmartMult::smart_mult($a,$pow_max);
    for(my($b)=$pow_max;$b>=$b_min;$b--)
    {
	my($sum)=sum_digits($biggest);
	if($sum>$max_sum_digits)
	{
	    $max_sum_digits=$sum;
	    $b_min=ceil(($max_sum_digits/9 + 1)*(log(10)/log($a)));
	    $change_a=1;
	}
	$biggest/=$a;
    }
    if($change_a)
    {
	$a_min=ceil(exp(log(10)/$pow_max*($max_sum_digits/9 + 1)));
    }
}

print $max_sum_digits;

sub sum_digits
{
    my($bigstring)=@_;
    my(@tab)=split(//,$bigstring);
    my($sum)=0;
    for(my($n)=0;$n<=$#tab;$n++)
    {
	$sum+=$tab[$n];
    }
    return $sum;
}
