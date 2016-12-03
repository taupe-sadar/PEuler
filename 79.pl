use strict;
use warnings;
use Data::Dumper;

open(FILE,"79_keylog.txt");
my(@numbers)=<FILE>;
close(FILE);
my(%dependencies)=();

for(my($a)=0;$a<=$#numbers;$a++)
{
    chomp($numbers[$a]);
    my($n1,$n2,$n3)=split(//,$numbers[$a]);
    if( !exists($dependencies{$n1}))
    {
	$dependencies{$n1} = [];
	
    }
    if( !exists($dependencies{$n2}))
    {
	$dependencies{$n2} = [];
	
    }
    if( !exists($dependencies{$n3}))
    {
	$dependencies{$n3} = [];
	
    }
    push(@{$dependencies{$n1}},$n2);
    push(@{$dependencies{$n2}},$n3);
}
my(@digits)=sort(keys(%dependencies));
#on enleve les doublons (et on trie);
for(my($a)=0;$a<=$#digits;$a++)
{
    my(@newtab)=();
    my(@tab)=sort(@{$dependencies{$digits[$a]}});
    if($#tab<0)
    {
	next;
    }
    $newtab[0]=$tab[0];
    for(my($i)=1;$i<=$#tab;$i++)
    {
	if($newtab[-1]!=$tab[$i])
	{
	    push(@newtab,$tab[$i]);
	}
    }
    @{$dependencies{$digits[$a]}}=@newtab;
}

#On suppose qu'il n'ya pas de cycle dans ce graphe non oriente et que tout est connecte ...
#print Dumper \%dependencies;

my($string)="";
while($#digits>=0)
{
    my($searching_for_empty_tab)=0;
    
    for(my($number)=0;$number<=$#digits;$number++)
    {
	my($d)=$digits[$number];
	if( ($#{$dependencies{$d}}+1) != 0 )
	{
	    next;
	}
	$searching_for_empty_tab = 1;
	for(my($number2)=0;$number2<=$#digits;$number2++)
	{
	    my($d2)=$digits[$number2];
	    if($number2 == $number) #current number;
	    {
		next;
	    }
	    (($#{$dependencies{$d2}}+1) != 0) or die "There are several solutions with $d and $d2 permuting\n";
	    remove_digit($d,$dependencies{$d2});
	}
	delete( $dependencies{$d} );
	remove_digit($d,\@digits);
	$string= "$d".$string;
	last;
    }

    $searching_for_empty_tab or die "there are cycles in the graph !\n"; 
}

print $string;

sub remove_digit
{
    my($digit,$rtab)=@_;
    my(@newtab)=();
    for(my($i)=0;$i<=$#$rtab;$i++)
    {
	if($$rtab[$i] != $digit)
	{
	    push(@newtab,$$rtab[$i]);
	}
    }
    @{$rtab}=@newtab;
}
