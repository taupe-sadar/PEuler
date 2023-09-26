#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

my($max)=2**50;
my($max_sq2)=floor(sqrt($max));

my($crible_size)=ceil(($max_sq2+1)/6)*2;
my(@crible)=(0)x$crible_size;

my($num_squared)=0;

my($p)=5;
for(my($i)=1;$i<$crible_size;$i++)
{
  if( $crible[$i] == -1)
  {
    $p+=($i%2==0)?4:2;
    next;
  }
  
  my($p2)=$p*$p;
  if( $crible[$i] == 0)
  {
    #remove squares
    my($kmax)=floor($max_sq2/$p2);
    my($square)=$p2;
    for(my($k)=1;$k<=$kmax;$k+=6)
    {
      $crible[($square-1)/3]=-1;
      $square+=4*$p2;
      $crible[($square-2)/3]=-1;
      $square+=2*$p2;
    }

    #remember p multiples
    my($amax)=floor($max_sq2/$p);
    my($num)=$p;
    my($modp)=($p%6 == 1)?1:2;
    for(my($a)=1;$a<=$amax;$a+=6)
    {
      my($pidx)=($num - $modp)/3;
      # if($p==7)
      # {
      # print "$num -> $pidx\n";<STDIN>;
      # }
      $crible[$pidx] ++ if( $crible[$pidx] != -1);
      $num+=4*$p;
      
      last if($num>$max_sq2);
      my($pidx2)=($num + $modp)/3 - 1;
      
      $crible[$pidx2] ++ if( $crible[$pidx2] != -1);
      # if($p==7)
      # {
      # print "$num -> $pidx2\n";
      # my($s)=join(" ",@crible[0..20]);
      # print "$s\n";
      # <STDIN>;
      # }
      $num+=2*$p;
    }
  }

  #count squared
  my($sign)=(($crible[$i]%2==0)?-1:1);
  $num_squared += $sign*floor($max/$p2);
  $num_squared -= $sign*floor($max/$p2/2);
  $num_squared -= $sign*floor($max/$p2/3);
  $num_squared += $sign*floor($max/$p2/6);

  # print "$i : ".(($i -$i%2)*3 + (($i%2==0)?1:5))." ($sign)\n";
  # my($s)=join(" ",@crible[0..20]);
  # print "$s\n";
  # <STDIN>;


  $p+=($i%2==0)?4:2;

}

print ($max - $num_squared);

sub ptoidx
{
  my($p)=@_;
  return ($p - $p%6)/6
}
