use strict;
use warnings;
use Data::Dumper;
use Prime;
use Permutations;
use List::Util qw(sum max min );

my($highest_clique)=5;
Prime::init_crible(2000000);
Prime::next_prime();# on vire 2 direct
Prime::next_prime();# on vire 3 aussi, on le met a la main
Prime::next_prime();# on vire 5 aussi
my(%nodes)=("1"=>{"3"=>{}},"2"=>{"3"=>{}});#2 modes 1 et 2 %3
my(@list_primes)=();
my($maximum_length)=5;
create_primes($maximum_length); #en arg : le maximum de chiffres que peuvent avoir les primes
prime_insert(3,1,1,3);# prime , mode%3 , nb_chiffres , mode%7
prime_insert(3,2,1,3);# prime , mode%3 , nb_chiffres , mode%7

my(@minok)=(1,1,1);
my(@mins)=(0,3,10);
for(my($i)=3;$i<=$highest_clique;$i++)
{
    push(@mins,-1);
    push(@minok,0);
}
my(%inverses)=
(
    1 => 1, 2 => 4 , 3 => 5, 4 => 2, 5 => 3, 6 => 6
);

while($minok[$highest_clique]==0)
{
    
    my($p)=Prime::next_prime();
    my(%neighbors)=();
    my($mode)=$p%3;
    my($mode7)=$p%7;
    my($digits)=min(length($p),$maximum_length);
    my($key,$key2);
    my($pow10mod7)=3;
    for(my($i)=0;$i<$digits;$i++)
    {
	my($skip1) = (-$mode7*$inverses{$pow10mod7})%7;
	my($skip2) = (-$mode7*$pow10mod7)%7;
	for(my($j)=1;$j<=6;$j++)
	{
	    if(($j==$skip1)||($j==$skip2))
	    {
	       
		next;
	    }
	    my($length)=$#{$list_primes[$mode-1][$i][$j-1]};
	    for(my($k)=0;$k<=$length;$k++)
	    {
		$key = $list_primes[$mode-1][$i][$j-1][$k];
		if(is_edge($p,$key))
		{
		    $neighbors{$key}=1;
		}
	    }
	}
	$pow10mod7=($pow10mod7*3)%7;
    }
    prime_insert($p,$mode,$digits,$mode7);
    
    $nodes{$mode}{$p}=\%neighbors;
    for(my($i)=3;$i<=$highest_clique;$i++)
    {
	if($minok[$i]==1)
	{
	    next;
	}
	if($mins[$i-1]== -1)
	{
	    last;
	}
	
	my($val)=find_clique($i,$p,$mode,%neighbors); 
	
	 if($val)
	{
	    update_mins($i,$val)
	}
	if(($mins[$i]!=-1)&&($minok[$i]==0))
	{
	    my($maybe_lower)=0;
	    for(my($t)=1;$t<$i;$t++)
	    {
		if(($mins[$t]+$p*($i-$t))<$mins[$i])
		{
		    $maybe_lower=1;
		    last;
		}
	    }
	    if(!$maybe_lower)
	    {
		$minok[$i]=1;
	    }
	}
	

    }
    
}

print "$mins[$highest_clique]";

sub create_primes
{
    my($max)=@_;
    for(my($i)=0;$i<2;$i++)
    {
	my(@tab)=();
	for(my($j)=0;$j<$max;$j++)
	{
	    my(@tab2)=();
	    for(my($j)=1;$j<7;$j++)
	    {
		my(@tab3)=();
		push(@tab2,\@tab3);
	    }
	    push(@tab,\@tab2);
	}
	push(@list_primes,\@tab);
    }
}
sub prime_insert
{
    my($p,$m3,$digits,$m7)=@_;
    if($p==7)
    {
	for(my($i)=0;$i<6;$i++)
	{
	    push(@{$list_primes[$m3-1][$digits-1][$i]},$p);
	}
    }
    else
    {
	push(@{$list_primes[$m3-1][$digits-1][$m7-1]},$p);
    }
}


sub find_clique
{
    my($n,$first_node,$mode,%subset)=@_;
    my($refsmall,$refbig)=();
    if(keys(%subset)>keys(%{$nodes{$mode}{$first_node}}))
    {
	$refsmall=$nodes{$mode}{$first_node};
	$refbig=\%subset;
    }
    else
    {
	$refbig=$nodes{$mode}{$first_node};
	$refsmall=\%subset;
    }
    my(%new_subset)=();
    my($key);
    foreach $key (keys(%{$refsmall}))
    {
	if(exists($$refbig{$key}))
	{
	    $new_subset{$key}=1;
	}
    }
    my(@values)=(keys(%new_subset));
    if($#values<0)
    {
	return 0;
    }
    if($n<=2)
    {
	return (min(@values)+$first_node);
    }
    else
    {
	if(($#values+1)<($n-1))
	{
	    return 0;
	}
	my($ret_min)=0;
	foreach $key (@values)
	{
	    my($clique_found)=find_clique($n-1,$key,$mode,%new_subset);
	    if($clique_found)
	    {
		if($ret_min)
		{
		    $ret_min=min($clique_found,$ret_min);
		}
		else
		{
		    $ret_min=$clique_found;
		}
	    }
	    
	}
	if($ret_min==0)
	{
	    return 0;
	}
	else
	{
	    return ($ret_min+$first_node);
	}
	    
    }
}
sub update_mins
{
    my($n,$minimum)=@_;
    if($mins[$n]==-1)
    {
	$mins[$n]=$minimum;
	return 1;
    }
    elsif($mins[$n]>$minimum)
    {
	$mins[$n]=$minimum;
	return 1;
    }
    return 0;
}


sub is_edge
{
    my($a,$b)=@_;
    return ((Prime::fast_is_prime("$b$a"))&&(Prime::fast_is_prime("$a$b")));
}
