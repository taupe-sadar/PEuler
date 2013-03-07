use strict;
use warnings;
use Data::Dumper;
use ContinueFraction;
my($max)=1000;

my(@square_tab)=();
my(@tab)=();
for(my($i)=0;$i<=$max;$i++)
{
    $tab[$i]=0; #0 : ne contient pas de carre #1 : en contient #2 : est un carre parfait
}
for(my($i)=0;$i<=sqrt($max);$i++)
{
    $tab[$i**2]=2;
}


#Liste de tous les nombres ne contenant pas de carre.
my($nb)=2;
my($square)=4;

while($square<=$max)
{
    my($square_mult)=$square;
    while($square_mult<=$max)
    {
	$square_tab[$square_mult]=1;
	$square_mult+=$square;
    }
    $nb++;
    $square=$nb*$nb;
}

my($maximum_x)=0;
my($d_for_this_minimum)=0;

for(my($d)=2;$d<=$max;$d++)
{
    if($tab[$d]!=0)
    {
	next;#1 solution deja trouvée #2 : pas de solution  
    }
    
    my($rank,$x,$y)=ContinueFraction::solve_diophantine_equation($d,1);
    if($x > $maximum_x )
    {
	$maximum_x = $x;
	$d_for_this_minimum = $d;
    }
}
print $d_for_this_minimum;
