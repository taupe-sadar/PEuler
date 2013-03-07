use strict;
use warnings;
use Data::Dumper;

my($n);

for($n=144;;$n++)
{
    my($square)=3*((4*$n-1)**2)-2;
    my($entier)=sqrt($square);
    if(!($entier=~m/\./))
    {
	if(($entier%6)==5)
	{
	    last;
	}
    }
}

print $n*(2*$n-1);
