use strict;
use warnings;
use Data::Dumper;
use Permutations;
use List::Util qw( max min );


my($max)=0;

for(my($total)=13;$total<=19;$total++)
{
    my($sum_interne)=5*$total - 55;
    my(@list_of_terms)= possible_terms_of_sum( 5, 1 , 9 , $sum_interne ); # somme des cases interne au 5-gon ring vaut 25 pour les 16-digits
   #On exclut le 10, pour n'avoir que les 16-digits.
    
    for(my($n)=0;$n<=$#list_of_terms;$n++)
    {
	for(my($p)=0;$p<24;$p++)
	{
	    my(@a)=Permutations::arrangement(4,4,$p);
	    my($string)=gon_ring_string($total,$list_of_terms[$n],\@a);
	    $max =max($string,$max);
	}
    }
}
print $max;

sub gon_ring_string
{
    my($total,$rlist_of_terms,$rperm)=@_;
    
    my($l)=$#$rlist_of_terms+1;
    my(%present)=();
    for(my($k)=0;$k<$l;$k++)
    {
	$present{$$rlist_of_terms[$k]}=1;
    }
    my(@externes)=();
    my(@internes)=();
    my(@strings)=();
    for(my($k)=0;$k<$l-1;$k++)
    {
	$internes[$k]=$$rlist_of_terms[ $$rperm[$k]  ];
    }
    $internes[$l-1]=$$rlist_of_terms[ -1 ];
    
    my($min_idx)=0;
    for(my($k)=0;$k<$l;$k++)
    {
	$externes[$k]=$total - $internes[$k] - $internes[($k-1)%$l];
	if($externes[$k] < 1 || $externes[$k] > 10 || exists($present{$externes[$k]}))
	{
	    return 0;
	}
	$present{$externes[$k]} = 1;
	if($externes[$k]<$externes[$min_idx])
	{
	    $min_idx = $k;
	}
	push(@strings,"$externes[$k]$internes[$k-1]$internes[$k]");
    }
    my($final_string)="";
    for(my($k)=0;$k<$l;$k++)
    {
	$final_string.=$strings[($k+$min_idx)%$l];
    }
    return $final_string;

}


sub possible_terms_of_sum
{
    my($n,$min,$max,$sum)=@_;
 
    my($min_sum)=(2* $min + $n -1)*$n/2;
    if( ($min_sum > $sum) || (2* $max - $n +1)*$n/2 < $sum )
    {
	return ();
    }

    my($minimum_max)=int(($sum - $min_sum)/$n) + $min;
    
    
    if( $n == 1)
    {
	my(@list)=($sum);
	return (\@list);
    }
    else
    {
	my(@list)=();
	for(my($nb)=$min;$nb<=$minimum_max;$nb++)
	{
	    my(@l)=possible_terms_of_sum( $n -1, $nb+1,$max, $sum -$nb);
	    	    
	    for(my($i)=0;$i<=$#l;$i++)
	    {
		unshift( @{$l[$i]}, $nb );
		push( @list, $l[$i]);
	    }
	}
	
	return @list;
    }
}
