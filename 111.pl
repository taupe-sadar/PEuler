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
Prime::init_crible(sqrt(10**$digits) + 1);
for( my($d) = 0; $d <= 9 ; $d++ )
{
  my(@primes)=();
  my($num_different_digits)= (($d == 0) ? 2 : 1);
  while( $#primes < 0 )
  {
    @primes = find_all_digits_primes( $digits, $d , $num_different_digits );
    $num_different_digits++;
  } 
  $sum_primes += sum(@primes);
}

print $sum_primes;

sub find_all_digits_primes
{
  my( $n, $d , $num_different_digits ) = @_;
  my(@prime_list)=();
  
  foreach my $last_digit (@authorized_last_digits)
  {
    for( my($first_digit)=1; $first_digit<=9; $first_digit++)
    {
      my($different_digits_already_used)= (( $last_digit == $d )? 0 : 1) + (( $first_digit == $d )? 0 : 1);
      enumarate_numbers_and_test_primes( \@prime_list, $first_digit,$last_digit, $n, $d, $num_different_digits - $different_digits_already_used) ;
    }
  }
  return @prime_list;
}

sub enumarate_numbers_and_test_primes
{
  my($rprime_list,$first_digit,$last_digit, $n, $d, $num_free_digits)=@_;
  foreach  my $p (map ( {"$first_digit".$_."$last_digit";} build_digit_number($n-2,$d, $num_free_digits ) ))
  {
    if( Prime::fast_is_prime( $p ) )
    {
      push(@$rprime_list, $p);
    }
  }
}

sub build_digit_number
{
  my( $n,$d, $num_free_digits) = @_;
  if( $num_free_digits < 0 )
  {
    return ();
  }
  
  my(@list);
  rec_add_digit_number( \@list, "", $n,$d, $num_free_digits );
  return @list;
}

sub rec_add_digit_number
{
  my( $rlist, $current, $n,$d, $num_free_digits )=@_;
  if( $n == 0 )
  {
     push( @$rlist,$current);
  }
  elsif( $num_free_digits == 0 )
  {
    for(my($a)=0;$a<$n;$a++)
    {
       $current.=$d;
    }
    push( @$rlist,$current);
  }
  else
  {
    for(my($digit)=0;$digit<=9;$digit++)
    {
      if( $digit == $d )
      {
        next if($n == $num_free_digits );
        rec_add_digit_number( $rlist, $current.$d , $n-1,$d, $num_free_digits);
      }
      else
      {
        rec_add_digit_number( $rlist, $current.$digit , $n-1,$d, $num_free_digits-1 );
      }
    }
  }
}
