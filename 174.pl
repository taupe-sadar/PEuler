use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;
use List::Util qw( max min );

# With squares of sides m > n, we have :
# m^2 - n^2 = t
# (m - n) * (m + n) = t
# 4 (m' - n') * (m' + n') = t if(m, n) both even
# 4 (m' - n') * (m' + n' + 1) = t if(m, n) both odd
#
# That means the number of solutions of type L(n) are 
# the numbers of divisors  of t/4, (t/4 = d1*d2, with d1 > d2 )
#
# If t/4 = prod( pi^ki ), then L(n) = prod( ki+1 ) / 2
# We iterate over all prime patterns


my($t)=1000000;
my($max_prime)=$t/4;
my($max_n)=10;

Prime::init_crible($max_prime + 100);
my(@primes)=();

push(@primes,Prime::next_prime());
while($primes[-1]<$max_prime)
{
  push(@primes,Prime::next_prime());
}

my(%lists)=multiplicity_lists($max_n);

my($total)=0;
for(my($i)=1;$i<=$max_n;$i++)
{
  my($rilist)=$lists{$i};
  my($res)=0;
  foreach my $list (@$rilist)
  {
    $res+=loop_over_primes($list,$max_prime);
  }
  # print "$i : $res\n";
  $total += $res;
}
print $total;

# print Dumper \%lists;


sub loop_over_primes
{
  my($rpattern,$limit)=@_;
  my(%used)=();
  return loop_over_primes_rec($rpattern,$limit,0,1,0,\%used);
}


sub loop_over_primes_rec
{
  my($rpattern,$limit,$pattern_idx,$cumulated,$minpidx,$rused)=@_;
 
  return  0 if( $cumulated > $limit );
  
  if( $#$rpattern == $pattern_idx )
  {
    my($bound)=floor($limit/$cumulated);
    my($maxpidx)=prime_dichotomy_mult($bound,$$rpattern[-1]);
    
    my($used_pidx)=$minpidx;
    foreach my $p (keys(%$rused))
    {
      $used_pidx ++ if( $p >= $minpidx && $p <= $maxpidx );
    }
    
    return max(0,$maxpidx + 1 - $used_pidx);
  }
  else
  {
    my($sum_sols) = 0;
    my($p_idx)=$minpidx;
    while($p_idx <= $#primes)
    {
      if( !exists($$rused{$p_idx}) )
      {
        my($cumul)= ($primes[$p_idx] ** $$rpattern[$pattern_idx]);
        $$rused{$p_idx} = 1;
        
        my($next_min) = ($$rpattern[$pattern_idx] != $$rpattern[$pattern_idx+1])? 0 : $p_idx + 1 ;
        
        my($num_sols) = loop_over_primes_rec($rpattern,$limit,$pattern_idx + 1,$cumulated * $cumul,$next_min,$rused );
        delete $$rused{$p_idx};
        last if($num_sols == 0);
        $sum_sols += $num_sols;
      }
      $p_idx++;
        
    }
    return $sum_sols;
  }
}

sub prime_dichotomy_mult
{
  my($max,$mult)=@_;
  
  return -1 if(2**$mult > $max);
  
  my($low,$high)=(0,$#primes);
  my($prime_max)=floor(exp(log($max)/$mult));
  while($high-$low>1)
  {
    my($guess)=floor(($high+$low)/2);
    if( $primes[$guess] > $prime_max )
    {
      $high = $guess;
    }
    else
    {
      $low = $guess;
    }
  }
  while(1)
  {
    my($test_high)=$primes[$high]**$mult > $max;
    my($test_low)=$primes[$low]**$mult <= $max;
    return $low if($test_high && $test_low);
    # print "********** Error in Precision\n";

    my($diff)=$test_low?1:-1;
    $low+=$diff;
    $high+=$diff;

    return ($#primes-1) if($high >= $#primes);
    return -1 if($low <= 0);
  }
}

sub multiplicity_lists
{
  my($max)=@_;
  my(%all_lists)=();
  my(@current)=();
  my($found)=1;
  my($size_max)=1;
  while($found)
  {
    $found = 0;
    my($idx)=$size_max-1;
    my($last_incremented_idx)=$idx;
    @current = (0)x$size_max;
    while($idx < $size_max)
    {
      $current[$idx]++;
      $last_incremented_idx = $idx;
      for(my($i)=0;$i<$idx;$i++)
      {
        $current[$i] = $current[$idx];
      }
      
      my($val)=calc_laminae_solutions(\@current);
      if($val <= $max )
      {
        my(@copy)=@current;
        $all_lists{$val} = [] unless(exists($all_lists{$val}));
        push(@{$all_lists{$val}},\@copy);
        $found = 1;
        $idx = 0;
      }
      else
      {
        $idx = $last_incremented_idx + 1;
      }
    }
    $size_max++;
  }
  return %all_lists;
}

sub calc_laminae_solutions
{
  my($rlist)=@_;
  my($prod)=1;
  foreach my $n (@$rlist)
  {
    $prod*=($n+1);
  }
  return ($prod - $prod%2)/2;
}