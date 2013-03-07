use strict;
use warnings;
use Data::Dumper;

my(@q)=(9,1,7,37);
my($count)=0;
while($count < 100)
{
    my($a,@q2 )= next_quad(@q);
    my($div)="";
    $q2[2]*=($q2[1]**2);
	$q2[1]=1;

    if(($q2[2]-$q2[0]**2)%$q2[3] == 0 )
    {
	$div = " => OK";
	
    }
    print "$a ".join(" ",@q2)." $div\n";
    @q=@q2;
    $count ++;
}


sub next_quad
{
    my($b,$c,$n,$r)=@_;
    if($r < 0)
    {
	$c = -$c;
	$b = -$b;
	$r = -$r; 
    }
    my($f)=($b+$c*sqrt($n))/$r;
    
    my($aa)=($f<0)?int(- $f )-1:int($f);
    
    my($bb)=$aa*$r-$b;
    my($rr)=$c**2*$n-$bb**2;
    my($d1)=pgcd($r*$bb,$rr);
    my($d2)=pgcd($r*$c,$rr);
    my($d3)=pgcd($d1,$d2);
    print "$d1 $d2 $d3 $c\n";
    if($rr < 0)
    {
	<STDIN>;
	$c = -$c;
	$bb = -$bb;
	$rr = -$rr; 
    }
    return ($aa , $bb*$r/$d3, $c*$r/$d3, $n, $rr/$d3 );
    
    
}

sub pgcd
{
    my($a,$b)=@_;
    if($a*$b==0)
    {
	return 0;
    }
    
    if($a<0)
    {
	$a = -$a;
    }
    if($b<0)
    {
	$b = -$b;
    }
    if($b>$a)
    {
	my($t)=$a;
	$a=$b;
	$b=$t;
    }
    my($r)=$b;
    while($r>0)
    {
	$r = $a%$b;
	$a=$b;
	$b=$r;
    }
    return $a;

}
