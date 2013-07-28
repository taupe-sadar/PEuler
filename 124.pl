use strict;
use warnings;
use Data::Dumper;
use Prime;
use Radical;
use POSIX qw/floor ceil/;


my($overall_size)=10**5;
my($sorted_element_requiered)=10**4;

Radical::init_set( $overall_size );

#Starting with 1
my($count_radical)=1;
my($element_requiered)=0;


while(1)
{
  
  my($radical,$rdecomposition) = Radical::next_radical() ;
  
  my($count_same_radical) = Radical::quantity_radical();
  
  if( $count_radical + $count_same_radical >= $sorted_element_requiered )
  {
    $element_requiered = find_indexed_integer_with_radical( $overall_size , $sorted_element_requiered - $count_radical, @$rdecomposition );
    last;
  }
  else
  {
    $count_radical+= $count_same_radical;
  }
  
}

print $element_requiered;


sub find_indexed_integer_with_radical
{
  my( $size, $index_wanted , @primedec ) =@_;
  my($mincomposite) = Radical::product(@primedec);
  my($reduced_size) = floor($size/$mincomposite);
  
  my($rfullist) = Radical::list_composites($reduced_size, @primedec  );
  my(@sortedlist)= sort( {$a<=>$b} @$rfullist );
  
  return $mincomposite * $sortedlist[ $index_wanted - 1 ];

}



