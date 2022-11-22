use strict;
use warnings;
use Data::Dumper;
use Gcd;
use Prime;
use Bezout;
use List::Util qw( sum );

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
print "$sol\n";
# my(@sorted)=sort({$a<=>$b} @$residus_e);
# print Dumper [@sorted[0..20]];
# <STDIN>;


# print Dumper \%dec;

my($min)=$n;
my($sum)=0;
for(my($e)=2;$e<0*$phi;$e++)
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
    
    # print "--> $e ($min)\n";<STDIN>;
  }
  
  
}
# print "$min : $sum\n";