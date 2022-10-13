use strict;
use warnings;
use Data::Dumper;

my($size)=10**7;

my(@crible)=(2)x$size;
$crible[0]=0;
$crible[1]=1;

my($count)=0;

for(my($i)=2;$i<$size;$i++)
{
  my($prod)=2*$i;
  while($prod < $size)
  {
    $crible[$prod]++;
    $prod+=$i;
  }
  $count ++ if($crible[$i] == $crible[$i-1]); 
}
print $count;