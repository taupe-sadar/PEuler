use strict;
use warnings;
use Data::Dumper;
use Permutations;

print count_bouncy_power10( 5 );


my(%cache_bouncy)=();
my(%cache_descending_power10)=();

# Returns the number of bouncy numbers in
# [ 1 ; 10^n ]
sub count_bouncy_power10
{
    my($n)=@_;
    my($constants )= 9*$n ;
    my($ascending ) = Permutations::cnk( $n + 9 , 9 ) - $constants - 1; #Remove the num of constant terms
    my($decending)= count_descending( $n );
    my( $bouncys )= 10**$n -1 - ($ascending + $decending + $constants);
    return $bouncys;
}

sub count_descending
{
    my($n)=@_;
    if( !exists($cache_descending_power10{$n}) )
    {
	if( $n <= 1 )
	{
	    $cache_descending_power10{$n} = 0;
	}
	else
	{
	    $cache_descending_power10{$n} = Permutations::cnk( $n + 9 , 9 ) - 10 + count_descending( $n-1 ); 
	}
    }
    return $cache_descending_power10{$n}
}

# Returns the number of bouncy numbers in
# [ prefix * 10^num_digits ; (prefix+1) * 10^num_digits -1 ]
sub count_bouncy_interval
{
  my($prefix, $num_digits)=@_;
  my($prefix_ascending,$prefix_descending) = ascending_or_descending( $prefix ) ;
  my($last_digit) = ($prefix =~m/^.*(.)$/ );
  my($num_ascending,$num_descending,$num_constant) = (0,0,0);
  
  if( $prefix_ascending )
  {
    $num_ascending = Permutations::cnk( $num_digits + 9 - $last_digit , 9 - $last_digit  );
  }

  if( $prefix_descending )
  {
    $num_descending = Permutations::cnk( $num_digits + $last_digit , $last_digit  );
  }
  
  if( $prefix_ascending && $prefix_descending )
  {
    $num_constant = 1;
  }
  
  my($num_bouncy)= 10**$num_digits - $num_ascending - $num_descending - $num_constant;
  return $num_bouncy;
}

sub ascending_or_descending
{
  my( $n )=@_;
  my(@tab_digits)=split(//,$n);
  my($sorted_increased) = join("",sort({ $a <=> $b } @tab_digits));
  my($sorted_decreased) = join("",sort({ $b <=> $a } @tab_digits));
  return ($n==$sorted_increased,$n==$sorted_decreased);
}
