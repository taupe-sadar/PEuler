use strict;
use warnings;
use Data::Dumper;
use Bezout;
use Prime;
use integer;
use Chinois;
use Set;


my($max)= 150*10**6;

Prime::init_crible(2*$max);
my(@offsets) = (1,3,7,9,13,27);

my(%possible_congruences) =  (
  2 => [ 0 ],
  3 => [ 1, 2 ],
  5 => [ 0 ],
  7 => [ 3, 4 ],
  11 => [ 0, 1, 4, 5, 6, 7, 10 ],
  13 => [ 1, 3, 4, 9, 10, 12 ],
  17 => [ 0, 1, 3, 6, 7, 8, 9, 10, 11, 14, 16 ],
  19 => [ 0, 1, 2,3,6,7,8,9,10,11,12,13,16, 17, 18 ]
);

my(@mods)=sort({$a<=>$b}keys(%possible_congruences));

my(@sets)=();
for my $m (@mods)
{
  push(@sets,$possible_congruences{$m});
}

my($rset_of_congruence) = Set::cartesian_product(\@sets);
my( $rlist_of_shift ) = Bezout::multiple_congruence_solve(\@mods,$rset_of_congruence);

my($product)=1;
for( my($j)=0; $j<= $#mods; $j++ )
{
  $product*=$mods[$j];
}

@$rlist_of_shift=sort({$a<=>$b}(@$rlist_of_shift));

my($bound) = 0;
my($sum)=0;
while( $bound < $max )
{
  for( my($i)=0; $i<= $#$rlist_of_shift; $i++ )
  {
    my($n) = $bound + $$rlist_of_shift[$i];
    last if( $n >= $max );
    if( test_primality($n) )
    {
      $sum+=$n;
    }
  }
  $bound += $product;
}

print $sum;

sub test_primality
{
  my($n)=@_;
  my($n2)=$n*$n;
  my($test1)=1;
  
  for( my($i)=0;$i<= $#offsets; $i++ )
  {
    return 0 if( !Chinois::chinoisPrime($n2+$offsets[$i]) );
  }
  
  if( Chinois::chinoisPrime($n2+21) )
  {
    return 0 if(Prime::fast_is_prime($n2+21));
  }
  
  #Comment here for high speed !
  
  for( my($i)=0;$i<= $#offsets; $i++ )
  {
    if( !Prime::fast_is_prime($n2+$offsets[$i]) )
    {
      return 0;
    }
  }
  return 1;
}
