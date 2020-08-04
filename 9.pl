use strict;
use warnings;
use Data::Dumper;
use Prime;

#Caracterisation of  a^2 + b^2 = c^2 with 0 < a < b < c
# a = m *( l^2 - k^2) /2
# b = m * k * l
# c = m *( l^2 + k^2) /2
# with k,l ODDS numbers and m >0 , l > k > l*(sqrt(2) - 1 )
# then a + b + c = m * l *( k + l)

my($number)=1000;
my(%hash)=Prime::decompose($number/2); 
my(@divisors)=Prime::all_divisors_no_larger(\%hash);
my($cospisur4)=sqrt(2)/2;


my($i,$j)=(0,0);
for($i=0;$i<=$#divisors;$i++)
{
  my($lplusksur2)=$divisors[$i];
  my(%hash2)=Prime::decompose($number/2/$divisors[$i]); 
  my(@divisors2)=Prime::all_divisors_no_larger(\%hash2);
  for($j=0;$j<=$#divisors2;$j++)
  {
    my($l)=$divisors2[$j];
    if(!(($lplusksur2 < $l)&&($lplusksur2 > ($l*$cospisur4))))
    {
      next;
    }
    my($k)=$lplusksur2*2 - $l;
    my($m)=$number/($lplusksur2*2)/$l;
    my($a)=$m*($l*$l-$k*$k)/2;
    my($b)=$m*$l*$k;
    my($c)=$m*($l*$l+$k*$k)/2;
    print $a*$b*$c;
    exit();
  }
}