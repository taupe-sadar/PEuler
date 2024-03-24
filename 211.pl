#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;

# With n decomposed in prime factor as n = prod( p_i^k_i )
# The power divisors sigma_k function may be written :
# sigma_k(n) = prod(sigma_k(p_i^k_i))
# and 
# sigma_k(p_i^k_i) = p_i^k * sigma_k(p_i^(k_i)-1) + 1 = p_i^(k_i * k ) + .. + pi^k + 1
#
# This algorithm loops over all j in [1;n], startin with powers of 2, then numbers having power of 2 and 3 
# as factors, and so on using all prime numbers in ascending order
# We build a list containg all numbers j, and and an array containing all sigma_2(j), which will be be recursively
# as in sigma_2(p_i^k_i * j) = sigma_2(p_i^k_i) * sigma_2(j) if p_i is greater than primes used for j.
#
# As optimisation, the list of numbers must be sorted and be kept as short as possible.
#
# For a single prime p, sigma_2(p) = p^2 + 1 cannot be a square
# Next, for odd primes, p=2*p'+1, p^2 + 1 = 4*p'^2 + 4*p + 2 is even but not divisible by 4.
# We also have sigma_2(2) = 5. So sigma( 2 *p ) cannot be a square.
# So we can stop the loop over primes until n/3.

my($n)=64000000;

Prime::init_crible($n+1000);
my(@list)=(1);
my($p)=Prime::next_prime();
my(@sigma2_store)=(1)x($n+1);
my($sum_squares)=1;#1 is already present in list

my($sqrt_n)=floor(sqrt($n));

while($p <= $n/3)
{
  my(@pows)=();
  my($pow)=$p;
  while($pow<=$n)
  {
    push(@pows,$pow);
    $pow*=$p;
  }
  
  @list = sort({$a<=>$b} @list) if($p<=$sqrt_n);
  
  my($nextp)=Prime::next_prime();
  my($max_elem)=floor($n/$nextp);

  my($end_list)=$#list;
  my($splice_idx)=-1;
  my($sigma2p)=1;
  my($p2)=$p*$p;
  foreach my $ppow (@pows)
  {
    $sigma2p = ($sigma2p*$p2) + 1;
    for(my($i)=0;$i<=$end_list;$i++)
    {
      if( $splice_idx == -1 && $ppow == $p && $list[$i] > $max_elem)
      {
        $splice_idx = $i;
      }
      my($elem)=$ppow*$list[$i];
      last if($elem > $n);
      my($sig2)=$sigma2p * $sigma2_store[$list[$i]];
      
      my($int_root)=floor(sqrt($sig2));
      if($int_root*$int_root == $sig2)
      {
        # print "$elem -> square ($ppow*$list[$i])\n";
        $sum_squares+=$elem ;
      }
      
      if($elem <= $max_elem)
      {
        $sigma2_store[$elem]=$sig2;
        push(@list,$elem);
      }
    }
  }
  
  splice(@list,$splice_idx,$end_list-$splice_idx+1) if($splice_idx!=-1);
  $p=$nextp;
}
print $sum_squares;
