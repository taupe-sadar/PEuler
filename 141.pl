use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor ceil/;


my($limit)= 10**12;
my($a,$b,$r);

my($sum)=0;

my($max_for_b)= $limit**(1/4);
for( $b = 1; $b<$max_for_b; $b++ )
{
  my($b2)= $b**2;
  
  my($max_a) = ceil( (($limit-$b2)/ $b)**(1/3) );
  for( $a = $b + 1; $a < $max_a; $a++ )
  {
    if( Gcd::pgcd( $b, $a ) !=1 )
    {
      next;
    }
    
    $r =1 ;
    my($a3)=$a**3;
    my($b_a3)= $b*$a3;
    
    my($n2)=$b_a3+$b2 ;
    while( $n2 < $limit )
    {
      my($n)= sqrt($n2);
      
      if( !($n =~m/\./ ) )
      {
        $sum += $n2;
      }
      $n2 += (2*$r+1)*$b_a3 + $b2 ;
      $r++;
    }
    
    
  }
}

print $sum;
