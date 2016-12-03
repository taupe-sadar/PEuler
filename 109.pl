use strict;
use warnings;
use Data::Dumper;
use Hashtools;

my($select_checkout_less_than)=100;

my(@tab_double)=map({2*$_}(1..20,25));
my(@others)=(1..20,25, map( {3*$_} (1..20)) );
my(@all)=(@tab_double,@others);
print "$#all\n";
my(%occurences)=();

foreach my $final_shot (@tab_double)
{
    #Case two zeros
    Hashtools::increment( \%occurences, $final_shot );
    for( my($i)=0;$i<=$#all;$i++)
    {
	#Case one zero
	my($value)= $final_shot + $all[$i];
	Hashtools::increment( \%occurences, $value );
	for( my($j)=0;$j<=$i;$j++)
	{
	    my($value2)=$value + $all[$j];
	    Hashtools::increment( \%occurences, $value2 );
	}
    }
}

my($sum)=0;
foreach my $checkout (keys(%occurences))
{
    if($checkout < $select_checkout_less_than )
    {
	$sum+= $occurences{$checkout};
    }
}
print $sum;

