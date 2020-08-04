use strict;
use warnings;
use Data::Dumper;
use Prime;

my($n_even_div2)=1;
my($n_odd)=1;
my($num_divisors)=1;
my($num_needed)=500;
my(%hash_odd)=Prime::decompose($n_odd);
my($divisors_odd)=Prime::num_divisors_hash(\%hash_odd);
my(%hash_even)=();
my($divisors_even)=1;
my(@old_odd_divisors)=(1);#n in 2n+1
while($num_divisors<=$num_needed)
{
  #my(%hash_prod); <-- dont need to multiply : the prime factors of n and n+1 are separate !!!
  my($num_divisors);
  my($eve)=$n_even_div2;
  my($fact2)=0;
  while(!($eve%2))
  {
    $eve/=2;
    $fact2++;
  }
  $divisors_even=($fact2+1)*$old_odd_divisors[($eve-1)/2];
  
  # %hash_even=Prime::decompose($n_even_div2);
  #%hash_prod=Prime::hash_product(\%hash_even,\%hash_odd);
  # $divisors_even=Prime::num_divisors_hash(\%hash_even);
  $num_divisors=$divisors_even*$divisors_odd;
  if($num_divisors>$num_needed)
  {
    last;
  }
  $n_odd+=2;
  
  %hash_odd=Prime::decompose($n_odd);
  #%hash_prod=Prime::hash_product(\%hash_even,\%hash_odd);
  $divisors_odd=Prime::num_divisors_hash(\%hash_odd);
  $old_odd_divisors[($n_odd-1)/2]=$divisors_odd;
  $num_divisors=$divisors_even*$divisors_odd;
  $n_even_div2++;
}

print $n_odd*$n_even_div2;