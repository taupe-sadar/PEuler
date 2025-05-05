package Residual;
use strict;
use Prime;
use Bezout;
use POSIX qw/floor ceil/;
use Set;

# Calculates the square residuals, ie the solutions of x^2 = r in Z/pZ
# Depending on p :
# 1) if p is a prime, Z/pZ is a field, there are either 2 solutions, r and p - r, or 0 solutions.
#    (Case r = -1)
#    - if p = 4k + 1, (-1)^(p-1)/2 = (-1)^(2k) = 1 [p], there are 2 solutions
#    - if p = 4k + 3, (-1)^(p-1)/2 = (-1)^(2k+1) = -1 [p], no solutions
#    - if p = 2, only one solution r = d - r = 1
#    (Case r = 1)
#    - 1 and p - 1  are always solutions
# 2) if p is an exponent of a prime p = k^e, then the residuals a must verify :
#      a = a' + b * k^(e-1), where a' is a residual in Z/k^(e-1)
#      a^2 = r <=> a'^2 + 2*a'*b*k^(e-1) = r
#      b = r*(a^-1 + a)/2^-1[k], which gives us recursively 2 residuals (if there are residuals in Z/kZ)
#      if k = 2, no residuals in Z/4Z
# 3) if d as the form d = a*b, with a and b coprimes, and r_a is a residual in Z/aZ, and r_b a residual in Z/bZ
#      With Bezout there are u,v such that a*u + b*v = 1, and the residual r in Z/abZ must verify x^2 = r [a] and x^2 = r [b]
#      the only candidate is the solution of the chinese leftover problem, than can be expressed : 
#        x = x_a*b*v + x_b*a*u
#        we can verify that x^2 = x_a^2 * (b*v)^2 + x_b^2 * (a*u)^2 [ab]
#                           x^2 = r * (b*v)^2 + r * (a*u)^2 [ab]
#                           x^2 = r [ab]

sub calc_residuals
{
  my($rrdivisors,$rresiduals,$residual_val,$highest_div,$max_prime)=@_;

  $max_prime = $highest_div unless(defined($max_prime));
  
  Prime::reset_prime_index();
  my($p)=Prime::next_prime();
  my($pcount)=0;
  
  while($p < $max_prime)
  {
    if(valid_prime($p,$residual_val))
    {
      $$rrdivisors[$pcount] = [] if($#$rrdivisors < $pcount);
      my($rdivisors)= $$rrdivisors[$pcount];
      my($current_max_div) = ($#$rdivisors < 0)?0:$$rdivisors[-1];
      
      my($prev_residual)=fetch_prime_residual($p,$residual_val);
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
        $prev_residual = fetch_exp_residual($prev_pow,$pow,$prev_residual,$residual_val);
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

sub valid_prime
{
  my($p,$residual)=@_;
  if($residual == -1)
  {
    return ($p%4 != 3);
  }
  else
  {
    return 1;
  }
}

sub fetch_prime_residual
{
  my($d,$residual_val)=@_;
  if($residual_val == 1)
  {
    return 1;
  }
  else
  {
    $residual_val += $d if($residual_val < 0);
    for(my($x)=0;$x<=$d/2;$x++)
    {
      return $x if(($x*$x)%$d == $residual_val);
    }
    return -1;
  }
}

sub fetch_exp_residual
{
  my($prev_pow,$pow,$res,$residual_val)=@_;
  if($residual_val == 1)
  {
    return 1;
  }
  else
  {
    $residual_val += $pow if($residual_val < 0);
    for(my($pow_res)=$res;$pow_res<$pow;$pow_res+=$prev_pow)
    {
      if( ($pow_res*$pow_res)%$pow == $residual_val)
      {
        return ( $pow_res <= $pow/2 )?$pow_res: ($pow - $pow_res);
      }
    }
    return -1;
  }
}

sub fetch_multiple_residual
{
  my($p,$resp,$q,$resq)=@_;
  
  my($rresidual_pairs)=Set::cartesian_product([$resp,$resq]);
  
  my($rresiduals)=Bezout::congruence_solve([$p,$q],$rresidual_pairs);

  @$rresiduals=sort({$a<=>$b} @$rresiduals);

  return $rresiduals;
}

1;