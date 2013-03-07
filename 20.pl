use strict;
use warnings;
use Data::Dumper;
use Prime;
use Hashtools;
use List::Util qw( max min );
use SmartMult;
use bigint;

my($factorielle)=100;
my(%factorielle_dec)=();
my($i,$j)=(0,0);
for($i=1;$i<=$factorielle;$i++)
{
	my(%hash)=Prime::decompose($i);
	%factorielle_dec=Prime::hash_product(\%factorielle_dec,\%hash);
}

my($fact10)=0;
if(exists($factorielle_dec{2}))
{
	$fact10=$factorielle_dec{2};
}
if(exists($factorielle_dec{5}))
{
	$fact10=min($factorielle_dec{5},$fact10);
}

Hashtools::increment(\%factorielle_dec,2,-$fact10);
Hashtools::increment(\%factorielle_dec,5,-$fact10);
my($key);
my($very_big_number)=1;
foreach $key (keys %factorielle_dec)
{
	my($fact)=SmartMult::smart_mult($key,$factorielle_dec{$key});
	$very_big_number=$very_big_number*$fact;
}

my(@tab)=split(//,$very_big_number);
my($result)=0;
for($j=0;$j<=$#tab;$j++)
{
	$result+=$tab[$j];
}
print $result;

