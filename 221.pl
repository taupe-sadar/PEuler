use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Solver;
use Prime;
use Bezout;
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
#
# Depending on d :
# 1) if d is a prime, Z/pZ is a field, there are either 2 solutions, r and d - r, or 0 solutions.
#    - if d = 4k + 1, (-1)^(d-1)/2 = (-1)^(2k) = 1 [d], there are 2 solutions
#    - if d = 4k + 3, (-1)^(d-1)/2 = (-1)^(2k+1) = -1 [d], no solutions
#    - if d = 2, only one solution r = d - r = 1
# 2) if d is an exponent of a prime d = k^e, then the residuals r must verify :
#      r = r' + b * k^(e-1), where r' is a residual in Z/k^(e-1)
#      r^2 = -1 <=> r'^2 + 2*r'*b*k^(e-1) = -1
#      b = -(r^-1 + r)/2^-1[k], which gives us recursively 2 residuals (if there are residuals in Z/kZ)
#      if k = 2, no residuals in Z/4Z
# 3) if d as the form d = a*b, with a and b coprimes, and r_a is a residual in Z/aZ, and r_b a residual in Z/bZ
#      With Bezout there are u,v such that a*u + b*v = 1, and the residual r in Z/abZ must verify r^2 = -1 [a] and r^2 = -1 [b]
#      the only candidtae is the solution of the chinese leftover problem, than can be expressed : 
#        r = r_a*b*v + r_b*a*u
#        we can verify that r^2 = r_a^2 * (b*v)^2 + r_b^^2 * (a*u)^2 [ab]
#                           r^2 = -1 * (b*v)^2 - 1 * (a*u)^2 [ab]
#                           r^2 = -1 [ab]
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
  calc_residuals(\@all_divisors,\%residuals,$born);

  $count = count_alex(\@all_divisors,\%residuals,$born);
  push(@counts,[$born,$count]);

  $born *= 4;
}
my($last_residuals)=get_alex_range(\@all_divisors,\%residuals,$counts[-2][0],$counts[-1][0]);
my($offset)=$target - $counts[-2][1] - 1;
my($alexandrian_wanted)=$$last_residuals[$offset];
print $alexandrian_wanted;


sub calc_residuals
{
  my($rrdivisors,$rresiduals,$limit)=@_;

  Prime::reset_prime_index();
  my($p)=Prime::next_prime();
  my($pcount)=0;
  
  my($highest_div)=($limit/4)**(1/3);
  while($p < $highest_div)
  {
    if( $p%4 != 3 )
    {
      $$rrdivisors[$pcount] = [] if($#$rrdivisors < $pcount);
      my($rdivisors)= $$rrdivisors[$pcount];
      my($current_max_div) = ($#$rdivisors < 0)?0:$$rdivisors[-1];
      
      my($prev_residual)=fetch_residual($p);
      my(@new_divs)=();
      if($p > $current_max_div )
      {
        $$rresiduals{$p} = ($p == 2)?[$prev_residual]:[$prev_residual,$p - $prev_residual];
        push(@new_divs,$p);
      }

      my($prev_pow)=$p;
      my(@pows)=($p);
      for(my($pow)=$p*$p;$pow < $highest_div;$pow*=$p)
      {
        $prev_residual = fetch_pow_residual($prev_pow,$pow,$prev_residual);
        last if( $prev_residual == -1);

        if($pow > $current_max_div )
        {
          $$rresiduals{$pow} = [$prev_residual,$pow - $prev_residual];
          push(@new_divs,$pow);
        }
        
        $prev_pow = $pow;
        push(@pows,$pow);
      }

      for(my($k)=0;$k<=$#pows;$k++)
      {
        my($highest_prime)=floor(($highest_div-1)/$pows[$k]);
        for(my($i)=0;$i<$pcount;$i++)
        {
          my($pmult)=$$rrdivisors[$i];
          last if($$pmult[0] > $highest_prime);
          
          my($first_mult)=floor(($current_max_div)/$pows[$k]);
          my($stop_mult)=ceil(($highest_div)/$pows[$k]);
          for(my($j)=0;$j<=$#$pmult;$j++)
          {
            next if($$pmult[$j] <= $first_mult);
            last if($$pmult[$j] >= $stop_mult);
            my($div)=$pows[$k]*$$pmult[$j];
            push(@new_divs,$div);
            
            my($pm,$q)=($$pmult[$j],$pows[$k]);
            $$rresiduals{$div} = fetch_multiple_residual($pm,$$rresiduals{$pm},$q,$$rresiduals{$q});
          }
        }
      }
      @new_divs = sort({$a <=> $b} @new_divs);

      @$rdivisors = (@$rdivisors,@new_divs);
      $pcount++;
    }

    $p=Prime::next_prime();
  }
}

sub fetch_pow_residual
{
  my($prev_pow,$pow,$res)=@_;
  for(my($pow_res)=$res;$pow_res<$pow;$pow_res+=$prev_pow)
  {
    if( ($pow_res*$pow_res + 1)%$pow == 0)
    {
      return ( $pow_res <= $pow/2 )?$pow_res: ($pow - $pow_res);
    }
  }
  return -1;
}

sub fetch_multiple_residual
{
  my($p,$resp,$q,$resq)=@_;
  
  my($prod)=$p*$q;
  
  my(@residuals)=();
  for my $rp (@$resp)
  {
    for my $rq (@$resq)
    {
      push(@residuals,Bezout::congruence_solve(($p=>$rp,$q=>$rq)));
    }
  }

  @residuals=sort({$a<=>$b} @residuals);

  return \@residuals;
}

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

sub fetch_residual
{
  my($d)=@_;
  for(my($x)=0;$x<=$d/2;$x++)
  {
    return $x if(($x*$x+1)%$d == 0);
  }
  return -1;
}


