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

print Dumper \@pows5; <STDIN>;

for(my($k)=0;$k<=$n;$k++)
{
  my($c2)=count_remainders(\@k2,\@n2);
  my($c5)=count_remainders(\@k5,\@n5);
  
  my($need)=($multiple - $c5);
  if( ($need - 1) <= $#pows5 && $k >= $pows5[$need- 1] )
  {
    my($count)=0;

    my($start)=(2*$k<$n)?0:(2*$k-$n);
    my($end)= int($k/2);
    last if($end < $start);
    
    my($is_multiple_2)=$c2>=$multiple;
    if($is_multiple_2)
    {
      $count += simple_case_implem($start,$end,\@k5,$c5);
    }
    else
    {
      $count += brute_force_implem($start,$end,\@k5,\@k2,$c5,$c2);
    }

    if( $count > 0 )
    {
      print "$k ($c2): $count \n";
      # <STDIN>;
    }
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

sub simple_case_implem
{
  my($start,$end,$rk5,$c5)=@_;
  my($pow5_idx)=$#pows5;
  # while($pow5_idx >=0 && $pows5[$pow5_idx] > $end )
  # {
    # $pow5_idx--;
  # }
  # print Dumper $rk5;
  # <STDIN>;
  return simple_case_implem_rec($start,$end,$rk5,$multiple - $c5,$pow5_idx);
}


sub simple_case_implem_rec
{
  my($start,$end,$rk5,$need5,$pow5_idx)=@_;
  
  # my($ss)=" "x(6-$pow5_idx);
  if( $pow5_idx >=-1 )
  {
    # print "$ss$start,$end,$need5,$pow5_idx\n"; 
    # <STDIN>;
  }
  
  if( $pow5_idx + 1 < $need5 )
  {
    # print "$ss==> 0\n";
    return 0;
  }
  elsif($need5 == 0)
  {
    # print "$ss==> ".($end-$start+1)."\n";
    return $end-$start+1;
    
  }
  else
  {
    my($mod)=$pows5[$pow5_idx];
    my($rem)=$$rk5[$pow5_idx];
    
    my($idx_start)=int($start/$mod);
    my($idx_end)=int($end/$mod);
    
    my($pos_start)=$start%$mod;
    my($pos_end)=$end%$mod;
    
    my($count)=0;
    if($idx_start < $idx_end)
    {
      my($full_intervals) = $idx_end - $idx_start - 1;
      my($multiples_intervals)= $full_intervals;
      my($no_multiples_intervals)= $full_intervals;;
      
      if($pos_start <= $rem)
      {
        $no_multiples_intervals++;
        $count+= simple_case_implem_rec($pos_start,$rem,$rk5,$need5,$pow5_idx-1);
      }
      else
      {
        $count+= simple_case_implem_rec($pos_start,$mod-1,$rk5,$need5-1,$pow5_idx-1);
      }
      
      if($pos_end <= $rem)
      {
        $count+= simple_case_implem_rec(0,$pos_end,$rk5,$need5,$pow5_idx-1);
      }
      else
      {
        $multiples_intervals++;
        $count+= simple_case_implem_rec($rem+1,$pos_end,$rk5,$need5-1,$pow5_idx-1);
      }
      
      $count+= $multiples_intervals * simple_case_implem_rec(0,$rem,$rk5,$need5,$pow5_idx-1);
      $count+= $no_multiples_intervals * simple_case_implem_rec($rem+1,$mod-1,$rk5,$need5-1,$pow5_idx-1);
      
      # print "$ss==> $count ($multiples_intervals, $no_multiples_intervals)\n";
    }    
    elsif($idx_start == $idx_end)
    {
      if($pos_end <= $rem)
      {
        $count+= simple_case_implem_rec($pos_start,$pos_end,$rk5,$need5,$pow5_idx-1);
      }
      elsif($pos_start > $rem)
      {
        $count+= simple_case_implem_rec($pos_start,$pos_end,$rk5,$need5-1,$pow5_idx-1);
      }
      else
      {
        $count+= simple_case_implem_rec($pos_start,$rem,$rk5,$need5,$pow5_idx-1);
        $count+= simple_case_implem_rec($rem+1,$pos_end,$rk5,$need5-1,$pow5_idx-1);
      }
      
      # print "$ss==> $count(1)\n";
    }
    return $count;
  }
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

