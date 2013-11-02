use strict;
use warnings;
use Data::Dumper;
use ContinueFraction;
use POSIX qw/floor ceil/;
use List::Util qw( sum );

#The solution can be summaried to :
# For a triangle with 2 sides = a, and an other side = a + e (e in { -1;1} )
# Thearea is an integer iff 
# ( a - e ).( 3a + e ) is a perfect square
# with a - e = qr² 
# and  3a + e = qp² (no squares in q )
#
# possible only if q(p² - 3r²) = 4e
# which leads to 2 pairs of solutions
# 1 ) q = 2; p,q are odd, p = 2p'+1, r = 2r'+1
#      - e = 1 => p(p+1) - 3r(r+1) = 1 => IMPOSSIBLE
#      - e = -1 => p(p+1)= 3r(r+1) => Find all triangle numbers for this
#     Then perimeter P = 3a +e = qp² = 2( 2p'+1 )²
#
# 2) q = 1; p,q are even  p = 2p', r = 2r'
#      - p'² - 3r'² = e  => The solutions are given by the continued fraction of 3.
# Finally, the perimeter is 3a + e = qp² = 4p'²


my( $max ) = 10**9; 

my($max_p_for_triangles)= floor( (sqrt($max/2) - 1)/2 ); 

my(%triangles_numbers)=();
my(@triangles_sols)=();

my($current_triangle)=0;
for(my($p)=0;$p<= $max_p_for_triangles; $p++ )
{
  $current_triangle += $p;
  if( $current_triangle%3 == 0 && exists( $triangles_numbers{$current_triangle/3 } ))
  {
    push(@triangles_sols, $p );
  }
  $triangles_numbers{$current_triangle } = 1;
}

my($max_p_for_continued_fractions)= floor( sqrt($max)/2 );

my(@fraccont_sols)=();

my( $rsolutions_cont_fraction ) = ContinueFraction::solve_diophantine_equation2( 3, 1 ,$max_p_for_continued_fractions );

for( my($i)=0; $i <= $#$rsolutions_cont_fraction; $i++ )
{
  push( @fraccont_sols, $$rsolutions_cont_fraction[$i][0] );
}


my($sum_perimeters)=    sum( map { (2*$_)**2 } @fraccont_sols ) ;
$sum_perimeters   += 2* sum( map {(2*$_ +1)**2} @triangles_sols ) ;

print $sum_perimeters;
