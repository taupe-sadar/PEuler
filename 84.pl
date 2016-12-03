use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use List::Util qw( sum );

my($nb_cases)=40;
my($size)=$nb_cases* 3;
my($dice_faces)=4;
my($reset_double_in_jail)=1;

my($cardinal)=$dice_faces**2;
my(%singles)=();
my(%doubles)=();
for(my($d)=1;$d<=$dice_faces;$d++)
{
    for(my($d2)=1;$d2<=$dice_faces;$d2++)
    {
	if($d==$d2)
	{
	    Hashtools::increment(\%doubles, $d+$d2);
	}
	else
	{
	    Hashtools::increment(\%singles, $d+$d2);
	}
    }   
}

my(@matrix)=([1]);
my(@vector)=(0);
for(my($a)=0;$a<$size;$a++)
{
    $vector[$a] = 0;
}



for(my($a)=0;$a<$size;$a++)
{
    $matrix[$a] = [];
    for(my($b)=0;$b<$size;$b++)
    {
	$matrix[$a][$b] = 0;
    }
}

#Basic probabilities from dices
my($k);
foreach $k (keys(%singles))
{
    for(my($state)=0;$state<3;$state++)
    {
	for(my($case)=0; $case<$nb_cases; $case++)
	{
	    #With singles, stay in state "no doubles made"
	    my( $dst)= ($case + $k) % $nb_cases;
	    $matrix[ $dst ][$case + $nb_cases*$state] = $singles{$k}/$cardinal;
	}
    }
}
foreach $k (keys(%doubles))
{
    for(my($state)=0;$state<2;$state++)
    {
	for(my($case)=0;$case<$nb_cases;$case++)
	{
	    #With doubles, increase state "doubles made"
	    my( $dst)= ($case + $k) % $nb_cases;
	    $matrix[ $dst + ($state+1)*$nb_cases][$case + $nb_cases*$state] = $doubles{$k}/($cardinal);
	}
    }
    #If third double, go to jail, in state 0
    for(my($case)=0;$case<$nb_cases;$case++)
    {
	$matrix[10][$case + $nb_cases*2] += $doubles{$k}/($cardinal);
    }
}

