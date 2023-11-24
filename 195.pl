#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor/;

# Let a triangle with integer sides (a,b,c).
#
# The inner circle radius verifies :
#   R^2 = (a+b-c) * (a+c-b) * (b+c-a) / ( 4 * (a+b+c) ) 
#
# If the angle between sides a and b is pi/3, then 
#      a^2 - a*b + b^2 = c^2
# It can bve rewritten 
#     ( 2*c - 2*a + b ) * ( 2*c + 2*a - b ) = 3 * b^2
# 
# The factor 3, may divide either ( 2*c - 2*a + b ) or (2*c - 2*a + b), so there are 2 cases.
# # Case 1 :
#   - b = p * q * r
#   - 2*c - 2*a + b = 3 * p^2 * r    or    a = (q^2 - 3 * p^2 + 2 * p *q)/4 * r
#   - 2*c + 2*a - b = q^2 * r              c = (3 * p^2 + q^2)/4 * r
#   For unicity, and valid solutions, we want :
#   - pgcd(p,q) = 1
#   - q shall not be a multiple of 3 (otherwise, will fall in case #2)
#   - if p,q are both odd, then r must be a multiple of 4, otherwise it may be anything
#   - a > b which means q > 3*p
#   - The radius : R = sqrt(3)*p*(q-p)
# # Case 2 :
#   - b = p * q * r
#   - 2*c - 2*a + b = p^2 * r        or    a = (3 *q^2 - p^2 + 2 * p *r)/4 * r
#   - 2*c + 2*a - b = 3 * q^2 * r          c = (p^2 + 3 * q^2)/4 * r
#   For unicity, and valid solutions, we want :
#   - pgcd(p,q) = 1
#   - p shall not be a multiple of 3 (otherwise, will fall in case #2)
#   - if p,q are both odd, then r must be a multiple of 4, otherwise it may be anything
#   - a > b which means q > p
#   - The radius : R = 1/sqrt(3)*p*(3*q-p)/4
# 
# The inner circle radius 
# Algorithm : for both cases we iterate over p and q, checking that pgcd(p,q)=1, then
# counting how many multiple of solution are relevant, knowing the radius. (How many values possibles for r)
#
# Final optimization, caching the pgcd, so that pgcd(p,q) is calculated at most p times.

my($rmax)=1053779;

my($count)=0;
my($p)=1;
while(1)
{
  my($qmax)= $p + 4*$rmax/$p/sqrt(3);
  last if(3*$p+1 > $qmax);

  $count+=qloop1($p,3*$p+1,4);
  $count+=qloop1($p,3*$p+2,1);
  $count+=qloop1($p+1,3*$p+4,4);
  
  $p+=2;
}

$p=1;
while(1)
{
  my($qmax)= $p + 4*$rmax/$p*sqrt(3);
  last if($p+1 > $qmax);

  $count+=qloop2($p,$p+1,4);
  $count+=qloop2($p,$p+2,1);
  $count+=qloop2($p+1,$p+2,4);
  
  $p+=2;
}

print $count;

sub qloop1
{
  my($p,$qstart,$coeff)=@_;
  
  my($qmax)= $p + 4*$rmax/$p/sqrt(3)/$coeff;
  my($num)=0;
  if( $qmax > $qstart+2*$p )
  {
    my(@primes_with_q)=();
    my($q)=$qstart;
    for(my($d)=0;$d < 2*$p;$d+=2)
    {
      if(Gcd::pgcd($p,$q) == 1)
      {
        push(@primes_with_q,$q);
        if($q%3>0)
        {
          my($radius)=$p*($q-$p)*sqrt(3)/4;
          $num+=floor($rmax/$radius/$coeff);
        }
      }
      $q+=2;
    }
    my($idx)=0;
    while($q < $qmax)
    {
      $primes_with_q[$idx] += 2*$p;
      $q = $primes_with_q[$idx++];
      $idx = 0 if( $idx > $#primes_with_q );
      if($q%3>0)
      {
        my($radius)=$p*($q-$p)*sqrt(3)/4;
        $num+=floor($rmax/$radius/$coeff);
      }
    }
  }
  else
  {
    for(my($q)=$qstart;$q < $qmax;$q+=2)
    {
      next if($q%3==0);
      if(Gcd::pgcd($p,$q) == 1)
      {
        my($radius)=$p*($q-$p)*sqrt(3)/4;
        $num+=floor($rmax/$radius/$coeff);
      }
    }
  }
  return $num;
}

sub qloop2
{
  my($p,$qstart,$coeff)=@_;
  
  return 0 if($p%3==0);
  
  my($qmax)= ($p + 4*$rmax/$p*sqrt(3)/$coeff)/3;
  my($num)=0;
  
  if( $qmax > $qstart+2*$p )
  {
    my(@primes_with_q)=();
    my($q)=$qstart;
    for(my($d)=0;$d < 2*$p;$d+=2)
    {
      if(Gcd::pgcd($p,$q) == 1)
      {
        push(@primes_with_q,$q);
        my($radius)=$p*(3*$q-$p)/sqrt(3)/4;
        $num+=floor($rmax/$radius/$coeff);
      }
      $q+=2;
    }
    my($idx)=0;
    while($q < $qmax)
    {
      $primes_with_q[$idx] += 2*$p;
      $q = $primes_with_q[$idx++];
      $idx = 0 if( $idx > $#primes_with_q );
      my($radius)=$p*(3*$q-$p)/sqrt(3)/4;
      $num+=floor($rmax/$radius/$coeff);
    }
  }
  else
  {
    for(my($q)=$qstart;$q < $qmax;$q+=2)
    {
      if(Gcd::pgcd($p,$q) == 1)
      {
        my($radius)=$p*(3*$q-$p)/sqrt(3)/4;
        $num+=floor($rmax/$radius/$coeff);
      }
    }
  }
  return $num;
}
