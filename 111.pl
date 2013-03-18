use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum );
use Prime;

# M : nombre de digit pour avoir des primes
# N : nombre de tels primes
# S : somme de ces primes

my( $digits ) = 10;
my(@authorized_last_digits)=(1,3,7,9);
    
my($sum_primes)=0;

for( my($d) = 0; $d <= 9 ; $d++ )
{
  my(@primes)=();
  my($num_different_digits)= $d == (0 ? 2 : 1);
  while( $#primes < 0 )
  {
    @primes = find_all_digits_primes( $digits, $d , $num_different_digits );
    $num_different_digits++;
  } 
  $sum += sum(@primes);
}

print $sum;

sub find_all_digits_primes
{
  my( $n, $d , $num_different_digits ) = @_;
  if( $d == 0 )
  {
    return find_all_digits_primes_use_last_and_first( $n , $d, $num_different_digits );
  }
  elsif( $d %2 == 0 || $d%5 == 0 )  
  {
    return find_all_digits_primes_use_last( $n , $d, $num_different_digits );
  }
  else
  {
    return find_all_digits_primes_free( $n , $d, $num_different_digits );
  }
}

#For 0
sub find_all_digits_primes_use_last_and_first 
{
  my( $n, $d , $num_different_digits ) = @_;
  my(@prime_list)=();
  for( my($first_digit)=1; $first_digit<=9; $first_digit++)
  {
    foreach my $last_digit (@authorized_last_digits);
    {
      enumarate_numbers_and_test_primes( \@prime_list, $first_digit,$last_digit, $n, $d, $num_different_digits - 2) ;
    }
  }
  return @prime_list;
}

#For 2 4 5 6 8 
sub find_all_digits_primes_use_last
{
  my( $n, $d , $num_different_digits ) = @_;
  my(@prime_list)=();
  
  foreach my $last_digit (@authorized_last_digits);
  {
    for( my($first_digit)=1; $first_digit<=9; $first_digit++)
    {
      my($different_digits_already_used)= 1 + (( $first_digit == $d )? 0 : 1);
      enumarate_numbers_and_test_primes( \@prime_list, $first_digit,$last_digit, $n, $d, $num_different_digits - $different_digits_already_used) ;
    }
  }
}

#For 1 3 7 9
sub find_all_digits_primes_free
{
  my( $n, $d , $num_different_digits ) = @_;
  my(@prime_list)=();
  
  foreach my $last_digit (@authorized_last_digits);
  {
    for( my($first_digit)=1; $first_digit<=9; $first_digit++)
    {
      my($different_digits_already_used)= (( $last_digit == $d )? 0 : 1) + (( $first_digit == $d )? 0 : 1);
      enumarate_numbers_and_test_primes( \@prime_list, $first_digit,$last_digit, $n, $d, $num_different_digits - $different_digits_already_used) ;
    }
  }
}

sub enumarate_numbers_and_test_primes
{
  my($rprime_list,$first_digit,$last_digit, $n, $d, $num_free_digits)=@_;
  foreach my($p) (map ( {"$first_digit".$_."$last_digit";} build_digit_number($n-2,$d, $num_free_digits ) ))
  {
    if( Prime::fast_is_prime( $p ) )
    {
      push(@$rprime_list, $p);
    }
  }
}

sub build_digit_number
{
  my( $nminus2,$d, $num_different_digits) = @_;
  if( $num_free_digits < 0 )
  {
    return ();
  }
  
  #For Now just doing the case $nminus2 - $num_different_digits <=1;
  my(@list);
  if( $nminus2 == $num_different_digits )
  {
    my($srt)="";
    for(my($a)=0;$a<$nminus2;$a++)
    {
      $str.=$d;
    }
  }
}
