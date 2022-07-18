use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum  max );

my($max)=1000000;

my(@maximums)=(0)x$max;


my($sum)=0;

for(my($i)=2;$i<$max;$i++)
{
  $maximums[$i] = max($maximums[$i],digital_root($i));
  
  # print "$i : $maximums[$i]\n";
  
  for(my($j)=2;$j<=$i;$j++)
  {
    my($prod)=$i*$j;
    last if($prod >= $max);
    $maximums[$prod] = max($maximums[$prod],$maximums[$i]+$maximums[$j]);
  }
  $sum += $maximums[$i];
}

print $sum;

sub digital_root
{
  my($n)=@_;
  while($n >= 10 )
  {
    $n = sum(split("",$n));
  }
  return $n;
}

