#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;
use Bezout;
use integer;

my($n)=50000000;

my($sq2)=sqrt(2);
my($prime_limit)=$n*$sq2;

my(@crible_residuals)=(0)x($n+1);

my($count_seen_primes)=0;
for(my($i)=2;$i<=$n;$i++)
{

  if($crible_residuals[$i]!=1)
  {
    my($prime)=0;
    if($crible_residuals[$i]==0)
    {
      $count_seen_primes++;
      $prime = 2*($i*$i) - 1;
    }
    else
    {
      $prime = $crible_residuals[$i];
    }
    
    my($residual)=$i;
    # print "$prime : $i\n" if($i < 100);
    my($other_res)=$prime - $i;
    if( $other_res < $n )
    {
      
      if( $prime < $n/100 )
      {
        my($p2)=$prime*$prime;


        my($factor)=(2*($residual*$residual) - 1)/$prime;
        my($inv)=Bezout::znz_inverse(4*$residual,$prime);
        my($residual_steps)= $factor * $inv % $prime;
        $residual_steps = ($residual_steps==0)?0:($prime - $residual_steps);
        init_residuals_2(\@crible_residuals,$prime,$p2,$residual,$residual_steps);

        my($other_factor)= $factor + 2*$prime -4*$residual;
        my($residual_steps_other)= $other_factor * $inv %$prime;
        init_residuals_2(\@crible_residuals,$prime,$p2,$other_res,$residual_steps_other);
      }
      else
      {
        init_residuals(\@crible_residuals,$prime,$i + $prime);
        init_residuals(\@crible_residuals,$prime,$other_res);
      }
    }
  }
}
print $count_seen_primes;


sub init_residuals
{
  my($rcrible,$p,$residual)=@_;

  for(my($nb)=$residual;$nb <= $#$rcrible;$nb+=$p )
  {
    $$rcrible[$nb] = (2*$nb*$nb - 1) if( $$rcrible[$nb] == 0 );
    $$rcrible[$nb]/=$p;
    
    while( $$rcrible[$nb] %$p == 0)
    {
      $$rcrible[$nb] /=$p;
    }
  }
}

sub init_residuals_2
{
  my($rcrible,$p,$p2,$residual,$residual_steps)=@_;
   
  for(my($nb)=$residual;$nb <= $#$rcrible;$nb+=$p )
  {
    $$rcrible[$nb] = (2*$nb*$nb - 1) if( $$rcrible[$nb] == 0 );
    $$rcrible[$nb]/=$p;
  }
  
  for(my($nb)=$residual + $residual_steps*$p;$nb <= $#$rcrible;$nb+=$p2 )
  {
    $$rcrible[$nb] /=$p;

    while( $$rcrible[$nb] %$p == 0)
    {
      $$rcrible[$nb] /=$p;
    }
  }
}
