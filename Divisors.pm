package Divisors;
use strict;
use warnings;
use Prime;
use List::Util qw( max min );

my(@list_divisors)=();

sub calc_all_until
{
  my($limit)=@_;
  
  @list_divisors = (1,1);
  
  $list_divisors[$limit ]= undef; 
  my(%power_primes_and_divisor_sum)=();
  
  Prime::init_crible($limit);
  my($p);
  my($sqrt_max)=sqrt($limit);
  
  my(@primes)= ();
  
  while( ($p=Prime::next_prime()) <= sqrt($limit) )
  {
    push( @primes , $p);
    $power_primes_and_divisor_sum{ $p } = [ 1 ];
    my($last_prime_power)= int( log($limit)/log( $p ) );
    
    my($divisor_sum)=1;
    my($pow) = 1;
    for( my($i)=1; $i <= $last_prime_power; $i ++ )
    {
	    $pow*=$p;
	    $divisor_sum = $divisor_sum + $pow;
	    $power_primes_and_divisor_sum{ $p }[ $i ] = $divisor_sum;
	    $list_divisors[ $pow ] = $divisor_sum;
    }
  }
  
  do
  {
    push( @primes , $p);
    $power_primes_and_divisor_sum{ $p } = [ 1 , $p];
    $list_divisors[ $p ] = 1 + $p;
  }while( ($p=Prime::next_prime()) <= ($limit/2) );
  
  my(@already_calculated)=();
  while( defined($p = shift( @primes)))
  {
    my(@new_already_calculated);
    my($ref)=$power_primes_and_divisor_sum{ $p };
    
    my($pr)=1;
    for( my($poweredprime ) = 1; $poweredprime <= $#$ref; $poweredprime ++ )
    {
      $pr*=$p;
      push( @new_already_calculated, $pr );
      
    }
    
    
    for( my($a)= 0; $a<= $#already_calculated; $a++ )
    {
      my($new_nb) = $already_calculated[$a]*$p;
      if( $new_nb > $limit )
      {
        next; # Do not put again in array 'already calculated'
      }
      
      push( @new_already_calculated, $already_calculated[$a] );
      
	    for( my($powprime)= $p; $new_nb <= $limit ;$new_nb*=$p,$powprime *=$p )
	    {
        push( @new_already_calculated, $new_nb );
        $list_divisors[ $new_nb ] = $list_divisors[ $powprime ]* $list_divisors[ $already_calculated[$a]];
	    }
    }
    
    @already_calculated=@new_already_calculated;
       
  }
  
  for( my($i)= int($limit/2); $i<= $limit; $i++ )
  {
    if( !defined( $list_divisors[ $i ] ) )
    {
      $list_divisors[ $i ] = $i +1;
    }
  }
}

#alternative heuristic (simpler)
sub calc_until_not_so_bad
{
  my($limit)=@_;
  for(my($i)=0; $i<= $limit; $i ++ )
  {
    $list_divisors[$i]=1;
  }
  
  for(my($i)=2; $i<= $limit; $i ++ )
  {
    for(my($multiple)=$i; $multiple<= $limit; $multiple += $i )
    {
	    $list_divisors[$multiple]+= $i;
    }
  }
  
}

sub get_sum_prop_div
{
	my($number)=@_;
	return get_sum_div($number)-$number;
}

sub get_sum_div
{
  my( $number )=@_;
  if( $#list_divisors < $number )
  {
    die "Number $number as not been calculated !";
  }
  return $list_divisors[$number];
}
1;
