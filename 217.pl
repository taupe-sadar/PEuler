#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor/;
use List::Util qw/sum/;

my($n)=47;
my($modulo)=3**15;

my($num_all_numbers)=[1];
my($num_nzero_numbers)=[0];

my($sum_all_numbers)=[0];
my($sum_nzero_numbers)=[0];

my($half)=floor($n/2);

my(@pows_10)=(1);
for(my($i)=1;$i<=($half+1);$i++)
{
  push(@pows_10,10*$pows_10[-1]%$modulo);
}

print "$modulo\n";
# print "".($modulo*$modulo*20)."\n";
# print "".(1<<62)."\n";

# <STDIN>;

my(@all_sums)=(0,45);

my($test_array,$test_nonzero)=testa(6);
print Dumper $test_array;
# <STDIN>;

sub testa
{
  my($n)=@_;
  my(@a)=();
  my(@z)=();
  for(my($i)=1;$i<=$n;$i++)
  {
    my(@t)=(0)x($i*9);
    push(@a,\@t);
    my(@t2)=(0)x($i*9);
    push(@z,\@t2);
  }
  for(my($i)=0;$i<$n;$i++)
  {
    my($min)=10**$i;
    for(my($nb)=$min;$nb<$min*10;$nb++)
    {
      my($s)=sum(split("",$nb));
      $z[$i][$s] += $nb;
      for(my($j)=$i;$j<$n;$j++)
      {
        $a[$j][$s] += $nb;
      }
    }
  }
  return (\@a,\@z);
}



for(my($ndigits)=1;$ndigits<=$half;$ndigits++)
{
  my(@c_num_all_numbers)=(0)x($#$num_all_numbers+1+9);
  my(@c_num_nzero_numbers)=(0)x($#$num_nzero_numbers+1+9);

  my(@c_sum_all_numbers)=(0)x($#$sum_all_numbers+1+9);
  my(@c_sum_nzero_numbers)=(0)x($#$sum_nzero_numbers+1+9);

  print " *** NDigits : $ndigits *** \n";
  for(my($sum)=0;$sum<=$#$num_all_numbers;$sum++)
  {
    # print "   --- sum : $sum *** \n";
    for(my($digit)=0;$digit<=9;$digit++)
    {
      my($digit_sum)=$sum + $digit;
      $c_num_all_numbers[$digit_sum] =   ($c_num_all_numbers[$digit_sum]   + $$num_all_numbers[$sum]) % $modulo;
      $c_num_nzero_numbers[$digit_sum] = ($c_num_nzero_numbers[$digit_sum] + $$num_all_numbers[$sum]) % $modulo if($digit > 0);

      $c_sum_all_numbers[$digit_sum] =   ($c_sum_all_numbers[$digit_sum] + $$sum_all_numbers[$sum]  + $digit*$pows_10[$ndigits-1]*$$num_all_numbers[$sum]) % $modulo;
      $c_sum_nzero_numbers[$digit_sum] = ($c_sum_nzero_numbers[$digit_sum] + $$sum_all_numbers[$sum] + $digit*$pows_10[$ndigits-1]*$$num_all_numbers[$sum]) % $modulo if($digit > 0);
    }
  }
  
  if($ndigits <= 6)
  {
    for(my($i)=0;$i<=$#c_sum_all_numbers;$i++)
    {
      if( $c_sum_all_numbers[$i] != $$test_array[$ndigits-1][$i]%$modulo )
      {
        print "Error !((1)$ndigits $i)\n";
        print Dumper \@c_sum_all_numbers;
        print Dumper $$test_array[$ndigits-1];
        <STDIN>;
      }
      if( $c_sum_nzero_numbers[$i] != $$test_nonzero[$ndigits-1][$i]%$modulo )
      {
        print "Error !((2)$ndigits $i)\n";
        <STDIN>;
      }
    }
    print "Ok $ndigits\n";
  }
  
  
  # print "Summary\n";
  # print Dumper \@c_num_all_numbers;
  # print Dumper \@c_num_nzero_numbers;
  
  # print Dumper \@c_sum_all_numbers;
  # print Dumper \@c_sum_nzero_numbers;
  # <STDIN>;


  my($odd_sum)=0;
  my($even_sum)=0;
  
  for(my($sum)=0;$sum <=$#c_num_all_numbers;$sum++)
  {
    my($sum_high)= ($c_sum_nzero_numbers[$sum]* $c_num_all_numbers[$sum])%$modulo;
    my($sum_middle) = ($c_num_nzero_numbers[$sum]* $c_num_all_numbers[$sum])%$modulo;
    my($sum_low) = ($c_num_nzero_numbers[$sum] * $c_sum_all_numbers[$sum])%$modulo;
    
    
    $odd_sum = ($odd_sum + $sum_high* 10 * $pows_10[$ndigits + 1] + 45*$sum_middle * $pows_10[$ndigits] + $sum_low * 10)%$modulo;
    $even_sum = ($even_sum + $sum_high * $pows_10[$ndigits ] + $sum_low)%$modulo;
    
    my($e)=$sum_high * $pows_10[$ndigits ] + $sum_low;
    # print "-- $sum : $e\n"
  }
  push(@all_sums,$even_sum,$odd_sum);
  
  $num_all_numbers = \@c_num_all_numbers;
  $num_nzero_numbers = \@c_num_nzero_numbers;

  $sum_all_numbers = \@c_sum_all_numbers;
  $sum_nzero_numbers = \@c_sum_nzero_numbers;
}

# print "test\n";
# my(@s)=(0);
# for(my($i)=0;$i<1000000;$i++)
# {
  # my(@dec)=();
  # my($nb)=$i;
  # while($nb>0)
  # {
    # push(@dec,$nb%10);
    # $nb = floor($nb/10);
  # }
  # push(@dec,0) while($#dec<5);
  
  # if($dec[4]!=0 && ($dec[0] + $dec[1] + $dec[2]== $dec[3] + $dec[4] + $dec[5]))
  # {
    # $s[$dec[0] + $dec[1]] += $i; 
  # }
  
  
  
# }
# print Dumper \@s;

my($total)=sum(@all_sums[1..47])%$modulo;
print Dumper \@all_sums;
print $total;