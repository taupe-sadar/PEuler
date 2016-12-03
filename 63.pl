use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

my($sum)=0;
for(my($i)=1;$i<=9;$i++)
{
    my($n)=floor(1/(1-(log($i)/log(10))));
    $sum+=$n;
}
print $sum;
