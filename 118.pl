use strict;
use warnings;
use Data::Dumper;
use Prime;
use PermutationsIterator;

Prime::init_crible( sqrt(10**9)+100 );
my($max_digit_for_prime)=4;

my( @pandigital_primes )=();
my(@length_start_idx)=(0);
my($current_log)=1;
my($p) = Prime::next_prime();
my($max)=10**$max_digit_for_prime;
while( $p < $max  )
{
  if( is_pandigital( $p ) )
  {
    push( @pandigital_primes, $p);
    if( $p > $current_log )
    {
      push(@length_start_idx,$#pandigital_primes);
      $current_log*=10;
    }
  }
  $p = Prime::next_prime();
}
push(@length_start_idx,$#pandigital_primes+1);
my(%available)=();
for(my($i)=1;$i<=9;$i++)
{
  $available{$i} = 1;
}

my($count_set_pandigital_prime)=0;
for( my($i)=0; $i<= $#pandigital_primes; $i++)
{
  my($prime)= $pandigital_primes[ $i ];
  $count_set_pandigital_prime += nb_subset_pandigital_primes(remove_digits($prime,\%available),$prime%3,$i);
}

print "$count_set_pandigital_prime\n";

sub nb_subset_pandigital_primes
{
  my($ravailable,$current_modulo,$max_idx_in_tab)=@_;
  my($count)=0;
  my(@k)=keys(%$ravailable);
  my($size_left)= $#k + 1 ;
  #no split case
  if( $current_modulo != 0  )
  {
    if( $size_left <= $max_digit_for_prime )
    {
      my($start_idx)=( length($pandigital_primes[ $max_idx_in_tab ]) == $size_left ) ? $max_idx_in_tab : $length_start_idx[$size_left ];
      my($stop_idx)= $length_start_idx[$size_left +1 ];
      for( my($idx) = $start_idx+1; $idx<$stop_idx;$idx++)
      {
        $count++ if( is_available($pandigital_primes[ $idx ],$ravailable));
      }
    }
    else
    {
     
      for(my($digit)=0;$digit< $size_left;$digit++)
      {
        my($d)=shift( @k );
        if( $d%2 != 0 && $d != 5 )
        {
          my(@permutables)=@k;
          my($perm_it) = PermutationsIterator->new( \@permutables );
          
          do
          {
            $count ++ if( Prime::fast_is_prime( join("",@permutables )."$d"  ) );
          }
          while( $perm_it->next() );
        }
        push( @k,$d);
      }
    }
  }
  
  # Split case
  my($stop_prime)= 10**int($size_left/2);
  for( my($idx)= $max_idx_in_tab + 1; $idx<$#pandigital_primes; $idx++)
  {
    my($prime)= $pandigital_primes[ $idx ];
    last if( $prime >= $stop_prime);
    if( is_available($prime,$ravailable))
    {
      $count += nb_subset_pandigital_primes( remove_digits($prime, $ravailable), ($current_modulo + $prime%3)%3,$idx  );
    }
  }
      
  return $count;
}

sub is_available
{
  my($x,$ravailable)=@_;
  my(@t)=split(//,$x);
  for( my($i)=0;$i<=$#t;$i++)
  {
    return 0 if(!exists($$ravailable{$t[$i]}))
  }
  return 1;
}

sub remove_digits
{
  my($x,$ravailable)=@_;
  my(%ret)=%$ravailable;
  my(@digs)=split(//,$x);
  for(my($i)=0;$i<=$#digs;$i++)
  {
    delete $ret{$digs[$i]};
  }
  return \%ret;
}

sub is_pandigital
{
  my($x)=@_;
  return 0 if( $x=~m/0/ );
  my(@t)=sort(split(//,$x));
  for(my($i)=1;$i<=$#t;$i++)
  {
    return 0 if( $t[$i] == $t[$i-1] );
  }
  return 1;
}
