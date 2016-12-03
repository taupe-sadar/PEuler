use strict;
use warnings;
use Data::Dumper;
use Math::BigInt;
use ContinueFraction;
use List::Util qw( sum );

my($accuracy)=100;
my($total_sum)=0;
for(my($i)=2;$i<100;$i++)
{
    if(!(sqrt($i)=~m/\./))
    {
	next;
    }
    my($squ)= square_extract_fraction( $i , $accuracy );
    my(@t) = split(// , $squ);
    $total_sum += sum( @t[0..($accuracy-1)] );
}

print "$total_sum";



sub square_extract_fraction
{
    my($n,$precision)=@_;
    my(@l) = ContinueFraction::integers_list($n);
    
    my($prec_courante)=0;
    my($p1,$p0)=(Math::BigInt->new(1),Math::BigInt->new(0));
    my($q1,$q0)=(Math::BigInt->new(0),Math::BigInt->new(1));
    ($p1,$p0) = ($l[0]*$p1 + $p0 , $p1);
    ($q1,$q0) = ($l[0]*$q1 + $q0 , $q1);

    $l[0]*=2;
    my($lindex)=1;
    while( $prec_courante <= $precision )
    {
	if($lindex > $#l)
	{
	    $lindex = 0;
	}
	($p1,$p0) = ($l[$lindex]*$p1 + $p0 , $p1);
	($q1,$q0) = ($l[$lindex]*$q1 + $q0 , $q1);
	$prec_courante = length($q1) + length($q0) - 2;
	$lindex++;
	
	
    }
    my($big_number)= ($p1*(Math::BigInt->new(10))**($prec_courante))/$q1;
    my($frac_digits)=($big_number=~m/^.{$precision}(.*)/);
    while( !defined($frac_digits) || $frac_digits =~m/^9+$/ || $frac_digits =~m/^0+$/ )
    {
	if($lindex > $#l)
	{
	    $lindex = 0;
	}
	($p1,$p0) = ($l[$lindex]*$p1 + $p0 , $p1);
	($q1,$q0) = ($l[$lindex]*$q1 + $q0 , $q1);
	$prec_courante = length($q1) + length($q0) - 2;
	($big_number)= ($p1*(Math::BigInt->new(10))**($prec_courante))/$q1;
	($frac_digits)=($big_number=~m/^.{$precision}(.*)/);
	$lindex++;
	
    }
    
    return $big_number;
    
}

# Dichotomie bete : not used : too expensive
sub square_extract
{
    my($n,$precision)=@_;
    my($int_squ)=2;
    while($int_squ**2 < $n )
    {
	$int_squ++;
    }
    if($int_squ**2 == $n)
    {
	return $int_squ;
    }

    my($exp)=(Math::BigInt->new(10))**$precision;
    
    my($min)=$exp*($int_squ-1);
    my($max)=$exp*($int_squ);
    my($valmin)=($min**2)/$exp;
    my($valmax)=($max**2)/$exp;
    my($valn)=$n*$exp;
    while(($max-$min) >1 )
    {
	my($barycentre)= barycentre( $min,$valmin,$max,$valmax,$valn);
	my($newval)=$barycentre**2 / $exp;
	if($newval > $valn )
	{
	    $max = $barycentre;
	    $valmax= $newval;
	}
	else
	{
	    $min = $barycentre;
	    $valmin= $newval;
	}
    }
    return $min;
	
}


sub barycentre
{
    my($min,$valmin,$max,$valmax,$valtarget)=@_;
    
    my($target)=(($min + (($max-$min)*($valtarget - $valmin))/($valmax-$valmin))*799+ ($max+$min)/2)/800;
    my($a,$b,$c)=(($max-$min)*($valtarget - $valmin),(($max-$min)*($valtarget - $valmin))/($valmax-$valmin),$target); 
    if($target <= $min)
    {

	return $min +1;
    }
    elsif( $target >= $max )
    {
	return $max -1;
    }
    else
    {
	return $target
    }
    
}
