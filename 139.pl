use strict;
use warnings;
use Data::Dumper;
use ContinueFraction;

my( $max_perimeter ) = 100*10**6;
my( $limit_for_p ) = int( $max_perimeter * ( sqrt(2)/(sqrt(2)+1) ) );

my($sols) = ContinueFraction::solve_diophantine_equation( 2, -1, $limit_for_p, 0  ); 

my($count_triangles)= 0;
#Skipping the trivial first one...
for( my($i)=1;$i<= $#$sols; $i ++ )
{
  my( $p ,$q )= ( $$sols[$i][0], $$sols[$i][1] );
  my( $a , $b , $c ) = ( ($p-1)/2 +1  ,($p-1)/2, $q );
  my( $perimeter ) = $a + $b + $c;
  $count_triangles += int( ($max_perimeter-1)/ $perimeter );
}

print $count_triangles;
