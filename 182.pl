use strict;
use warnings;
use Data::Dumper;
use Gcd;
use Prime;

my($p,$q)=(1009,3643);
my($n)=$p*$q;
my($phi)=($p-1)*($q-1);

my(%dec)=Prime::decompose($phi);
print Dumper \%dec;

my($min)=$n;
my($sum)=0;
for(my($e)=2;$e<$phi;$e++)
{
  my($count)=0;
  my($gcd_e)=Gcd::pgcd($e,$phi);
  next if($gcd_e > 1);
  my($gcd_ep)=Gcd::pgcd($e-1,$p-1);
  my($gcd_eq)=Gcd::pgcd($e-1,$q-1);
  my($guess)=$gcd_ep* $gcd_eq + $gcd_ep +$gcd_eq;
  
  if($guess < $min)
  {
    $min = $guess;
    $sum = 0;
  }
  if($guess == $min)
  {
    $sum += $e;
  }
  
  
}
print "$min : $sum\n";