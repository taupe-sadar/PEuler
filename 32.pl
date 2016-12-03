use strict;
use warnings;
use Data::Dumper;
use Permutations;
use List::Util qw( max min );

#Avec la propriete magique 10^k=1[9] on a : a*x=y[9], a + x + y = 0 [9] !
my(@a_possible)=(3,4,6,7);
my(@x_possible)=(6,1,3,7);
my(%list);
my($i,$j,$k);
#Cas a<10
for($i=0;$i<=$#a_possible;$i++)
{
    my($nb_arr)= 8 * 7 * 6;
    for($j=0;$j<$nb_arr;$j++)
    {
	my(@arr)=Permutations::arrangement(8,3,$j);
	my($xstring)="";
	my($xmod)=0;
	
	for($k=0;$k<=$#arr;$k++)
	{
	    if(($arr[$k]+1)>=$a_possible[$i])
	    {
		$arr[$k]++;
	    }

	    $xstring.=(($arr[$k])%9)+1;
	    $xmod+=$arr[$k]+1;
	       
	}
	$xstring.=(((($x_possible[$i]-$xmod)-1)%9)+1);
	my($ystring)=$a_possible[$i]*$xstring;
	if(test_pandigital($a_possible[$i],$xstring,$ystring))
	{
	    $list{$ystring}=1;
	}
	
    }
  
}

@a_possible=(1,3,4,6,7,9);
@x_possible=(4,6,1,3,7,9);
#Cas 10<a<100
for($i=0;$i<=$#a_possible;$i++)
{
    my($i2);
    for($i2=1;$i2<=9;$i2++)
    {
	my($i3)=((($a_possible[$i]-$i2)-1)%9)+1;
	my($astring)="$i2$i3";
	my($mx)=max($i2,$i3);
	my($mn)=min($i2,$i3);
	if(!($astring%11))
	{
	    next;
	}
	
	my($nb_arr)= 7 * 6;
	for($j=0;$j<$nb_arr;$j++)
	{
	    my(@arr)=Permutations::arrangement(7,2,$j);
	    my($xstring)="";
	    my($xmod)=0;
	    
	    for($k=0;$k<=$#arr;$k++)
	    {
		if(($arr[$k]+1)>=$mn)
		{
		    $arr[$k]++;
		    if(($arr[$k]+1)>=$mx)
		    {
			$arr[$k]++;
		    }
		}

		$xstring.=((($arr[$k])%9)+1);
		$xmod+=$arr[$k]+1;
		
	    }
	    $xstring.=(((($x_possible[$i]-$xmod)-1)%9)+1);
	    my($ystring)=$astring*$xstring;
	    if(test_pandigital($astring,$xstring,$ystring))
	    {
		$list{$ystring}=1;
	    }
	}
    }
    
}
my($ke);
my($sum)=0;
foreach $ke (keys (%list))
{
    $sum+=$ke;
}
print $sum;

sub test_pandigital
{

    my($o1,$o2,$prod)=@_;
    if($prod>=10000)
    {
	return 0;
    }
    my($string)="$o1$o2$prod";
    if($string=~m/0/)
    {
	return 0;
    }
    
    my(@test)=split(//,$string);
    my(%hash)=();
    my($ii);
    for($ii=0;$ii<=$#test;$ii++)
    {
	$hash{$test[$ii]}=1;
    }
    return  (9==keys(%hash));
}
