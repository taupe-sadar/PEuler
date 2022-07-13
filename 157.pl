use strict;
use warnings;
use Data::Dumper;
use Prime;
use Hashtools;

# The equation 1/a + 1/b = p/10^n can be written
#         10^n (a' + b') = p a' b' d, 
#         with d = a^b, a = d a', b = d b' 
# Then a' and b' are divisors of 10^n, being relatively prime
# We only need to loop twice over divisors of 10^n (a', b', excluding invalid pairs)
# And an other loop, chosing quantity for p and d

my($all)=0;
for(my($i)=1;$i<=9;$i++)
{
  $all += solutions_10n($i);
}
print $all;

sub solutions_10n
{
  my($n)=@_;
  my($count)=0;
  for(my($i)=1;$i<=$n;$i++)
  {
    for(my($j)=1;$j<=$n;$j++)
    {  
      $count += solutions_2_5_n(0,0,$i,$j,$n);
    }
  }

  for(my($i)=0;$i<=$n;$i++)
  {
    for(my($j)=0;$j<=$n;$j++)
    {  
      $count += solutions_2_5_n($i,0,0,$j,$n);
    }
  }
  return $count;
}

sub solutions_2_5_n
{
  my($a2,$a5,$b2,$b5,$max)=@_;
  
  my($a_plus_b)=2**$a2*5**$a5 + 2**$b2*5**$b5;
  my(%dec)=Prime::decompose($a_plus_b);
  Hashtools::increment(\%dec,2,$max-$a2-$b2);
  Hashtools::increment(\%dec,5,$max-$a5-$b5);
  my($num_divisors)=1;
  foreach my $p (keys(%dec))
  {
    $num_divisors *= $dec{$p}+1;
  }
  return $num_divisors;
}