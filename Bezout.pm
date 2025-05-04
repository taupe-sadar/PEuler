package Bezout;
use strict;
use warnings;
use Data::Dumper;
use Gcd;

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

# Gives solution of Chinese remainders problem
# x = a_1 [e_1], x = a_2 [e_2], ... , x = a_n [e_n] (a_i being coprimes)
# 
# there is only one solution x in Z/(a_1*a_2*...*a_n)Z

sub congruence_solve
{
  my( %modulo_values ) = @_;
  my(@modulos)=keys(%modulo_values);
  
  die "Invalid modulos in congruence_solve input" if($#modulos) < 0;
  my($left,$modulo)=($modulo_values{$modulos[0]},$modulos[0]);
  for(my($i)=1; $i<= $#modulos; $i++ )
  {
    my($remainder,$u,$v)=bezout_pair( $modulo, $modulos[$i] );
    die "congruence_solve must be used with prime themselves numbers" if($remainder != 1);
    my($big_modulo) = $modulo*$modulos[$i];
    $left = ($left*$modulos[$i]*$v + $modulo_values{$modulos[$i]}*$modulo*$u)%$big_modulo;
    $modulo = $big_modulo;
  }
  return $left;
}

sub multiple_congruence_solve
{
  my( $rcoprimes, $rmodulo_values ) = @_;
  
  die "Invalid coprimes in congruence_solve input" if($#$rcoprimes) < 0;
  
  my(@solutions)=();
  for(my($j)=0; $j<= $#$rmodulo_values; $j++ )
  {
    push(@solutions,$$rmodulo_values[$j][0]);
  }
  
  my($modulo)=$$rcoprimes[0];
  for(my($i)=1; $i<= $#$rcoprimes; $i++ )
  {
    my($remainder,$u,$v)=bezout_pair( $modulo, $$rcoprimes[$i] );
    die "congruence_solve must be used with prime themselves numbers" if($remainder != 1);
    my($big_modulo) = $modulo*$$rcoprimes[$i];
    for(my($j)=0; $j<= $#$rmodulo_values; $j++ )
    {
       $solutions[$j] = ($solutions[$j]*$$rcoprimes[$i]*$v + $$rmodulo_values[$j][$i]*$modulo*$u)%$big_modulo;
    }
    $modulo = $big_modulo;
  }
  return \@solutions;
}



1;
