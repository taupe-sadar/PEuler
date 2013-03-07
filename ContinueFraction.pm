package ContinueFraction;
use strict;
use warnings;
use Math::BigInt;
use Data::Dumper;

#state for reduites calculation
my($non_square_number);

my(@pn)=(1,0);
my(@qn)=(0,1);
my(@period)=();

my($frac_idx)=0;
my($init)=0;
my($state_saved)=0;



sub period_frac_cont
{
    my($n)=@_;
    my(@list)=integers_list($n);
    return ($#list +1);
}

# Give all coefficients of the period of the Continued Fraction of
# a non square integer. Main representation : ( a0, a1, a2, ... an)
# Beware ! for the all construction list , the following periods
# start with 2 a0 : ( a0 a1 .. an 2a0 a1 .. an 2a0 .. ) 
sub integers_list
{
    my($n)=@_;
    my($integer)=int(sqrt($n));
    my($b,$c)=next_quotient_complet($integer,1,$integer,$n);
    my(@list)=($integer);
    while(($b!=$integer*2)&&($c!=1))
    {
	my($a);
        ($b,$c,$a)=next_quotient_complet($b,$c,$integer,$n);
	push(@list,$a);
    }
    return @list;
}

sub next_quotient_complet
{
    my($b,$c,$ent_n,$n)=@_;
    my($a)=int(($ent_n+$b)/$c);
    my($b2)=$a*$c-$b;
    my($c2)=($n-$b2**2)/$c;
    return ($b2,$c2,$a);
}

sub fraction_cont
{
    my($a,@arg)=@_;
    return ($a*$arg[0]+$arg[1],$arg[0]);
}

sub get_reduites
{
    my(@integer_list)=@_;
    my(@pn)=(Math::BigInt->new(1),Math::BigInt->new(0));
    my(@qn)=(Math::BigInt->new(0),Math::BigInt->new(1));
    
    for(my($n)=0;$n<=$#integer_list;$n++)
    {
	@pn = fraction_cont( $integer_list[$n] ,@pn);
	@qn = fraction_cont( $integer_list[$n] ,@qn);
    }

    return ($pn[0],$qn[0]);
}

#Solve equation x^2 - y^2 = +/-1
sub solve_diophantine_equation
{
    my( $sqrt_number, $sign, $limit_for_p)=@_;
    
    #Case no limit_for_p specified : first non trivial solution is selected
    if( !defined($limit_for_p) )
    {
	$limit_for_p = 0;
	if( $state_saved == 1)
	{
	    $limit_for_p = $pn[0];
	}
    }
    
    my($parity);
    if($sign == 1)
    {
	$parity = 0;
    }
    elsif( $sign == -1 )
    {
	$parity = 1;
    }
    else
    {
	die "Cannot solve diophantine with sign != +/-1"; 
    }
    my($criteria) = sub { 
	if( $frac_idx%($#period+1) == 0 && $frac_idx%2 == $parity && $pn[0] > $limit_for_p )
	{
	    return 1;
	}
	return 0;
    };
    return get_reduites_from_criteria( $sqrt_number,$criteria, [] );
}

sub save_state
{
    if( $init == 1 )
    {
	$state_saved = 1;
    }
}

sub get_reduites_from_criteria
{
    my( $number, $rstop_condition, $rargs)=@_;
    
    my($an);
    if($state_saved == 0)
    {
	( sqrt($number) =~m/\./) or die "$number is a perfect square";
	$non_square_number = $number;
	@pn=(Math::BigInt->new(1),Math::BigInt->new(0));
	@qn=(Math::BigInt->new(0),Math::BigInt->new(1));
	@period= integers_list( $number );
	$an= $period[0];
	(@pn)=fraction_cont( $an , @pn) ;
	(@qn)=fraction_cont( $an , @qn) ;
	
	$frac_idx  = 1; 
	$period[0]*=2;
	$init = 1;
    }
    else
    {
	$number == $non_square_number or die "Error saved nb : $non_square_number. Called with $number";
	$state_saved = 0;	
    }
    
    my(@ret);
    while( ! &$rstop_condition( @$rargs))
    {
	$an=$period[ $frac_idx% ($#period + 1) ];
	(@pn)=fraction_cont( $an , @pn) ;
	(@qn)=fraction_cont( $an , @qn) ;
	#print " $an $pn[0] $qn[0]\n";<STDIN>; 
	$frac_idx++;	
	
	
    }
    return ($frac_idx,$pn[0],$qn[0]);
}

1;
