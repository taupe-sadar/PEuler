#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min max);

use Permutations;

# First calculation of transition tables :
# Starting with 2 colors with ID -2 and -1, and for each case A or B, 
# we calculate all ways to choose a color value (in [0,4]), on the places (X,Y,Z,W,T)
# with the constraint that the values are ordered : the first '0' is before the first '1' in the (X,Y,Z,W,T) set
#   
#  (-2)----- X
#    | \   / |
#    |   Y   |
#    |   |   |
#    |   Z   |
#    |   |   |
#    |   W   |
#    | /   \ |
#  (-1)******T
# 
# This calculation give a vector of "number of colors" ncol[c] of transition of colors, that we use for each additional unit A or B
#
# Then for the transitions : 
# If we want to know how many ways to color a pattern S(a,b,c) of a units A and bunits B, with exactly c colors
#
#   S(a,b,c) = sum_c' S(a-1,b,c') * fA(c,c') + S(a,b - 1,c') * fB(c,c')
#
# where fX(c,c') is the transtion vector, where c is the color used in S(a,b,c), and c' are the (old) color used in S(a,b,c'),
# ( the -2 and -1 colors cannot be used as an old color )
#
# The transition fonction is calculated : 
#
# if we use (cn) = c-c' new colors, (co) old colors, in the 5 availbale places (X,Y,Z,W,T), 1 <= cn + co <= 5
# - there are cnk( c'-2, co) choices for the old colors
# - there are cnk(cn + co, co) choices for placing them in the pattern
# - there are (co!) choices for placing them in all different orders
# - there is only 1 choice for placing the remaining new colors, because we keep them ordered !
# 
# fX(c,c') = sum_co ( cnk( c'-2, co) * cnk(cn + co, co) * (co!) * 1 * ncol[c'] )
#
# Finally, as the color are ordered, the total ways of coloring is : 
# sum_c S(a,b,c) * ank( cmax, c)
#
# Important optimisation ank( cmax, c), is divisible 10**8, very soon, so its becoming nul as c gets big.
# We calculate a limit for c, where calculation is no more needed

my($mmax,$nmax,$cmax)=(25,75,1984);
my($modulo)=10**8;

my(@table_a)=(0)x6;
my(@table_b)=(0)x6;

build_tables(\@table_a,\@table_b);

my(@ank)=(1);
my($prod)=1;
my($climit)=0;
while($prod > 0)
{
  $prod*=$cmax - $climit;
  $prod%=$modulo;
  push(@ank,$prod) if($prod > 0);
  
  $climit++;
}
$climit--;

my(@S)=([[0,0,1]]);

for(my($n)=1;$n<=$nmax;$n++)
{
  my($next)=transform(0,$S[0][$n-1],$modulo,$climit);
  push(@{$S[0]},$next);
}

for(my($m)=1;$m<=$mmax;$m++)
{
  my($next)=transform(1,$S[$m-1][0],$modulo,$climit);
  push(@S,[$next]);
}

for(my($m)=1;$m<=$mmax;$m++)
{
  for(my($n)=1;$n<=$nmax;$n++)
  {
    my($nextA)=transform(1,$S[$m-1][$n],$modulo,$climit);
    my($nextB)=transform(0,$S[$m][$n-1],$modulo,$climit);
    my(@numcolors)=();
    for(my($c)=0;$c<=$#$nextA;$c++)
    {
      push(@numcolors,($$nextA[$c]+$$nextB[$c])%$modulo);
    }
    push(@{$S[$m]},\@numcolors);
  }
}
my($result)=0;
for(my($c)=0;$c<=$#{$S[$mmax][$nmax]};$c++)
{
  $result += ($S[$mmax][$nmax][$c] * $ank[$c])%$modulo;
}

print $result%$modulo;

sub transform
{
  my($isA,$rnum_colors,$mod,$colormax)=@_;
  
  my($max_colors)=min($#$rnum_colors + 5,$colormax);
  my(@new_num_colors)=(0)x($max_colors+1);
  
  my($rtable)=($isA?\@table_a:\@table_b);
  for(my($old)=2;$old<=$#$rnum_colors;$old++)
  {
    my($max_new)=$max_colors-$old;
    for(my($new)=0;$new<=$max_new;$new++)
    {
      for(my($use_old)=max(0,1-$new);$use_old<=min(5-$new,$old-2);$use_old++)
      {
        my($incr)=($$rnum_colors[$old]*$$rtable[$new+$use_old]);
        my($combos)=(Permutations::cnk($old-2,$use_old)*Permutations::ank($new+$use_old,$use_old));
        $new_num_colors[$old+$new] += ($incr * $combos)%$mod;
      }
    }
  }
  return \@new_num_colors;
}

sub build_tables
{
  my($rtable_a,$rtable_b)=@_;
  my(@state)=();
  try_nodes($rtable_a,$rtable_b,\@state,0);
}

sub try_nodes
{
  my($rtable_a,$rtable_b,$rstate,$next_available)=@_;
  
  for(my($try)=-2;$try<= $next_available;$try++)
  {
    my(@new_state)=(@$rstate,$try);
    my($idx)=$#new_state;
    next if(($idx == 0 || $idx == 1) && $try==-2);
    next if($idx > 0 && $$rstate[$idx-1] == $try);
    next if($idx == 3 && $try == -1);
    next if($idx == 4 && $try == $$rstate[0]);

    my($number_used)=$next_available + (($try == $next_available)?1:0);
    if( $idx < 4 )
    {
      try_nodes($rtable_a,$rtable_b,\@new_state,$number_used);
    }
    else
    {
      $$rtable_a[$number_used]++ if($try != -1);
      $$rtable_b[$number_used]++ ;
    }
  }
}
