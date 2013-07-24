use strict;
use warnings;
use Data::Dumper;
use Prime;
use Radical;
use POSIX qw/floor ceil/;
 

my($overall_size)=10**5;
my($sorted_element_requiered)=10**4;

#Starting with 1
my($count_radical)=1;

my($nb)=1;
my($element_requiered)=0;
while(1)
{
  $nb++;
  my(%decomposition)=Prime::decompose($nb);
  next if(!Radical::pure_radical(\%decomposition));

  
  my( @primes_dec )=sort( {$a<=>$b} keys( %decomposition ));
  my($count_same_radical) = count_integer_with_same_radical( $overall_size, @primes_dec );
  
  if( $count_radical + $count_same_radical >= $sorted_element_requiered )
  {
    $element_requiered = find_indexed_integer_with_radical( $overall_size , $sorted_element_requiered - $count_radical, @primes_dec );
    last;
  }
  else
  {
    $count_radical+= $count_same_radical;
  }
  
}

print $element_requiered;

sub count_integer_with_same_radical
{
  my($size, @primedec ) =@_;
  my($p,@others)=(@primedec);
  my($reduced_size)= floor($size/Radical::product(@primedec));
  my($rlistcomposites)= Radical::list_composites($reduced_size, @others  );
  my($counting)=0;
  

  for(my($i)=0;$i<=$#$rlistcomposites;$i++)
  {
    my($add)=   log($reduced_size /  $$rlistcomposites[$i]  )/log($p)  ;

    $counting += floor("$add") + 1;
  }
  return $counting ;
}

sub find_indexed_integer_with_radical
{
  my( $size, $index_wanted , @primedec ) =@_;
  my($mincomposite) = Radical::product(@primedec);
  my($reduced_size) = floor($size/$mincomposite);
  
  my($rfullist) = Radical::list_composites($reduced_size, @primedec  );
  my(@sortedlist)= sort( {$a<=>$b} @$rfullist );
  
  return $mincomposite * $sortedlist[ $index_wanted - 1 ];

}



