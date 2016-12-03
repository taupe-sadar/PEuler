use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use List::Util qw( max min );

my($side)=2000;
my($max)=$side*$side;

my($modulo)=10**6;
my($modulo_div2)=$modulo/2;


# Goal : find the largest max(cumul) - min(cumul), with argmax(cumul) > argmin(cumul)

# for each array :
# - first entry is for cumul,
# - second is min_cumul recorded
# - 3rd is max cumul, with best max-min, min happening BEFORE max
# - 4th is current best min


my($rhorizontal) = init_array( $side );
my($rvertical) = init_array( $side );
my($rdiagonal) = init_array(2*$side-1);
my($ranti_diagonal) = init_array(2*$side-1);

my(@sequence)=();
for(my($k)=55;$k>=1;$k--)
{
  my($x)=(100003 -200003*$k + 300007*$k*$k*$k)%$modulo - $modulo/2;
 
  statCumul( $$rhorizontal[0],$x);
  statCumul( $$rvertical[$k-1],$x);
  statCumul( $$rdiagonal[$side-$k],$x);
  statCumul( $$ranti_diagonal[$k-1],$x);
  
  push(@sequence,$x);
}

my($n)=56;
while( $n <= $max )
{
  my($next) = ($sequence[23] + $sequence[54] + $modulo)%$modulo - $modulo_div2;
  
  my($x)=floor(($n-1)/$side);
  my($y)=($n-1)%$side;
  
  statCumul( $$rhorizontal[$x],$next);
  statCumul( $$rvertical[$y],$next);
  statCumul( $$rdiagonal[$x-$y+$side-1],$next);
  statCumul( $$ranti_diagonal[$x+$y],$next);

  unshift(@sequence,$next);
  pop(@sequence);
  $n++;
}

print max(map({find_max_delta_cumul($_)} ($rhorizontal,$rvertical,$rdiagonal,$ranti_diagonal)));

sub find_max_delta_cumul
{
  my($rarray)=@_;
  my($max)=0;
  for(my($i)=0;$i<=$#$rarray;$i++)
  {
    my($max_diff_cumul)= $$rarray[$i][2] - $$rarray[$i][1];
    $max = $max_diff_cumul if( $max_diff_cumul > $max );
  }
  return $max;
}


sub init_array
{
  my($size)=@_;
  my(@arrays)=();
  for(my($i)=0;$i<$size;$i++)
  {
    $arrays[$i] = [0,0,0,0];
  }
  return \@arrays;
}


sub statCumul
{
  my($rarray,$val)=@_;
  $$rarray[0] += $val;
  
  my($cumul)= $$rarray[0];
  if( $cumul < $$rarray[3] )
  {
    $$rarray[3] = $cumul;
  }
  if( ($cumul - $$rarray[3]) > ($$rarray[2] - $$rarray[1]) )
  {
    $$rarray[2] = $cumul;
    $$rarray[1] = $$rarray[3];
  }
}
