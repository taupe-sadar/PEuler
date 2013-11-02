use strict;
use warnings;
use Data::Dumper;
use ContinueFraction;

my($max)=10**12;


my($limit_for_p)= 2*$max-1;
my($sols)=ContinueFraction::solve_diophantine_equation2(2,-1,$limit_for_p,1);
print (($$sols[-1][1]+1)/2);

