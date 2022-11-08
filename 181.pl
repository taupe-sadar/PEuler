use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );
use IntegerPartition;
use Gcd;

# Lets call a geometric monomial, the infinite polynomial M(X) = (1 + X + X^2 + X^3 + ... )
# We now that the infinite polynomial product :
#
# P(X) = M(X) * M(X^2) * M(X^3) ...
#
# is the polynomial 1 + p(1) X + p(2) X^2 + p(3) X^3 + ...
# where p(n) is the number of partitions of the integer n.
#
# With the same reasoning, the 2 variables infinite polynomial
#
#  Q(X,Y) =     M(X) *     M(X^2) *     M(X^3)     * ...
#    * M(Y)   * M(X*Y) *   M(X^2*Y) *   M(X^3*Y)   * ... 
#    * M(Y^2) * M(X*Y^2) * M(X^2*Y^2) * M(X^3*Y^2) * ... 
# Can be written as 
#   Q(X,Y) = 1 + q(1,0) X + + q(0,1) Y + q(1,1) XY + q(2,0) X^2 + ...
#   where q(x,y) is the number of partion of an integer, with 2 colors
#
# The algorithm groups all the monomial factors expressed with P polynomial
#  Q(X,Y) = P(X) * P(Y) * P(XY) * P(XY^2) * ... * P(X^a Y^b) * ...  (with a^b = 1) 


my($maxX,$maxY)=(60,40);
my(@pentagonals)=();
for(my($i)=0;$i<=max($maxX,$maxY);$i++)
{
  push(@pentagonals,IntegerPartition::partition($i));
}

my(@subset_counts)=();
for(my($i)=0;$i<=$maxX;$i++)
{
  my(@t)=();
  for(my($j)=0;$j<=$maxY;$j++)
  {
    push(@t,$pentagonals[$i]*$pentagonals[$j]);
  }    
  push(@subset_counts,\@t);
}

multiply_geometric_monomial(1,1);

for(my($i)=2;$i<=max($maxX,$maxY);$i++)
{
  for(my($j)=1;$j<$i;$j++)
  {
    if( Gcd::pgcd($i,$j)==1)
    {
      multiply_geometric_monomial($i,$j);
      multiply_geometric_monomial($j,$i);
    }
  } 
}
print $subset_counts[$maxX][$maxY];

sub multiply_geometric_monomial
{
  my($step_x,$step_y)=@_;
  
  for(my($x)=$maxX;$x>=0;$x--)
  {
    for(my($y)=$maxY;$y>=0;$y--)
    {
      my($dx)=$x-$step_x;
      my($dy)=$y-$step_y;
      my($n)=1;
      while($dx>=0 && $dy >= 0)
      {
        $subset_counts[$x][$y] +=  $subset_counts[$dx][$dy] * $pentagonals[$n];
        $dx-=$step_x;
        $dy-=$step_y;
        $n++;
      }
    }
  }
}
