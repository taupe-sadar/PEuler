use strict;
use warnings;
use Data::Dumper;
use Permutations;

print count_bouncy( 876, 1 );



sub count_bouncy
{
  my( $n ) = @_;
  my(@digits)=split(//,$n);
  
  #We now that the number of bouncy numbers below 100 is 0
  my($sum_bouncy) = 0;
  for( my($ndigits)=2; $ndigits <= $#digits; $ndigits ++ )
  {
    for( my($first_digit)=1; $first_digit <= 9; $first_digit ++ )
    {
      $sum_bouncy += count_bouncy_interval( $first_digit, $ndigits );
    }
  }

  for( my($ndigits)=$#digits -1 ; $ndigits <= $#digits; $ndigits ++ )
  {
    for( my($first_digit)=1; $first_digit <= 9; $first_digit ++ )
    {
      $sum_bouncy += count_bouncy_interval( $first_digit, $ndigits );
    }
  }

  
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