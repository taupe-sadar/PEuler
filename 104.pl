use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

my($stop) = 0;
my(@un)=(0,1); 
my($modulo)= 10**9;
my($n)=1; 
my($phi)= (sqrt(5) + 1) / 2;
my($log10) = log(10);

print first_nine_fibo_digits( 55585824 );
print "\n";

while(1)
{
  @un = ($un[1], ($un[1] + $un[0] )%$modulo );
  $n++;

  if( test_pandigital($un[1]) )
  {
      my( $first_digits)= first_nine_fibo_digits( $n);
      if( test_pandigital( $first_digits  ) )
      {
	  last;
      }
  }
}

print ($n);

sub test_pandigital
{
    my($x)=@_;
    if($x =~m/0/ )
    {
	return 0;
    }
    #C'est crad mais ca gagne 45% par rapport a la boucle!
    return (($x=~m/1/)&&($x=~m/2/)&& ($x=~m/3/)&&($x=~m/4/)&&($x=~m/5/)&& ($x=~m/6/)&&($x=~m/7/)&&($x=~m/8/)&&($x=~m/9/) );
   
}

sub first_nine_fibo_digits
{
    my($n)= @_;
    my($log10fibo) = ($n * log( $phi ) - log( 5 )/2 )/ $log10 ;
    my($fraclog10fibo) = $log10fibo - floor( $log10fibo );
    return floor( exp( ($fraclog10fibo + 8 ) * $log10  ) );
}
