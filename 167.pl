use strict;
use warnings;
use Data::Dumper;

use Hashtools;

my(%all_sums)=();

my(@seq)=(2,9);
$all_sums{$seq[0] + $seq[1]}=1;

my($n)=2;
my($current)=$seq[1]+1;
while($n < 500 )
{
  if( exists($all_sums{$current}))
  {
    if( $all_sums{$current} == 1 )
    {
      push(@seq,$current);
      for(my($i)=0;$i<$#seq;$i++)
      {
        Hashtools::increment(\%all_sums,$current + $seq[$i]);
      }
      print "$n : $current (".($current-$seq[-2]).")\n"; 
      $n++;
    }
  }
  $current++;
}

