use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use SmartMult;

# First we consider the p-valuation (with p=2 and p=5) of n! (k=10^12)
#
# We will work in the Z/kZ (k=10^5)
# First we work in Z/kZ* set, all the inversibles.
# In this set we will find all numbers and their inversibles, except 1 and -1
# Then multiplying all the numbers of Z/kZ* will result as -1
# Next we count how many times there Z/kZ in [1,n] and apply a division of n
#
# Then we consider all multiples of (2^a * 5^b )
# And will apply the same operation, but using n/(2^a * 5^b)

my($n)=10**12;
my($mod)=10**5;

my($val2)=fact_p_valuation($n,2);
my($val5)=fact_p_valuation($n,5);

my(@coprimes)=();
for(my($i)=0;$i<$mod;$i++)
{
  push(@coprimes,$i) if($i%2 != 0 && $i%5 != 0);
}

# print "$val2 $val5\n";

my($fact_product)=1;

for(my($fact2)=1;$fact2<=$n;$fact2*=2)
{
  for(my($fact5)=1;$fact5<=$n;$fact5*=5)
  {
    my($prod)=$fact2*$fact5;
    last if $prod > $n;
    
    # print "$prod\n";
    
    my($n_scaled)=floor($n/$prod);
    my($num_sets,$left)=(floor($n_scaled/$mod),$n_scaled%$mod);
    if($num_sets%2 == 1)
    {
      $fact_product= $mod-$fact_product; 
    }
    my($cop_idx)=0;
    while($coprimes[$cop_idx] <= $left )
    {
      $fact_product = ($fact_product*$coprimes[$cop_idx])%$mod;
      $cop_idx++;
    }
  }
}

$fact_product = ($fact_product * SmartMult::smart_mult_modulo(2,$val2-$val5,$mod))%$mod;
print $fact_product;

sub fact_p_valuation
{
  my($nb,$p)=@_;
  my($pval)=0;
  my($div)=$p;
  while($nb > $div)
  {
    $pval += floor($nb/$div);
    $div *= $p;
  }
  return $pval;
}