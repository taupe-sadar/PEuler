#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;

# We use arrays of hamming numbers, a[p1,p2,...,pn] which contains all numbers which
# prime decomposition contain only primes from p1 to pn, keeping values less than a defined bound
#
# We start with a[2] = [1,2,4,8,...] and a[3] = [1,3,9,27,...]
# We multiply together all values of all of those vectors.
# [1, p, p^2, p^3, ... ] so that all values are less than a maximum value
# 
# As an efficient optimization, we construct 2 of those vector, from dinstinct primes, 
# such that the vector size stay low
# Then we can count the number of the values that would be contained in an array of the multiplied values
# by incrementing iterator of these arrays

my($max_hamming)=10**9;
my($type)=100;

Prime::init_crible($type);
my(%numbers_1)=(1=>1);
my(%numbers_2)=(1=>1);
my($p)=Prime::next_prime();
while($p<=$type)
{
  my($numbers)=(scalar(keys(%numbers_1))>scalar(keys(%numbers_2)))?\%numbers_2:\%numbers_1;
  merge_prime_pows($numbers,$p,$max_hamming);
  $p=Prime::next_prime();
}

my(@hamms1)=(sort({$b<=>$a}keys(%numbers_1)));
my(@hamms2)=(sort({$a<=>$b}keys(%numbers_2)));

# Sentinel
push(@hamms2,$max_hamming+1);
my($count)=0;
my($i1,$i2)=(0,0);
while($i1<=$#hamms1)
{
  my($quotient_max)=floor($max_hamming/$hamms1[$i1]);
  $i2++ while( $hamms2[$i2] <= $quotient_max );
  $count += $i2;
  
  $i1++;
}

print $count;

sub merge_prime_pows
{
  my($rarray,$prime,$max)=@_;
  my($pow)=$prime;
  my(@vals)=(sort({$a<=>$b}keys(%$rarray)));
  
  while($pow<=$max)
  {
    for(my($i)=0;$i<=$#vals;$i++)
    {
      my($val)=$vals[$i]*$pow;
      last if($val > $max);
      $$rarray{$val}=1;
    }
    $pow*=$prime;
  }
}
