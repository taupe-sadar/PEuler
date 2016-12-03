use strict;
use warnings;
use Data::Dumper;

my(%hash)=();
my(%smallest)=();
my($lastsize)=0;
my($result)=0;
for(my($i)=1;;$i++)
{
    my($cube)=$i**3;
    if(length($cube)>$lastsize)
    {
	$lastsize=length($cube);
	%hash=();
	%smallest=();
    }
    my($sorted_digits)=join("",sort(split(//,$cube)));
    if(exists($hash{$sorted_digits}))
    {
	$hash{$sorted_digits}++;
	if($hash{$sorted_digits}==5)
	{
	    $result=$smallest{$sorted_digits};
	    last;
	}
    }
    else
    {
	$hash{$sorted_digits}=1;
	$smallest{$sorted_digits}=$cube;
    }
}

print $result;
