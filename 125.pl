use strict;
use warnings;
use Data::Dumper;
use Sums;
use POSIX qw/floor ceil/;
use List::Util qw( sum );

my($max)=10**8;
my(@square_sums)=();

my($sum)=0;
my($i)=0;
while( ($i**2 + ($i-1)**2) <= $max)
{
  push( @square_sums, $sum );
  $i++;
  $sum = Sums::int_square_sum( $i);
}
my(%all_palindromic_sum_square)=();
for( my($a)=$#square_sums;$a>1;$a--)
{
  my($squ)=$square_sums[$a];
  for( my($b)=$a-2;$b>=0;$b--)
  {
    my($consecutive_squares)= $squ - $square_sums[$b];
    last if( $consecutive_squares > $max );
    if( is_palindromic( $consecutive_squares ) )
    {
      if( !exists( $all_palindromic_sum_square{$consecutive_squares} ))
      {
        $all_palindromic_sum_square{$consecutive_squares} = 1;
      }
    }
  }
}
print sum(keys(%all_palindromic_sum_square));

sub is_palindromic
{
  my($consecutive)=@_;
  return ( join("",reverse(split(//,$consecutive))) == $consecutive);
}