use strict;
use warnings;
use Data::Dumper;
use Prime;
use Bezout;
use List::Util qw( sum );

# If p is prime, then (Z/pZ)* (all inversibles of Z/pZ) is isomorphic to (Z/(p-1)Z,+)
# From left Chinois theorem, with p,q primes Z/pqZ is isomorphic to (Z/(p-1)Z x Z/(q-1)Z,+)
#
# 1) m is inversible in Z/pqZ 
# Let m = x^a * y^b, with x,y, generators of order p-1 and q-1 in Z/pqZ
# m^e = m <=> m^(e-1) = 1 <=> p-1 | (e-1)*a && q-1 | (e-1)*b
# With d = (p-1)^(e-1), p-1 = d p', e-1 = d e'
# We have p' | e' * a => p' | a, so it happens for a = 0, p', 2p', ..., (d-1)p', ie in d different ways.
# The same goes for b, so the number of m such that m^e = m is 
#  A = (p-1)^(e-1) * (q-1)^(e-1)
#
# 2) m is multiple of p. The multiples of p is a ring, it can be shown that it is isomorphic to Z/qZ.
# With the same reasoning, with a generator x^a of order q-1, the number of m such that m^e = m is :
#  B = (q-1)^(e-1)
#
# 3) m is multiple of q. Same as above, the number of m such that m^e = m is
#  C = (p-1)^(e-1)
#
# 4) m is 0
#
# The overall number A + B + C + 1 = ((p-1)^(e-1) + 1) * ((q-1)^(e-1) + 1)
#
# We have also one constraint : e^phi = 1.
# As phi is even, e is odd and e-1 is even, as p-1 and q-1.
# Then the minimal reachable for (p-1)^(e-1) or (q-1)^(e-1) is 2.
#
# For counting those cases, we considerer the primes pi in phi's prime decomposition
# For each pi we must have :
# e-1 != 0 [pi]
# e != 0 [pi] (first constraint)
#
# Exception for pi = 2
# e-1 = 0 [2]
# e-1 != 0 [4]
# So e-1 = 2 [4]
#
# The algorithm solves the above Chinois problem, and count repeats over the prod(pi) period

my($p,$q)=(1009,3643);
my($n)=$p*$q;
my($phi)=($p-1)*($q-1);


my(%decp)=Prime::decompose($p - 1);
my(%decq)=Prime::decompose($q - 1);

my(%dec)=Prime::decompose($phi);
my($residus_e)=[];
my($period)=1;
foreach my $p (sort({$a<=>$b} keys(%dec)))
{
  if($p == 2 )
  {
    $residus_e = [3];
    $period = 4;
  }
  else
  {
    my($new_period) = $period*$p; 
    my(@residus)=();
    my($inv_p)=Bezout::znz_inverse($p,$period);
    for(my($r)=2;$r<$p;$r++)
    {
      foreach my $s (@$residus_e)
      {
        push(@residus,($r + ($s - $r) * $inv_p * $p)%$new_period);
      }
    }
    $residus_e = \@residus;
    $period = $new_period;
  }
}
my($num_periods)=$phi/$period;
my($simple_sum)=sum(@$residus_e);

my($sol)=$num_periods * $simple_sum + $period*($#$residus_e + 1)* ($num_periods - 1) * $num_periods/2;
print $sol;
