#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;
use Gcd;


# my($S)=1000001;
my($S)=12017639147;

my($sr)=($S+3)/2*0 + 5*11;

my($b)=2-(($sr+2)%3);
my($a)=($sr - 2*$b)/3;

my($count)=0;
my($count2)=0;

my($count_extra)=0;

if( $b != 0 )
{
  print "Interval [$b;".(3*$a+$b)."] -> sr = $sr\n";
  my(%dec)=Prime::decompose($sr);
  print Dumper \%dec;
  
  my(@simple_prime_sets)=([1]);
  $count = $a + 1;
  $count2 = $a + 1;
  $count_extra =( ($b==1)?1:-1);
  foreach my $p (sort(keys(%dec)))
  {
    push(@simple_prime_sets,[]);
    for(my($set)=$#simple_prime_sets - 1;$set>=0;$set--)
    {
      for my $n (@{$simple_prime_sets[$set]})
      {
        my($nb)=$n*$p;
        my($mu)=(($set%2 == 0)?-1:1);
        
        my($first)=(($nb%3)==$b)?$nb:(2*$nb);
        my($num_multiples) = floor((3*$a+$b-$first)/(3*$nb)) + 1; 
        
        my($d)=$nb;
        my($k)=$sr/$d;
        my($e)=$first/$nb;
        my($truc)=3*$a+$b-$first;
        
        my($dr)=$d%3;
        my($kr)=$k%3;
        my($er)=$e%3;
        my($tr)=$truc%3;
        
        my($residual)=($b==($d%3))?(2-$e):(1-$e);
        
        $count_extra += $residual*$mu;
        $count2 += ($sr/$d + $residual)/3*$mu;
        
        
        
        print "$count2\n";
        print "(b=$b) d=$nb($dr) k=$k($kr) e=$e($er) truc = $truc ($tr)\n";
        # <STDIN>;
        
        
        print "$nb :  $num_multiples ($mu)\n";
        
        if( $num_multiples != ($sr/$d + $residual)/3 )
        {
          print "Stop ($num_multiples) != (".(($sr/$d + $residual)/3).")\n";
          <STDIN>;
        }
        
        
        $count += $num_multiples * $mu;
        push(@{$simple_prime_sets[$set+1]},$nb);
      }
    }
  }
  # print Dumper \@simple_prime_sets;<STDIN>;
  
  # for(my($i)=0;$i<=$a;$i++)
  # {
    # my($y)=$r + 3*$i;
    # my($x)=$r + 3*($a-$i);
    # $num++ if(Gcd::pgcd($x,$y)==1);
  # }
}

print "extra : $count_extra/3 = ".($count_extra/3)."\n";
print "$count\n";
print "$count2\n";
