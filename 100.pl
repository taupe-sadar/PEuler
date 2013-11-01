use strict;
use warnings;
use Data::Dumper;
use ContinueFraction;

my($max)=10**12;


my($limit_for_p)= 2*$max-1;
my($p,$q)=ContinueFraction::solve_diophantine_equation(2,-1,$limit_for_p);
print (($q+1)/2);

