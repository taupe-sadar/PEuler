package IntegerPartition;
use strict;
use warnings;
use Prime;
use Data::Dumper;

# On cherche la suite p(n), le nombre des differentes partition de 
# l'entier n, SANS distinction des termes
# On utilise ici le theoreme du nombre pentagonal
# Prod( 1 - x^k ) = 1 - x - x^2 + x^5 + x^7 - x^12 - x^15 + ...
# Or 1/Prod( 1 - x^k ) = somme( p(k) * x^k )
# Par involution, on en deduit :
# p(n)=p(n-1) + p(n-2 ) - p(n-5) - p(n-7) + ... avec p(0)=1;

my(@partitions)=(1);
my($next_k_for_pentagonal)=2;
my(@pentagonal_pool)=(1);

sub partition
{
  my($n,$modulo)=@_;
  while($pentagonal_pool[-1]<$n)
  {
    my($next_pentagonal)=$pentagonal_pool[-1] + 3*$next_k_for_pentagonal - 2;
    push(@pentagonal_pool,$next_pentagonal);
    
    $next_k_for_pentagonal++;
  }
  
  while($n>$#partitions)
  {
    push(@partitions, calculate_next_partition($modulo));
  }
  return $partitions[$n];
}

#Un peu optimise : mais il s'agit bien de somme( (-1)^k * p(n - (3k-1)k/2 )) avec k positif ET k negatif
sub calculate_next_partition
{
  my($mod)=@_;
  
  my($n)= $#partitions +1;
  my($val)=0;
  
  for(my($k)=0;$k<=$#pentagonal_pool;$k++)
  {
    my($pentagonal)= $pentagonal_pool[$k];
    if( $pentagonal > $n)
    {
	    last;
    }
    my($pentagonal2)= $pentagonal + $k + 1;
    
    my($negative_test)= $k%2 ;
    
    if( $negative_test )
    {
	    $val-= $partitions[$n - $pentagonal ];
	    if( $pentagonal2<= $n )
	    {
        $val-= $partitions[$n - $pentagonal2 ];
	    }
    }
    else
    {
	    $val+= $partitions[$n - $pentagonal ];
	    if( $pentagonal2<= $n )
	    {
        $val+= $partitions[$n - $pentagonal2 ];
	    }
    }
  }
  if( defined($mod))
  {
    return $val%$mod;
  }
  return $val;
}

#Ce tableau  represente partitions_with_primes[$n]{$p} :
# "nb de partions de nombres premiers dont la somme fait $n 
# et le plus haut terme est $p
# Ex : 7 + 3 ; 2 + 3 + 5; ...
my(@partitions_with_primes)=({},{},{2 => 1}); 
my(@sums_partition_primes)=(0,0,1);
my(@prime_table)=();
sub prime_partition
{
  my($n)=@_;
  if($#prime_table<0)
  {
    Prime::init_crible(20000);
    push(@prime_table,Prime::next_prime()); #pushing 2
    push(@prime_table,Prime::next_prime()); #pushing 3
  }
  
  while($n>$#sums_partition_primes)
  {
    push(@sums_partition_primes, calculate_prime_partition());
  }
  return $sums_partition_primes[$n];
}


sub calculate_prime_partition
{
  my($n)= $#sums_partition_primes +1;
  my($sum)=0;
  #Case for $p = 2 ($k =0)
  if( $n%2 == 0)
  {
    $partitions_with_primes[$n]{2}=1;
    $sum++;
  }
  else
  {
    $partitions_with_primes[$n]{2}=0;
  }
  my($pm1)=2;
  for(my($k)=1;$k < $#prime_table; $k++)
  {
    my($p)= $prime_table[$k];
    $partitions_with_primes[$n]{ $p }= $partitions_with_primes[$n - $p + $pm1]{ $pm1 };
    my( $left ) = $n - $p;
    if( exists($partitions_with_primes[$left]{ $p })  )
    {
	    $partitions_with_primes[$n]{ $p } += $partitions_with_primes[$left]{ $p };
    }
    $sum+=$partitions_with_primes[$n]{ $p };
    $pm1 = $p;
  }
  #On traite le cas n = $prime_table[-1]
  if( $n == $prime_table[-1] )
  {
    $partitions_with_primes[$n]{ $n } = 1;
    $sum++;
    push(@prime_table,Prime::next_prime()); #Future next prime;
  }
  return $sum;
	
}


1;
