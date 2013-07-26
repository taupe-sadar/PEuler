package Radical;
use strict;
use warnings;

# dynamically sorts integers by their radical

my($set_size);

my(@radicals);
my(@decomposition_of_radicals);

my(@quantity_numbers_for_radical);

my(@iterators)=(1);

my( $radical_number)=1;

sub init_set
{
  my($size)=@_;
  @radicals=(1);
  @quantity_numbers_for_radical=(1);
  @decomposition_of_radicals=([]);
  $set_size = $size;
}


sub next_radical
{
  my($iterator)=@_;
  
  $iterator = 0 if(!defined($iterator));
  $iterators[$iterator]=1 if(($#iterators<$iterator) ||(!defined($iterators[$iterator])));
  
  while($iterators[$iterator]>$#radicals)
  {
    find_next_radical();
  }

  my($rad,$decrad)=($radicals[$iterators[$iterator]],$decomposition_of_radicals [$iterators[$iterator]]);
  $iterators[$iterator]++;
  return ($rad,$decrad);
}

sub find_next_radical
{
  my(%decomposition);
  while( 1 )
  {
    $radical_number++;
    %decomposition=Prime::decompose($radical_number);
    last if( Radical::pure_radical(\%decomposition) );
  }
  push( @radicals, $radical_number ) ;
  my(@primes_sorted)=sort( {$a<=>$b} keys( %decomposition ));
  push( @decomposition_of_radicals, \@primes_sorted ) ;
}
 


sub list_composites
{
  my($max, @primes)=@_;
  
  return [1] if $#primes < 0;
  
  my(@composites)=(1);
  
  my($pow,@otherscomposites)=(@primes);
  while( $pow <= $max )
  {
    push(@composites,$pow);
    $pow*=$primes[0];
  }
    
  if( $#primes > 0 )
  {
    my($size_single_composite)=$#composites;
    my($rothers_composites)= list_composites( $max, @otherscomposites );
    #Starting with the first element not equal to one 
    for(my($i)=1;$i<=$#$rothers_composites;$i++)
    {
      for(my($j)=0;$j<=$size_single_composite;$j++)
      {
        my($composite)= $$rothers_composites[$i]*$composites[$j];
        last if($composite > $max );
        push(@composites,$composite);
      }
    }
  }
  return \@composites;
}


sub pure_radical
{
  my( $rhash )=@_;
  my($a);
  foreach  $a (values(%$rhash))
  {
    return 0 if $a!=1;
  }
  return 1;
}

sub product
{
  my(@factors)=@_;
  my($prod)=1;
  for(my($i)=0;$i<=$#factors;$i++)
  {
    $prod*=$factors[$i];
  }
  return $prod;
}
1;
