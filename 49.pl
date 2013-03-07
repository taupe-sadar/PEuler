use strict;
use warnings;
use Data::Dumper;
use Prime;

my($p)=0;
my(%list)=();
while($p<10000)
{
    $p=Prime::next_prime();
    if($p>1000)
    {
	my($num)=sort_prime($p);
	if(exists($list{$num}))
	{
	    push(@{$list{$num}},$p);
	}
	else
	{
	    my(@t)=($p);
	    $list{$num}=\@t;
	}
    }
}
my($key);
my(@result)=();
foreach $key (keys(%list))
{
    my(@tab)=@{$list{$key}};
    if($#tab>=2)
    {
	
	for(my($i)=0;$i<($#tab-1);$i++)
	{
	    if($tab[$i]==1487)
	    {
		next;
	    }
	    for(my($j)=$i+1;$j<$#tab;$j++)
	    {
		my($diff)=$tab[$j]-$tab[$i];
		for(my($k)=$j+1;$k<=$#tab;$k++)
		{
		    if($diff==($tab[$k]-$tab[$j]))
		    {
			
			@result=($tab[$i],$tab[$j],$tab[$k]);
			$i=$j=$k=$#tab+1;
		    }
		}
	    } 
	}
    }
    if($#result==2)
    {
	last;
    }
    
}

print join("",@result);
sub sort_prime
{
    my($p)=@_;
    return join("",sort(split(//,$p)));
     
}
