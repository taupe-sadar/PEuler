use strict;
use warnings;
use Data::Dumper;
use Gcd;

# An simple way to define f(n)
#  - f(n) = (n-1)/2             if n odd
#  - f(n) = f(n/2) + f(n/2 - 1) if n even
# 
# We can reverse this function, starting with f(n) and f(n-1).
# At each step,
#  - if f(n) is bigger, it means its from a sum, and then n is even
#  - if f(n) is lower, it means that n is odd
# We can deduce all the bits of n, starting the least significant, to the most significant 

my($a)=123456789;
my($b)=987654321;

my($d)=Gcd::pgcd($a,$b);

my(@seq)=();

my($ar)=$a/$d;
my($br)=$b/$d;

while($ar != 1 && $br != 1)
{
  my($bigest)=($ar > $br)?\$ar:\$br;
  my($lowest)=($ar > $br)?\$br:\$ar;
  
  my($r)=$$bigest%$$lowest;
  push(@seq,($$bigest-$r)/$$lowest);
  $$bigest = $r;
}
if( $ar == 1)
{
  push(@seq,$br);
}
else
{
  push(@seq,$ar - 1, 1);
}

print join(",",reverse(@seq));


