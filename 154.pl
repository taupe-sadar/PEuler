#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

# The p valuation of C(n,k) can be calculated this way :
# First, p valuation of a!
# V_p(a!) = sum( floor(a/p^i) )
#         = sum( ( a - aj)/p^i ) (with aj = a % p^i ) 
# Then, with n = k + l, ni= n % p^i, ki= k % p^i, li= l % p^i
# V_p( C(n,k) ) = V_p(n!) - V_p(k!) - V_p(l!)
#               = sum( ( kj + lj - nj )/p^i )
# The quantity ( kj + lj - nj )/p^i, is either 0, or 1, iff kj > nj (think in the space Z/p^iZ)
# Then, the only important criteria for determining the multiple p, (p= 2 or 5 ) is kj > nj.
#
# For the Triangular coefficient T(n,k,l) :
# T(n,k,l) = n!/(k! * l! * (n-k-l)!)
#          = C(n,k) * C(n-k,l)
# With a variable change, as C(n,k) = C(n,n-k) we use 
#   T(n,k,l) = C(n,k) * C(k,l)
# 
# So we process 2 loops, one processing C(n,k), counting the multiplicity of 2s and 5s, the other processing C(k,l)

my($n)=200000;
my($p5)=5;
my($p2)=2;

my($multiple)=12;

my(@pows5)=pows_list($p5,$n);
my(@pows2)=pows_list($p2,$n);

my(@n5)=remainder($n,\@pows5);
my(@n2)=remainder($n,\@pows2);

my($global_count)=0;

my($begin)=0;
my(@k5) = remainder($begin,\@pows5);
my(@k2) = remainder($begin,\@pows2);

