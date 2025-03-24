use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Solver;
use Prime;
use Residual;
use List::Util qw( sum max min );

# Alexandrian number are of the form A = p * q * r, where 1 = p*q + q*r + p*r
# p,q, r are are relatives integers, some of them are negative, and necessary two of them.
# By Changing the sign of p and q, this can be reformulted by :
#
# 1 = p*q - q*r - p*r, all being positive integers
#
# we then have r = (1 - p*q)/(p + q)
# using the divisor d = p+q, (d > p)
#
# r = ( 1 - p * ( d - p )) / d = (1+p^2) / d - p. 
# (Note that d' = (1+p^2) / d is another divisor of p^2+1, such that d * d' = p^2+1)
# (And d' < p, thats more convinient)
#
# So for any integer p, and for any divisor of 1+p^2, there is an alexandrian, written 
#   A = p * q * r = p * ((1+p^2) / d - p) * ( d - p )
#
# We want to ensure the unicity of this triplet (p,q,r), using r < p < q
#   we already have q > r, since d > d', because  d > sqrt(p^2+1) ~ p > d'
#   p > r <=> d' < 2p, already true (d' < p)
#   p < q <=> d > 2p, or d' < p/2
#
# So we will look to all integer p, and its divisors d' of (p^2+1/2) in the interval [1;p/2]
#
# Actually, we are doing the inverse process : for all potential divisors d', will find all multiples
# m = k*d' such that m can be written m = p^2+1 
# we need to know what are the solutions of x^2 = -1 [d], ie the square residuals of -1 in Z/dZ
# This problem is treated in the Residual Package
#
# The algorithm choses a bound and is looking for all alexandrian up to that bound
#   First it finds all residuals we will need into this bound
#   Then, for all divisors d (including d = 1), for each residual r in Z/dZ, it counts the possible alexandrians
#   with p = r + k*d, with k > 2*d (symetry considerations).
# If the born is not large enough, the bound increases, 
# Finally we enumerate the alexandrian counted in the last iterations
# 

my($target)=150000;

Prime::init_crible(200000);

my(@all_divisors)=();
my(%residuals)=();

my($born)=10000;
my(@counts)=();
my($count)=0;
while($count < $target)
{
  my($highest_div)=($born/4)**(1/3);
  Residual::calc_residuals(\@all_divisors,\%residuals,-1,$highest_div);

  $count = count_alex(\@all_divisors,\%residuals,$born);
  push(@counts,[$born,$count]);

  $born *= 4;
}
my($last_residuals)=get_alex_range(\@all_divisors,\%residuals,$counts[-2][0],$counts[-1][0]);
my($offset)=$target - $counts[-2][1] - 1;
my($alexandrian_wanted)=$$last_residuals[$offset];
print $alexandrian_wanted;

sub count_alex
{
  my($rdivisors,$rresiduals,$limit)=@_;

  my($count_total)=0;
  
  # Manage divisor 1
  {
    my($last)=find_limit_alex(1,$limit);
    my($count) = max($last - 1,0);
    $count_total += $count;
  }

  for(my($i)=0;$i<=$#$rdivisors;$i++)
  {
    my($r_sub_divisors)=$$rdivisors[$i];

    for(my($j)=0;$j<=$#$r_sub_divisors;$j++)
    {
      my($d)=$$r_sub_divisors[$j];


      my($rres)=$$rresiduals{$d};
      
      my($last)=find_limit_alex($d,$limit);

      foreach my $r (@$rres)
      {
        my($init)=2*$d + $r;
        my($count)=max(floor(($last-$init)/$d) + 1,0);
        
        $count_total+= $count;
      }
    }
  }
  return $count_total;
}

sub get_alex_range
{
  my($rdivisors,$rresiduals,$limit_low,$limit_high)=@_;
  my(@alexs)=();
  
  my($one_last_low)=max(find_limit_alex(1,$limit_low),2);
  my($one_last_high)=find_limit_alex(1,$limit_high);
  for(my($p)=$one_last_low+1;$p<=$one_last_high;$p++)
  {
    push(@alexs,alexandrian($p,1));
  }

  for(my($i)=0;$i<=$#$rdivisors;$i++)
  {
    my($r_sub_divisors)=$$rdivisors[$i];
    for(my($j)=0;$j<=$#$r_sub_divisors;$j++)
    {
      my($d)=$$r_sub_divisors[$j];
      my($rres)=$$rresiduals{$d};
      
      my($last_low)=find_limit_alex($d,$limit_low);
      my($last_high)=find_limit_alex($d,$limit_high);

      foreach my $r (@$rres)
      {
        my($begin)= max(floor(($last_low+$d - $r)/$d),2)*$d + $r;
        my($end)= floor(($last_high - $r)/$d)*$d + $r;
        for(my($p)=$begin;$p<=$end;$p+=$d)
        {
          push(@alexs,alexandrian($p,$d));
        }
      }
    }
  }
  @alexs = sort({$a<=>$b} @alexs);
  return \@alexs;
}

sub find_limit_alex
{
  my($div,$stop)=@_;
  
  my($fn)= sub { my($p)=@_;return $p * (($p*$p +1)/$div - $p) * ($p - $div); };
  
  return Solver::solve_no_larger_integer($fn,floor(($stop*$div)**(1/4)),$stop);
}

sub alexandrian
{
  my($p,$d)=@_;
  my($frac)=$p*$p + 1;
  return $p * ($frac/$d - $p) * ($p - $d);
}
