use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

# Laminae can be described as a difference of squares :
# L(m,n)= m^2 - n^2, with m,n both even or both odd, and m > n >= 1
# A smart approach consists in determining m^2 - (m-2*k)^2,
# and determining bounds for k, and for m

my($max_tiles)=10**6;

my($count)=0;
my($max_k)=floor((sqrt(1+$max_tiles)-1)/2);
for(my($k)=1;$k<=$max_k;$k++)
{
  my($m_max)=floor($k + $max_tiles/(4*$k));
  my($m_min)=2*$k+1;
  $count += ($m_max - $m_min + 1);
}
print $count;

