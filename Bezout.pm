package Bezout;
use strict;
use warnings;
use Data::Dumper;

# Bezout algorithm : let  a > b > 0 
# there exists a unique ( m, n) such that  
# a * n + b * m = a^b with abs( m ) < a and abs( n ) < b ;  

sub bezout_pair
{
  my( $a, $b )= @_;
  
  return (0,0) if ( $a ==0 || $b == 0);
  
  my( $sign_a ) = $a < 0 ? -1 : 1; $a *= $sign_a;
  my( $sign_b ) = $b < 0 ? -1 : 1; $a *= $sign_b;
  
  
  my($r0,$r1 ) = ($a, $b);
  my($m0,$m1) = (0,1);
  my($n0,$n1) = (1,0);
  
  while( $r1 != 0 )
  {
    my( $r ) = $r0 % $r1;
    my( $q ) = ($r0 - $r)/$r1;
    ( $r0, $r1 ) = ( $r1, $r );
    ( $m0, $m1 ) = ( $m1 , $m0 - $q * $m1 );
    ( $n0, $n1 ) = ( $n1 , $n0 - $q * $n1 );
  }
  
  return ( $r0 , $sign_a *$n0 , $sign_b*$m0 );
  
}

sub znz_inverse
{
  my( $element, $set_size ) =@_ ;
  die "set_size should be > 0" unless $set_size > 0;
  my( $r , $n , $m ) = bezout_pair( $element % $set_size , $set_size );
  
  return 0 if $r != 1;
  
  return $n% $set_size;
}

1;
