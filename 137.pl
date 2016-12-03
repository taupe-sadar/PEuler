use strict;
use warnings;
use Data::Dumper;
use ContinueFraction;

my($nth_gold_nugget ) = 15;
my($d)=5;
my($sols) = ContinueFraction::solve_diophantine_equation( $d, -4, 0, $nth_gold_nugget *2 + 2  ); #Exactly half of solutions are golden nuggets

my($count_nugget) = 0;
my($golden_nugget);
for( my($i)=0;$i<= $#$sols; $i ++ )
{
  my( $p ,$q )= ( $$sols[$i][0], $$sols[$i][1] );
  if( $p%5 == 1   )
  {
    next if $p==1; #skipping p =1 -> trivial solution.
    $count_nugget ++;
    if( $count_nugget == $nth_gold_nugget )
    {
      $golden_nugget = ($p-1) / 5;
      last;
    }
  }
}

print $golden_nugget;

