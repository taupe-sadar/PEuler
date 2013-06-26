use strict;
use warnings;
use Data::Dumper;
use Sums;
use POSIX qw/floor ceil/;

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

my($a_most_square_possible)=0;
while( $square_sums[$a_most_square_possible +1] <= $max )
{
  $a_most_square_possible++;
} 
if(0)
{
open FILE, "> log.csv";
for( my($a)=$#square_sums;$a>$a_most_square_possible;$a--)
{
  my($est_ind)= floor( (3*($square_sums[$a] - $max)  )**(1/3) );
  print "$est_ind\n";
  $est_ind-- while( $square_sums[$a] - $square_sums[$est_ind] <= $max );
  $est_ind++ while( $square_sums[$a] - $square_sums[$est_ind] > $max );
  
  print FILE "$a;$est_ind;".($a - $est_ind ).";\n";
  
}
for( my($a)=$a_most_square_possible;$a>1;$a--)
{
  print FILE "$a;0;".$a.";\n";
}
close FILE;
print "".($#square_sums+1)."\n";
}

my($sum_palindromes)=0;
for( my($a)=$#square_sums;$a>1;$a--)
{
  my($squ)=$square_sums[$a];
  for( my($b)=$a-2;$b>=0;$b--)
  {
    my($consecutive_squares)= $squ - $square_sums[$b];
    last if( $consecutive_squares > $max );
    if( is_palindromic( $consecutive_squares ) )
    {
      $sum_palindromes+= $consecutive_squares ;
    }
  }
}
print "--> $sum_palindromes\n";

sub is_palindromic
{
  my($consecutive)=@_;
  return ( join("",reverse(split(//,$consecutive))) == $consecutive);
}