use strict;
use warnings;
use Data::Dumper;
use bigint;
use SmartMult;

my($pow)=1000;
my($two_pow_idx)=2;

my($powwow)=SmartMult::smart_mult($two_pow_idx,$pow);

my(@tab)=split(//,$powwow);
my($result)=0;
my($i)=0;
for($i=0;$i<=$#tab;$i++)
{
  $result+=$tab[$i];
}
print $result;