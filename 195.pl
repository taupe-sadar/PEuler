#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor/;

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
