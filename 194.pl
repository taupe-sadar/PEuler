#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min max);

use Permutations;

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
        my($incr)=($$rnum_colors[$old]*$$rtable[$new+$use_old])%$mod;
        my($combos)=(Permutations::cnk($old-2,$use_old)*Permutations::cnk($new+$use_old,$use_old)*Permutations::factorielle($use_old))%$mod;;
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
