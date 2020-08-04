use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum max min );
use POSIX qw/floor ceil/;

my($max)= 12000;

my(@best_product)=(0,0);

my($limit_m1)= floor(1+ sqrt($max - 1 ));
for( my($m1)=2;$m1<=$limit_m1;$m1++ )
{
  my($limit_m2)= floor(($max-2+$m1)/($m1-1));
  for( my($m2)=$m1;$m2<=$limit_m2;$m2++ )
  {
    seek_sets_starting_with( $m2, 2 , $m1*$m2 , $m1+$m2 , $max);
  }
}

my(%prod_possible)=();

for( my($i)=2;$i<=$max;$i++ )
{
  $prod_possible{ $best_product[ $i ] } = 1;
}

print sum( keys( %prod_possible));





sub seek_sets_starting_with
{
  my( $min, $cardinal , $prod , $sum , $highest_card )=@_;
  my($s)="";
  for(my($i)=0;$i<$cardinal;$i++){$s.='-';}
  #Test with cardinal = $cardinal
  is_best_subset( $cardinal, $prod , $sum );
  
  #Test with higher cardinals 
  my($limit_mi)= floor( ($highest_card - $cardinal - 1 + $sum )/ ($prod -1) );
  for(my($mi)=$min; $mi <= $limit_mi; $mi++ )
  {
    seek_sets_starting_with( $mi, $cardinal + 1, $prod*$mi, $sum + $mi, $highest_card );
  }
}

sub is_best_subset
{
  my($card,$prod,$sum)=@_;
  my($k)= $prod - $sum +$card;
  if(!defined($best_product[$k]))
  {
    $best_product[$k] = $prod;
  }
  else
  {
    $best_product[$k] = min( $prod ,$best_product[$k]) ;
  }
}
