use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor ceil/;
use List::Util qw( sum );

use Divisors;

my($max)=10**8;

# Heuristic 0
# Divisors::calc_all_until($max);
# my($rlist)=Divisors::get_list();
# print sum(@$rlist[1..$#$rlist])."\n";

# print Dumper $rlist;

# Heuristic 1
# my($s)=0;
# my($c)=1;
# my($k)=1;
# while($c>0)
# {
  # $c= floor($max/$k)*$k;
  # $s += $c;
  # $k++;
# }

# print "-> $s\n";

# Heuristic 2

my($s2)= calc_divs($max,10000);

print "--> $s2\n";

sub calc_divs
{
  my($num,$param)=@_;
  my($s)=0;
  my($c)=2;
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
