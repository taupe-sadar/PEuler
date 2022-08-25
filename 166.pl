use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min max);

# Variables names 
#
#   a  i  j  b
#   k  e  f  l
#   m  g  h  n
#   c  o  p  d
# 
#   Sum : S
#
#   With some calculation we deduce than we have
#   a + b = o + p (and other symetrical)
#   a + d = g + f
#   b + c = e + h
#   a + b +c + d = e + f + g + h = S
#

my($total)=0;
for( my($sum) = 0; $sum <= 17; $sum ++ )
{
  $total += num_grids($sum)*2;
}
$total += num_grids(18);

print $total;

sub num_grids
{
  my($S)=@_;
  
  my($count)=0;
  for(my($a)=0;$a<=min(9,$S);$a++)
  {
    for(my($d)=0;$d<=min(9,$S - $a);$d++)
    {
      my($ad)= $a + $d;
      for(my($g)=max(0,$ad-9);$g<=min(9,$ad);$g++)
      {
        my($f)=$ad - $g;
        my($eh)=$S - $ad;
        for(my($e)=max(0,$eh-9);$e<=min(9,$eh);$e++)
        {
          my($h) = $eh - $e;
          for(my($b)=max(0,$eh-9);$b<=min(9,$eh);$b++)
          {
            my($c) = $eh - $b;
            
            my($i_count)=0;
            
            my($ab) = $a + $b;
            for(my($i)=0;$i<=min(9,$S - $ab);$i++)
            {
              my($j) = $S - $ab - $i;
              my($o) = $S - $e - $g - $i;
              my($p) = $S - $h - $f - $j;
              
              next if($j > 9 ||$j < 0);
              next if($o > 9 ||$o < 0);
              next if($p > 9 ||$p < 0);
              
              $i_count++;
            }
            
            my($k_count)=0;
            
            my($ac) = $a + $c;
            for(my($k)=0;$k<=min(9,$S - $ac);$k++)
            {
              my($m) = $S - $ac - $k;
              my($l) = $S - $e - $f - $k;
              my($n) = $S - $g - $h - $m;

              next if($m > 9 ||$m < 0);
              next if($l > 9 ||$l < 0);
              next if($n > 9 ||$n < 0);
              $k_count++;
            }
            $count += $i_count * $k_count;
            
          }
        }
      }
    }
  }
  return $count;
}