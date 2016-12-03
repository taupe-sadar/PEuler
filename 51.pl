use strict;
use warnings;
use Data::Dumper;
use Prime;
use Permutations;
use POSIX qw/floor ceil/;
use List::Util qw( max min );


my(@units)=(
    [1,7],
    [1,3,7,9],
    [3,9]
    );
my($digits)=4;
my($res)=1;
while(1) 
{
    
    $res=10**$digits;
    my($nb_x)=floor(($digits-1)/3)*3;
    for(my($a)=3;$a<=$nb_x;$a+=3)
    {
	my($num_permutations)=Permutations::cnk($digits-1,$a);
	for(my($b)=0;$b<$num_permutations;$b++)
	{
	    my($fixed_digits)=$digits-1-$a;
	    my(@perm)=Permutations::subset($digits-1,$fixed_digits,$b);
	    my(@tab)=();
	    for(my($c)=0;$c<($digits-1);$c++)
	    {
		$tab[$c]='x';
	    }
	    if($#perm<0)#cas pas de chiffres supplementaires
	    {
		my($val)=test_pattern($units[0],@tab);
		if($val)
		{
		    $res=min($res,$val);
		}
	    }
	    else
	    {
		my($start)=($perm[0]>0)?0:(10**($fixed_digits-1));
		for(my($c)=$start;$c<(10**$fixed_digits);$c++)
		{
		    my(@cc)=split(//,sprintf("%0$fixed_digits".'s',$c));
		    for(my($d)=0;$d<=$#perm;$d++)
		    {
			$tab[$perm[$d]]=$cc[$d];
		    }
		    my($val)=min($res,test_pattern($units[$c%3],@tab));
		    if($val)
		    {
			$res=min($res,$val);
		    }
		}
	    }
	    
	}
	
    }
    if($res<10**$digits)
    {
	last;
    }
    $digits++;
}

print $res;


sub test_pattern
{
    my($refunit,@ta)=@_;
    my($retour)=0;
    
    for(my($u)=0;$u<=$#{$refunit};$u++)
    {
	my($st)=($ta[0] eq 'x')?1:0;
	my($fail)=($st==1)?1:0;
	my($string)=join("",@ta).$$refunit[$u];
	my($minimum)=0;    
	for(my($in)=9;$in>=$st;$in--)
	{
	    my($str)=$string;
	    $str=~s/x/$in/g;
	    if(!Prime::fast_is_prime($str))
	    {
		$fail++;
	    }
	    else
	    {
		$minimum=$str;
	    }
	    if($fail>2)
	    {
		last;
	    }
	}
	if($fail<=2)
	{
	    if($retour==0)
	    {
		$retour=$minimum;
	    }
	    else
	    {
		$retour=min($retour,$minimum);
	    }
	}
    
    }
    
    return $retour;
}

