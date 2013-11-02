use strict;
use warnings;
use Data::Dumper;
use ContinueFraction;

my( $isocele_triangles ) = 12;
my($sols) = ContinueFraction::solve_diophantine_equation( 5, -1,  0, $isocele_triangles + 1  ); 

my($sum_L)=0;
#Skipping first trivial solution (2,0)
for( my($i)=1;$i<= $#$sols; $i ++ )
{
  my( $p ,$q )= ( $$sols[$i][0], $$sols[$i][1] );
  my($sign)= ($p%5 == 2) ? 1 : -1;
  my( $L, $b ) = ($q,  2*( $p -2*$sign ) / 5 );
  my($h) = $b + $sign;
  $sum_L += $L;
}

print $sum_L;