#Chances case
for(my($from_state)=0;$from_state<3*$nb_cases;$from_state++)
{
    for(my($doubles)=0;$doubles<3;$doubles++)
    {
	my(@to_states)=( 7 + $nb_cases*$doubles, 22 + $nb_cases*$doubles, 36 + $nb_cases*$doubles);
	for(my($cc)=0;$cc<=$#to_states;$cc++)
	{
	    my($to_state)= $to_states[$cc];
	    my($proba) = $matrix[ $to_state ][ $from_state ];
	    if( $proba != 0 )
	    {
		$matrix[ $to_state ][ $from_state ] -= $proba*10/16;
		$matrix[ 0 + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		if($reset_double_in_jail)
		{
		    $matrix[ 10 ][ $from_state ] += $proba/16;
		}
		else
		{
		    $matrix[ 10 + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		}
		$matrix[ 11 + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		$matrix[ 24 + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		$matrix[ 39 + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		$matrix[ 5 + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		my(@next_railways) = ( 15, 25 ,5 ); 
		$matrix[ $next_railways[$cc]       + $nb_cases*$doubles ][ $from_state ] += $proba*2/16;
		my(@next_utility) = ( 12, 22 ,12 ); 
		$matrix[ $next_utility[$cc]        + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		my(@back_three_squares) = (4 , 19 ,33 );
		$matrix[  $back_three_squares[$cc] + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		
	    }
	}
    }
       
}

#Comunity Chest case
for(my($from_state)=0;$from_state<3*$nb_cases;$from_state++)
{
    for(my($doubles)=0;$doubles<3;$doubles++)
    {
	my(@to_states)=( 2 + $nb_cases*$doubles, 17 + $nb_cases*$doubles, 33 + $nb_cases*$doubles);
	for(my($cc)=0;$cc<=$#to_states;$cc++)
	{
	    my($to_state)= $to_states[$cc];
	    my($proba) = $matrix[ $to_state ][ $from_state ];
	    if( $proba != 0 )
	    {
		$matrix[ $to_state ][ $from_state ] -= $proba*2/16;
		$matrix[ 0 + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		if($reset_double_in_jail)
		{
		    $matrix[ 10 ][ $from_state ] += $proba/16;
		}
		else
		{
		    $matrix[ 10 + $nb_cases*$doubles ][ $from_state ] += $proba/16;
		}
	    }
	}
    }
       
}



#Go to jail case
for(my($from_state)=0;$from_state<3*$nb_cases;$from_state++)
{
    for(my($doubles)=0;$doubles<3;$doubles++)
    {
	my($to_state)= 30 + $nb_cases*$doubles;
	if( $matrix[ $to_state ][ $from_state ] != 0 )
	{
	    if($reset_double_in_jail)
	    {
		$matrix[ 10 ][ $from_state ] += $matrix[ $to_state ][ $from_state ];
	    }
	    else
	    {
		$matrix[ 10 + $nb_cases*$doubles ][ $from_state ] += $matrix[ $to_state ][ $from_state ];
	    }
	    $matrix[ $to_state ][ $from_state ] = 0;
	}
    }
       
}


#Check that the sum in the column are equal to 1
for(my($col)=0;$col<3*$nb_cases;$col++)
{
    my($sum)=0;
    for(my($row)=0;$row<3*$nb_cases;$row++)
    {
	$sum += $matrix[$row][$col];
    }
    if( $sum< 0.999 || $sum > 1.001)
    {
	die "Not a valid transition matrix : total probability of column $col is : $sum\n";
    }
    
}
#The matrix to resolve is actually (P-I)=0.
for(my($i)=0;$i<$size;$i++)
{
    $matrix[$i][$i]-= 1;
}

#Replace a line the first line by the equation sum(pi) = 1;
for(my($i)=0;$i<$size;$i++)
{
    $matrix[0][$i] = 1;
}
$vector[0]=1;

my(@sol)=linear_solve( \@matrix,\@vector);
my(@list)=(0..39);
@list= sort( {($sol[$b] + $sol[$b+40] + $sol[$b+80]) <=> ($sol[$a] + $sol[$a+40] + $sol[$a+80])} @list );

# for(my($a)=0;$a<=$#list;$a++)
# {
#     my($best)=$list[$a];
#     print "$list[$a] : ".(int(($sol[$best] + $sol[$best+40] + $sol[$best+80])*100000)/1000)." = ".$sol[$best]." + ".$sol[$best+40]." + ".$sol[$best+80]."\n";
# }

print sprintf('%02s',$list[0]).sprintf('%02s',$list[1]).sprintf('%02s',$list[2]);



sub linear_solve
{
    my($rmatrix,$rvector)=@_;
    my(@mat)=();
    my(@vect)=();
    my(@ret)=();
    
    my($size)=$#$rmatrix+1;
    for(my($i)=0;$i<$size;$i++)
    {
	$#{$$rmatrix[$i]} == $#$rmatrix or die "Non square matrix";
	@{$mat[$i]}=@{$$rmatrix[$i]};
    }
    $#$rvector == $#$rmatrix or die "Matrix and vector are not same size";
    @vect = @{$rvector};
    
    #Decomposition of $mat as triangulary superior
    for( my($col) = 0; $col < $#mat; $col ++ )
    {
	#looking for npn nul element otherwise not inversible
	my($first_non_nul_line)=-1;
	for( my($line)= $col; $line <= $#mat; $line++ )
	{
	    if( $mat[$line][$col] != 0 )
	    {
		$first_non_nul_line= $line;
		last;
	    }
	}
	($first_non_nul_line != -1) or die "Matrix not inversible."; 
        # if not first, swapping coordinates
	if( $first_non_nul_line != $col)
	{
	    my(@tmp)=@{$mat[$col]};
	    @{$mat[$col]} = @{$mat[$first_non_nul_line]};
	    @{$mat[$first_non_nul_line]} = @tmp;
	    #vector too
	    ($vect[$col],$vect[$first_non_nul_line])=($vect[$first_non_nul_line],$vect[$col]);
	    
	}
	
	# foreach non nul element -> linear combination
	# applied on matrix AND vector
	my($diag_coeff)=$mat[$col][$col];
	
	
	for( my($row) = ($col+1); $row < $size; $row ++ )
	{
	    if(  $mat[$row][$col] == 0 )
	    {
		next;
	    }
	    #matrix
	    my($row_first_coeff)=$mat[$row][$col];
	    
	    my($frac)=$row_first_coeff/$diag_coeff;
	    
	    $mat[$row][$col] = 0;
	    for( my($pos_in_row) = ($col+1); $pos_in_row < $size; $pos_in_row ++ )
	    {
		$mat[$row][$pos_in_row] -= $mat[$col][$pos_in_row] * $frac;
	    }
	    

	    #vector
	    $vect[$row] -= $vect[ $col ] * $frac;
	}
    }
    
    
    
    #Final solving
    for( my($row) = $#mat; $row >= 0; $row -- )
    {
	my($d_coeff)= $mat[$row][$row];
	
	
	my($known_sum)=0;
	for(my($col) = $#mat; $col > $row; $col -- )
	{
	    $known_sum = $known_sum + ($mat[$row][$col] * $ret[$col]);
	}
	$ret[$row] = ($vect[$row] - $known_sum)/$d_coeff;
	
    }
    
    return @ret;
}

sub linear_prod
{
    my($rmatrix1,$rmatrix2)=@_;
    my($m)=$#{$rmatrix1}+1;
    my($k)=$#{$rmatrix2}+1;
    
    if( ref($$rmatrix1[0]) ne "ARRAY" )
    {
	$rmatrix1 = [\@{$rmatrix1}];
    }

    if( ref($$rmatrix2[0]) ne "ARRAY" )
    {
	
	my($r) = [];
	for(my($i)=0;$i<$k;$i++)
	{
	    $$r[$i]= [ $$rmatrix2[$i] ];
	    
	}
	$rmatrix2 = $r;
    }

	
    for(my($i)=0;$i<$m;$i++)
    {
	($#{$$rmatrix1[$i]}+1) == $k or die "Not valid dimensions";
	
    }
    my($n)=$#{$$rmatrix2[0]}+1;
    
    for(my($i)=1;$i<$k;$i++)
    {
	($#{$$rmatrix2[$i]}+1) == $n or die "Not valid dimensions";
    }
    my(@mat)=();
    for(my($i)=0;$i<$m;$i++){
	for(my($j)=0;$j<$n;$j++){
	    my($sum)=0;
	    for(my($a)=0;$a<$k;$a++){
		$sum += $$rmatrix1[$i][$a]*$$rmatrix2[$a][$j];
	    }
	    $mat[$i][$j]=$sum;
	}
    }

    if( $m == 1 )
    {
	return \@{$mat[0]};
    }
    elsif( $n==1 )
    {
	my(@tmp)=();
	for(my($i)=0;$i<$m;$i++)
	{
	    push(@tmp,$mat[$i][0]);
	}
	return \@tmp;
    }
    else
    {
	return \@mat;
    }

}

sub print_matrix
{
    my($r)=@_;
    my($size)=$#$r;
    
    for( my($i) = 0; $i <= $size; $i ++ )
    {
	print( "| ");
	for( my($j) = 0; $j <= $size; $j ++ )
	{
	    print "".sprintf('%6s',(int($$r[$i][$j]*10000)/10000))." ";
	}
	print( "|\n")
    }
}

sub print_vector
{
    my($r)=@_;
    my($size)=$#$r;
    
    
    print( "| ");
    for( my($j) = 0; $j <= $size; $j ++ )
    {
	print "$j : ".(int($$r[$j]*1000000)/10000)."\n";
    }
    print( "|\n")
    
}
