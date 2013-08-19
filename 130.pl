use strict;
use warnings;
use Data::Dumper;
use Prime;
use SmartMult;
use List::Util qw( sum );

my($first_wanted) = 25;

Prime::init_crible(10000);

my(@valid_composites)=();
my($n)=3;
while( $#valid_composites+1  < $first_wanted )
{
  $n+=2;
  next if(Prime::is_prime($n));
  next if( $n%5 == 0);
  
  if( SmartMult::smart_mult_modulo( 10, $n-1, 9*$n ) == 1)
  {
    push( @valid_composites, $n );
  }
      
}
print sum( @valid_composites );
