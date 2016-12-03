use strict;
use warnings;
use Data::Dumper;
use ContinueFraction;

my($nth_gold_nugget ) = 30;
my($d)=5;
my($sols) = ContinueFraction::solve_diophantine_equation( $d, 44, 0, $nth_gold_nugget*2 +2); #Exactly half of solutions are golden nuggets

my($count_nugget) = 0;
my($sum_golden_nugget)=0;
for( my($i)=0;$i<= $#$sols; $i ++ )
{
  my( $p ,$q )= ( $$sols[$i][0], $$sols[$i][1] );
  if( $p%5 == 2  )
  {
    my( $n ) =  ($p+8)/5  - 3;
       
    next if $n==0; #skipping $n = 0 
    $count_nugget ++;
    
    $sum_golden_nugget+= $n;
    
    if( $count_nugget == $nth_gold_nugget )
    {
      last;
    }
  }
}
print $sum_golden_nugget;
