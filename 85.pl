use strict;
use warnings;
use Data::Dumper;
use Sums;
use List::Util qw( sum max min );

my($target)=2*10**6;

my(@triangle_numbers)=();

my($val)=0;
my($n)=0;
while($val< $target)
{
    $val=Sums::side_sum(3,$n);
    push( @triangle_numbers , $val);
    $n++;
}

my($best_m,$best_n)=(0,0);
my($closest_area)=0;
my($best_delta)=$target;
my($start_nidx_with)=1;
for(my($midx)=$#triangle_numbers;$midx>0;$midx--)
{
    for(my($nidx)=$start_nidx_with; $nidx<=$#triangle_numbers;$nidx++)
    {
	my($prod)=$triangle_numbers[$midx]*$triangle_numbers[$nidx];
	my($delta) = abs($prod - $target);
	if($delta < $best_delta)
	{
	    $best_delta = $delta;
	    $closest_area = $prod;
	    ($best_m,$best_n)=($midx,$nidx);
	}
	if( $prod > $target)
	{
	    $start_nidx_with = max($nidx-1,1);
	    last;
	}
    }
  
}

print ($best_m*$best_n);