for(my($k)=$begin;$k<=$n;$k++)
{
  my($c2)=count_remainders(\@k2,\@n2);
  my($c5)=count_remainders(\@k5,\@n5);
  
  my($count)=0;
  my($count2)=0;
  my($need)=($multiple - $c5);
  if( ($need - 1) <= $#pows5 && $k >= $pows5[$need- 1] )
  {
    my($start)=(2*$k<$n)?0:(2*$k-$n);
    my($end)= int($k/2);
    last if($end < $start);
    
    $count += all_implem($start,$end,\@k5,\@k2,$c5,$c2);
    
    $global_count += 6 *$count;
    if( $k%2 == 0 )
    {
      $global_count -= 3 if(unique_count($end,\@k2,\@k5,$c2,$c5));
    }
    
    {
      $global_count -= 3 if(unique_count($start,\@k2,\@k5,$c2,$c5));
    }
  }
  
  list_increment(\@k2,\@pows2);  
  list_increment(\@k5,\@pows5);
}
print $global_count;

sub unique_count
{
  my($val,$rk2,$rk5,$c2,$c5)=@_;
  my($d2)=simple_count($val,$rk2,\@pows2);
  my($d5)=simple_count($val,$rk5,\@pows5);
  return ( $d2 + $c2 >= $multiple && $d5+ $c5 >= $multiple);
}


sub simple_count
{
  my($x,$rk,$rpows)=@_;
  my(@r) = remainder($x,$rpows);
  return count_remainders(\@r,$rk);
}

sub all_implem
{
  my($start,$end,$rk5,$rk2,$c5,$c2)=@_;
  if($c2>=$multiple)
  {
    return simple_case5_implem($start,$end,\@k5,$c5);
  }
  else
  {
    return melt_implem($start,$end,\@k5,$c5,\@k2,$c2);
  }
}


sub brute_force_implem
{
  my($start,$end,$rk5,$rk2,$c5,$c2)=@_;
  my($count)=0;
  my(@m5)=remainder($start,\@pows5);
  my(@m2)=remainder($start,\@pows2);
  for(my($m)=$start;$m<=$end;$m++)
  {
    my($d5)=count_remainders(\@m5,$rk5);
    list_increment(\@m5,\@pows5);
    
    my($d2) = count_remainders(\@m2,$rk2);
    list_increment(\@m2,\@pows2);
    
    $count ++ if(($c2 + $d2 >= 12)  && ($c5 + $d5 >= 12));
  }
  return $count;
}

sub melt_implem
{
  my($start,$end,$rk5,$c5,$rk2,$c2)=@_;
  my($cache5)={};
  my($pow2_idx)=$#pows2;
  my($pow5_idx)=$#pows5;
  my($cache)={};
  return melt_implem_rec($start,$end,$rk5,$multiple - $c5, $pow5_idx, $rk2,$multiple - $c2, $pow2_idx, $cache);
}

sub melt_implem_rec
{
  my($start,$end,$rk5,$need5, $pow5_idx,$rk2,$need2, $pow2_idx, $cache5)=@_;
  
  return 0 if( $pow5_idx + 1 < $need5 );
  return 0 if( $$rk5[0] +1 == $pows5[0] && $pow5_idx < $need5 );
  return 0 if( $pow2_idx + 1 < $need2 );
  
  if( $need2 <= 0 )
  {
    return simple_case_implem_rec($start,$end,$rk5,$need5,$pow5_idx,\@pows5,\&basic_count,$cache5);
  }
  else
  {
    my($rk,$need,$pow_idx,$rpows);
    
    my($step2)= ($need5 <= 0) || $pows5[$pow5_idx] < $pows2[$pow2_idx];
    if( $step2 )
    {
      ($rk,$need,$pow_idx,$rpows) = ($rk2,$need2,$pow2_idx,\@pows2);
    }
    else
    {
      ($rk,$need,$pow_idx,$rpows) = ($rk5,$need5,$pow5_idx,\@pows5);
    }
    
    my($mod)=$$rpows[$pow_idx];
    my($rem)=$$rk[$pow_idx];
    my($current_start)=$start;
    my($count)=0;
    my($prev_mod)= $start - ($start%$mod);
    while($current_start <= $end)
    {
      my($next_mod)= $prev_mod + $mod - 1;
      my($rem_border) = $prev_mod + $rem;
      my($ismultiple, $current_end) = (0,0);
      if( $rem_border < $current_start )
      {
        ($ismultiple, $current_end) = (1,$next_mod);
      }
      else
      {
        ($ismultiple, $current_end) = (0,$rem_border)
      }
      $current_end = $end if( $current_end > $end );
      if($step2)
      {
        $count += melt_implem_rec($current_start,$current_end,$rk5,$need5, $pow5_idx,$rk2,$need2 - $ismultiple, $pow2_idx-1, $cache5);
      }
      else
      {
        $count += melt_implem_rec($current_start,$current_end,$rk5,$need5 - $ismultiple, $pow5_idx - 1,$rk2,$need2, $pow2_idx, $cache5);
      }
      $prev_mod += $mod if($current_end == $next_mod);
      $current_start = $current_end + 1;
    }
    return $count;
  }
}

sub basic_count
{
  my($start,$end)=@_;
  return $end - $start + 1;
}

sub simple_case5_implem
{
  my($start,$end,$rk5,$c5)=@_;
  my($cache)={};
  return simple_case_implem_rec($start,$end,$rk5,$multiple - $c5,$#pows5,\@pows5,\&basic_count,$cache);
}

sub simple_case_implem_rec
{
  my($start,$end,$rk,$need,$pow_idx,$rpows,$subroutune_count,$cache)=@_;
  
  my($key)="$start-$end-$need-$pow_idx";
  return $$cache{$key} if(defined($cache) && exists($$cache{$key}));
  
  my($count)=0;
  if( $pow_idx + 1 < $need  || ($$rk[0] +1 == $$rpows[0] && $pow_idx < $need ) )
  {
  }
  elsif($need <= 0)
  {
    $count = &{$subroutune_count}($start,$end);
  }
  else
  {
    my($mod)=$$rpows[$pow_idx];
    my($rem)=$$rk[$pow_idx];
    
    my($idx_start)=int($start/$mod);
    my($idx_end)=int($end/$mod);
    
    my($pos_start)=$start%$mod;
    my($pos_end)=$end%$mod;
    
    if($idx_start < $idx_end)
    {
      my($full_intervals) = $idx_end - $idx_start - 1;
      my($multiples_intervals)= $full_intervals;
      my($no_multiples_intervals)= $full_intervals;
      
      if($pos_start <= $rem)
      {
        $no_multiples_intervals++;
        $count+= simple_case_implem_rec($pos_start,$rem,$rk,$need,$pow_idx-1,$rpows,$subroutune_count,$cache);
      }
      else
      {
        $count+= simple_case_implem_rec($pos_start,$mod-1,$rk,$need-1,$pow_idx-1,$rpows,$subroutune_count,$cache);
      }
      
      if($pos_end <= $rem)
      {
        $count+= simple_case_implem_rec(0,$pos_end,$rk,$need,$pow_idx-1,$rpows,$subroutune_count,$cache);
      }
      else
      {
        $multiples_intervals++;
        $count+= simple_case_implem_rec($rem+1,$pos_end,$rk,$need-1,$pow_idx-1,$rpows,$subroutune_count,$cache);
      }
      
      $count+= $multiples_intervals * simple_case_implem_rec(0,$rem,$rk,$need,$pow_idx-1,$rpows,$subroutune_count,$cache);
      $count+= $no_multiples_intervals * simple_case_implem_rec($rem+1,$mod-1,$rk,$need-1,$pow_idx-1,$rpows,$subroutune_count,$cache);
    }    
    elsif($idx_start == $idx_end)
    {
      if($pos_end <= $rem)
      {
        $count+= simple_case_implem_rec($pos_start,$pos_end,$rk,$need,$pow_idx-1,$rpows,$subroutune_count,$cache);
      }
      elsif($pos_start > $rem)
      {
        $count+= simple_case_implem_rec($pos_start,$pos_end,$rk,$need-1,$pow_idx-1,$rpows,$subroutune_count,$cache);
      }
      else
      {
        $count+= simple_case_implem_rec($pos_start,$rem,$rk,$need,$pow_idx-1,$rpows,$subroutune_count,$cache);
        $count+= simple_case_implem_rec($rem+1,$pos_end,$rk,$need-1,$pow_idx-1,$rpows,$subroutune_count,$cache);
      }
      
    }
  }
  $$cache{$key} = $count if(defined($cache));
  return $count;
}

sub count_remainders
{
  my($rrem_k,$rrem_n)=@_;
  my($count)=0;
  for(my($i)=0;$i<=$#$rrem_n;$i++)
  {
    $count ++ if($$rrem_k[$i] > $$rrem_n[$i]);
  }
  return $count;
}

sub remainder
{
  my($x,$rpows)=@_;
  my(@left)=();
  for my $pow (@$rpows)
  {
    push(@left,$x%$pow);
  }
  return (@left);
}


sub list_increment
{
  my($rvar,$rpows)=@_;
  for(my($i)=0;$i<=$#$rpows;$i++)
  {
    $$rvar[$i]++;
    $$rvar[$i]=0 if($$rvar[$i] == $$rpows[$i]);
  }
}

sub pows_list
{
  my($p,$n)=@_;
  my(@pows)=($p);
  while($pows[-1]*$p < $n)
  {
    push(@pows,$pows[-1]*$p);
  }
  return @pows;
}
