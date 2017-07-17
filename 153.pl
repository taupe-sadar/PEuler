use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

my($max)=10**8;

my($s2)= calc_divs($max,10000);

print "--> $s2\n";

sub calc_divs
{
  my($num,$param)=@_;
  my($s)=0;
  my($k)=1;
  while(1)
  {
    my($f)= floor($num/$k);
    
    last if( $f <$param );
    
    $s += $f*$k;
    $k++;
  }
  
  my($last_bound)=$num;
  for(my($i)=2;$i<=$param;$i++)
  {
    my($bound)= floor($num/$i);
    $s+= sum_of_integers($bound+1,$last_bound) * ($i-1);
    $last_bound = $bound;
  }
  
  return $s;
}
