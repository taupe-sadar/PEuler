#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min max);

use Permutations;

my($max,$nmax)=(25,75);
my($cmax)=1984;

my(@table_a)=(0)x6;
my(@table_b)=(0)x6;

build_tables(\@table_a,\@table_b);

my(@S)=([[0,0,1]]);

print "----- transform 1 ---------\n";

my($x1)=transform(0,[0,0,1]);
print Dumper $x1;
print "------- transform 2 -------\n";
my($x2)=transform(0,$x1);
print Dumper $x2;
my($val)=$$x2[3]*Permutations::factorielle(4) + $$x2[4]*Permutations::factorielle(4);
print "val : $$x2[3]*24 + $$x2[4] *24 = $val\n";

print "------- base tables -------\n";
print Dumper \@table_a;
print Dumper \@table_b;


sub transform
{
  my($isA,$rnum_colors)=@_;
  my(@new_num_colors)=(0)x($#$rnum_colors+5);
  my($rtable)=($isA?\@table_a:\@table_b);
  for(my($old)=2;$old<=$#$rnum_colors;$old++)
  {
    for(my($new)=0;$new<=5;$new++)
    {
      for(my($use_old)=max(0,1-$new);$use_old<=min(5-$new,$old-2);$use_old++)
      {
        # print "$old $new $use_old\n";
        $new_num_colors[$old+$new] += $$rnum_colors[$old]*$$rtable[$new+$use_old] * Permutations::cnk($old-2,$use_old) * Permutations::cnk($new+$use_old,$use_old) * Permutations::factorielle($use_old);
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
      print Dumper \@new_state if($number_used == 0);
      $$rtable_a[$number_used]++ if($try != -1);
      $$rtable_b[$number_used]++ ;
    }
  }
}
