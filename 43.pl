use strict;
use warnings;
use Data::Dumper;

my($limitf17)=int(1000/17);
my($k)=0;
my(@primes)=(13,11,7,5,3,2);
my($sum)=0;
for($k=1;$k<=$limitf17;$k++)
{
    my($d8910)=$k*17;
    $d8910=sprintf('%03s',$d8910);
    my(%available)=();
    my(@t)=split(//,$d8910);
    my($j);
    for($j=0;$j<=9;$j++)
    {
	$available{$j}=1;
    }
    my($stop)=0;
    for($j=0;$j<=$#t;$j++)
    {
	if(!exists($available{$t[$j]}))
	{
	    $stop=1;
	    next;
	}
	delete $available{$t[$j]}
    }
    if(!$stop)#pandigital
    {
	$sum+=find_pandigitals2371113($d8910,0,%available);
    }
}

print $sum;

sub find_pandigitals2371113
{
    my($units,$depth,%digits)=@_;
    if($depth>$#primes)
    {
	my(@digs)=(keys(%digits));
	return $digs[0]."$units";
    }
    else
    {
	my($k);
	my($sum)=0;
	foreach $k (keys(%digits))
	{
	    $units=~m/^(\d\d)/;
	    my($num)="$k$1";
	    if(($num % $primes[$depth])==0)
	    {
		my(%temp)=%digits;
		delete $temp{$k};
		$sum+=find_pandigitals2371113("$k$units",$depth+1,%temp);
	    }
	}
	return $sum;
	
    }
}

