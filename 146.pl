use strict;
use warnings;
use Data::Dumper;
use Bezout;
use Prime;

my(%stat_ok)=();
my(%stat_no)=();

my($max)= 3*10**6;

Prime::init_crible($max*2);

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

my(@set_of_congruence) = build_set(%possible_congruences);


my(@mods)=sort({$a<=>$b}keys(%possible_congruences));

my( @list_of_shift ) = ();

for( my($i)=0; $i<= $#set_of_congruence; $i++ )
{
  my(%sol)=();
  for( my($j)=0; $j<= $#mods; $j++ )
  {
    $sol{$mods[$j]} = $set_of_congruence[$i][$j];
  }
  
  push( @list_of_shift, Bezout::congruence_solve(%sol));
}

print "List : ".($#list_of_shift+1)."\n";

my($product)=1;
for( my($j)=0; $j<= $#mods; $j++ )
{
  $product*=$mods[$j];
}

@list_of_shift=sort({$a<=>$b}(@list_of_shift));

print "Prod : $product\n";

my($bound) = 0;
my($sum)=0;
while( $bound < $max )
{
  for( my($i)=0; $i<= $#list_of_shift; $i++ )
  {
    my($n) = $bound + $list_of_shift[$i];
    last if( $n >= $max );
    if( test_primality($n) )
    {
      $sum+=$n;
      print "Found $n\n";
    }
  }
  $bound += $product;
  print "------- $bound\n";
}

print $sum;

sub test_primality
{
  my($n)=@_;
  my($n2)=$n*$n;
  my($test1)=1;
  for( my($i)=0;$i<= $#offsets; $i++ )
  {
    return 0 if( !Prime::fast_is_prime($n2+$offsets[$i]) );
  }
  return  !Prime::fast_is_prime($n2+21); 
}

sub build_set
{
  my(%possibles)=@_;
  
  my(@primes)=sort({$a<=>$b}keys(%possibles));
  
  my(@tab)=([]);
  
  for(my($i)=0;$i<=$#primes;$i++)
  {
    my(@ps)=@{$possibles{$primes[$i]}};
    my(@t)=();
    for(my($j)=0;$j<=$#ps;$j++)
    {
      for(my($e)=0;$e<=$#tab;$e++)
      {
        push( @t, [@{$tab[$e]},$ps[$j]] );
      }
    }
    @tab=@t;
  }
  return @tab;
}

