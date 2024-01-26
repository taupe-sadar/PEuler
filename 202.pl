#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;
use Gcd;


# my($S)=1000001;
my($S)=12017639147;

my($sr)=($S+3)/2;

my($b)=2-(($sr+2)%3);
my($a)=($sr - 2*$b)/3;

my($count)=0;

if( $b != 0 )
{
  print "Interval [$b;".(3*$a+$b)."] -> sr = $sr\n";
  my(%dec)=Prime::decompose($sr);
  my(@simple_prime_sets)=([1]);
  $count = $a + 1;
  foreach my $p (sort(keys(%dec)))
  {
    push(@simple_prime_sets,[]);
    for(my($set)=$#simple_prime_sets - 1;$set>=0;$set--)
    {
      for my $n (@{$simple_prime_sets[$set]})
      {
        my($nb)=$n*$p;
        
        my($first)=(($nb%3)==$b)?$nb:(2*$nb);
        my($num_multiples) = floor((3*$a+$b-$first)/(3*$nb)) + 1; 
        
        my($minus)=(($set%2 == 0)?-1:1);
        print "$nb :  $num_multiples ($minus)\n";
        
        $count += $num_multiples * (($set%2 == 0)?-1:1);
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



# print ((52*53*88/3)."\n");

print "$count\n";
