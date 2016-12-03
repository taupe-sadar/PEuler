use strict;
use warnings;
use Data::Dumper;
use Prime;
use List::Util qw( max min );

my($a);
my($max)=0;
#test (1,2,3)
for($a=123;$a<=327;$a+=3)
{
    if(test_pandigital($a,2*$a,3*$a))
    {
	$max=max($max,"$a".(2*$a)."".(3*$a)); 
    }
}

#test (1,2)
for($a=5124;$a<=9876;$a+=3)
{
    if(test_pandigital($a,2*$a))
    {
	$max=max($max,"$a".(2*$a));
    }
}

print $max;


sub test_pandigital
{
    my(@num)=@_;
    
    my($s)=join("",sort(split(//,join("",@num))));
    return ($s eq "123456789");
   
    
}
