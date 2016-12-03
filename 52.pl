use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;


my($number)=0;
for(my($digits)=1;;$digits++)
{
    my($found)=0;
    my($start)=ceil(10**($digits-1)/9);
    my($end)=floor(10**$digits/54);
    for(my($n)=$start;$n<=$end;$n++)
    {
	my($sorted_digits)=join("",sort(split(//,$n*9)));
	for(my($factor)=18;$factor<=54;$factor+=9)
	{
	    my($sorted_digits2)=join("",sort(split(//,$n*$factor)));
	    if($sorted_digits ne $sorted_digits2)
	    {
		last;
	    }
	    elsif($factor==54)
	    {
		$number=$n*9;
	    }
	}
	
	if($number)
	{
	    last;
	}

    }
    if($number)
    {
	last;
    }
    
}

print $number;
