#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my($n)=200000;
my($p5)=5;
my($p2)=2;

my($multiple)=12;

my(@pows5)=pows_list($p5,$n);
my(@pows2)=pows_list($p2,$n);

my(@n5)=remainder($n,\@pows5);
my(@n2)=remainder($n,\@pows2);


my(@k5)=(0)x($#pows5+1);
my(@k2)=(0)x($#pows2+1);


my($count5)=0;
my($count2)=0;

# print Dumper \@pows5;
# print Dumper \@pows2;
# <STDIN>;

for(my($k)=0;$k<=$n;$k++)
{
  my($c2)=count_remainders(\@k2,\@n2);
  my($c5)=count_remainders(\@k5,\@n5);
  
  my($count)=0;
  my($need)=($multiple - $c5);
  if( ($need - 1) <= $#pows5 && $k >= $pows5[$need- 1] )
  {

    my($start)=(2*$k<$n)?0:(2*$k-$n);
    my($end)= int($k/2);
    last if($end < $start);
    
    my($is_multiple_2)=$c2>=$multiple;
    if($is_multiple_2)
    {
      $count += simple_case5_implem($start,$end,\@k5,$c5);
    }
    elsif(1)
    {
      my($count_5) = simple_case5_implem($start,$end,\@k5,$c5);
      my($count_2) = simple_case2_implem($start,$end,\@k2,$c2);
      my($count_brute) = brute_force_implem($start,$end,\@k5,\@k2,$c5,$c2);
      my($count_smart)= melt_implem($start,$end,\@k5,$c5,\@k2,$c2);
      
      print "$k ($c2,$c5): 5 : $count_5, 2 : $count_2 (".($end-$start+1 - $count_2  )."), brute : $count_brute, smart : $count_smart\n";
      # <STDIN>;
    }
    else
    {
      $count += brute_force_implem($start,$end,\@k5,\@k2,$c5,$c2);
      # $count += double_case_implem($start,$end,\@k5,\@k2,$c5,$c2);
    }
    
    if(!$is_multiple_2)
    {
      # my($count2) = brute_force_implem($start,$end,\@k5,\@k2,$c5,$c2);
      # if( $count != $count2 )
      # {
        # print "$k ($c5)($c2) Error : => $count != $count2\n" 
      # }
    }

  }
  else 
  {
    # print "Skip $k : $c5\n"; 
  }

  if( $count > 0)
  {
    # print "$k ($c2): $count \n";
    # <STDIN>;
  }
  
  #####
  $count5++ if($c5 >= 5);
  $count2++ if($c2 >= 12);
  
  list_increment(\@k2,\@pows2);  
  list_increment(\@k5,\@pows5);
}

print "2 : $count2, 5 : $count5\n";

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
  return 0 if( $pow2_idx + 1 < $need2 );
  
  if( $need2 <= 0 )
  {
    return simple_case_implem_rec($start,$end,$rk5,$need5,$pow5_idx,\@pows5,\&basic_count,$cache5);
  }
  else
  {
    my($rk,$need,$pow_idx,$rpows);
    
    # print "$start,$end,$need5, $pow5_idx,$need2, $pow2_idx\n";
    
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
    while($current_start <= $end)
    {
      my($prev_mod)= int($current_start/$mod)*$mod;
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
  my($pow5_idx)=$#pows5;
  # while($pow5_idx >=0 && $pows5[$pow5_idx] > $end )
  # {
    # $pow5_idx--;
  # }
  # print Dumper $rk5;
  # <STDIN>;
  my($cache)={};
  return simple_case_implem_rec($start,$end,$rk5,$multiple - $c5,$pow5_idx,\@pows5,\&basic_count,$cache);
}

sub simple_case2_implem
{
  my($start,$end,$rk2,$c2)=@_;
  my($pow2_idx)=$#pows2;
  # while($pow5_idx >=0 && $pows5[$pow5_idx] > $end )
  # {
    # $pow5_idx--;
  # }
  # print Dumper $rk5;
  # <STDIN>;
  my($cache)={};
  return simple_case_implem_rec($start,$end,$rk2,$multiple - $c2,$pow2_idx,\@pows2,\&basic_count,$cache);
}

sub double_case_implem
{
  my($start,$end,$rk5,$rk2,$c5,$c2)=@_;
  
  my($deep_cache)={};
  my($simple_implem)= sub {
    my($s,$e)=@_;
    simple_case_implem_rec($s,$e,$rk5,$multiple - $c5,$#pows5,\@pows5,\&basic_count,$deep_cache);
  };
  my($cache) = undef;
  return simple_case_implem_rec($start,$end,$rk2,$multiple - $c2,$#pows2,\@pows2,$simple_implem,$cache);
}


sub simple_case_implem_rec
{
  my($start,$end,$rk,$need,$pow_idx,$rpows,$subroutune_count,$cache)=@_;
  
  my($key)="$start-$end-$need";
  return $$cache{$key} if(defined($cache) && exists($$cache{$key}));
  
  my($ss)=" "x($#$rpows-$pow_idx);
  if( $pow_idx >=-1 )
  {
    # print "$ss$start,$end,$need,$pow_idx\n"; 
    # <STDIN>;
  }
  
  my($count)=0;
  if( $pow_idx + 1 < $need )
  {
    # print "$ss==> 0\n";
  }
  elsif($need <= 0)
  {
    $count = &{$subroutune_count}($start,$end);
    # print "$ss==> $count\n";
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
      
      # print "$ss==> $count\n";
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
      
      # print "$ss==> $count\n";
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

