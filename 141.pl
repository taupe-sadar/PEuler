use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor ceil/;


my($limit)= 10**12;
my($a,$b,$r);

for( $b = 1; $b<10**6; $b++ )
{
  my($max_a) = ceil( ($limit/ $b)**(1/3) );
  
  for( $a = $b + 1; $a < $max_a; $a++ )
  {
    if( Gcd::pgcd( $b, $a ) !=1 )
    {
      next;
    }
    
    $r =1 ;
    my($a3)=$a**3;
    my($n2);
    do
    {
      
      $n2 = $r*$b*($a3 * $r + $b);
      my($n)= sqrt($n2);
      if( !($n =~m/\./ ) )
      {
        my($r0)= $r*$b*$b;
        my($q)= ( $a * $r0 ) / $b;
        my($d) = ( $q * $a ) / $b;
        print "b : $b, a : $a, r : $r -> $n^2 = $r0 + $q * $d \n";
        
      }
      $r++;    
    }
    while( $n2 < $limit);
    
  }
}