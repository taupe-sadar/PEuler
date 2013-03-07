use strict;
use warnings;
use Data::Dumper;
use Sums;
use POSIX qw/floor ceil/;
use List::Util qw(sum max min );

my(%side_numbers)=();
#On recense tous les nombres possibles
for(my($i)=3;$i<=8;$i++)
{
    my($nstart)=ceil(sqrt(1000/($i-2)));
    my(@tab)=();
    for(my($n)=$nstart;;$n++)
    {
	my($number)=Sums::side_sum($i,$n);
	if($number<1000)
	{
	    next;
	}
	if($number>=10000)
	{
	    last;
	}
	push(@tab,$number);
    }
    $side_numbers{$i}=\@tab;
}
#Et on teste toutes les combinaisons possibles
my($sum)=0;
for(my($i)=3;$i<=8;$i++)
{
    my($stop)=0;
    for(my($j)=0;$j<=$#{$side_numbers{$i}};$j++)
    {
	my(%hash_info)=();
	for(my($k)=3;$k<=8;$k++)
	{
	    $hash_info{$k}=1;
	}
	delete $hash_info{$i};
	my(@seq)=find_sequence($side_numbers{$i}[$j]%100,int($side_numbers{$i}[$j]/100),%hash_info);
	if($#seq>=0)
	{
	    push(@seq,$side_numbers{$i}[$j]);
	    $sum=sum(@seq);
	    $stop=1;
	    last;
	}
    }
    if($stop==1)
    {
	last;
    }
}

print "$sum\n";

sub find_sequence
{
    my($prefix,$lastpost,%availables)=@_;
    my(@keys)=sort(keys(%availables));
    for(my($i)=0;$i<=$#keys;$i++)
    {
	my(%new_available)=%availables;
	delete $new_available{$keys[$i]};
	for(my($j)=0;$j<=$#{$side_numbers{$keys[$i]}};$j++)
	{
	    if($side_numbers{$keys[$i]}[$j]=~m/^$prefix(..)$/)
	    {
		if($#keys==0)
		{
		    if(($side_numbers{$keys[$i]}[$j]%100)==$lastpost)
		    {
			my(@tab)=($side_numbers{$keys[$i]}[$j]);
			return @tab;
		    }
		}
		else
		{
		    my(@tab)=find_sequence($side_numbers{$keys[$i]}[$j]%100,$lastpost,%new_available);
		    if($#tab>=0)
		    {
			push(@tab,$side_numbers{$keys[$i]}[$j]);
			return @tab;
		    }
		}
	    }
	}
    }
    return ();
}
