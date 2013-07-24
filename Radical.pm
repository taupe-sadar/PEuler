package Radical;
use strict;
use warnings;

# dynamically sorts integers by their radical

my($set_size);
my(@radicals);
my(@nb_radical);

my(@iterators)=(1);

my( $radical_number)=1;

sub init_set
{
  my($size)=@_;
  @radicals=(1);
  @nb_radical=(1);
  $set_size = $size;
}


sub next_radical
{
  my($iterator)=@_;
  
  $iterator = 0 if(!defined($iterator));
  $iterators[$iterator]=0 if(($#iterators<$iterator) ||(!defined($iterators[$iterator])));
  
  while($iterators[$iterator]>$#radicals)
  {
    find_next_radical();
  }

  my($ret)=$radicals[$iterators[$iterator]];
  $iterators[$iterator]++;
  return $ret;
}

sub find_next_radical
{
  while( 1 )
  {
    $radical_number++;
    my(%decomposition)=Prime::decompose($radical_number);
    last if( Radical::pure_radical(\%decomposition) );
  }
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
