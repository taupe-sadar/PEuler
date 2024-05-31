#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor/;
use Permutations;

# The function f: (a,b,c,d,e,f) -> (b,c,d,e,f,a^(b&c)) is bijective.
# The set E of all values of (a,b,c,d,e,f) can be separated of 
# of distincts orbits of f. In any orbit, each value x verify f^n(x)=x for some n > 0
#
# A truth table function T must verify that an element x in an orbit, and its successor f(x)
# cant be both equal to 1. That is to say x AND f(x) = 0
#
# In order to count all those possibilities h(m) in an orbit of size (m), we consider all the ways to place some pieces of width 2
# (representing a value and its successor), in a larger set of size (m), that set is wrapping, so a piece could
# be placed on the begining and the end.
#
# So we have h(m) = sum_(k)( C(m-k,k) ) (k in 0..floor(m/2))     (no piece across the wrap)
#                 + sum_(k)( C(m-k-1,k-1) ) (k in 1..floor(m/2)) (one piece across the wrap)
#
# Finally the amount of T functions are 
# prod( h(m) ) for all orbits m of f.

my($n)=6;

my(@orbs)=analyze_orbits($n);
my($count)=1;
for(my($i)=0;$i<=$#orbs;$i++)
{
  $count *= all_placement_in_orbit($orbs[$i]);
}
print $count;

sub all_placement_in_orbit
{
  my($set_size)=@_;
  my($num)=0;
  for(my($sub)=0;$sub<=floor($set_size/2);$sub++)
  {
    my($n,$k)=($set_size-$sub,$sub);
    my($p)=Permutations::cnk($set_size-$sub,$sub);
    
    $num += Permutations::cnk($set_size-$sub,$sub);
    if($sub > 0 )
    {
      $num += Permutations::cnk($set_size-$sub-1,$sub-1);
    }
  }
  return $num;
}

sub analyze_orbits
{
  my($num_variables)=@_;
  my($max_variable)=2**$num_variables-1;
  my(%used)=();
  my(@orbits)=();
  for(my($i)=0;$i<=$max_variable;$i++)
  {
    unless(exists($used{$i}))
    {
      my($count)=1;
      $used{$i} = 1;
      my($nb)=next_in_orbit($i);

      while($nb!=$i)
      {
        $count++;
        $used{$nb}=1;
        $nb=next_in_orbit($nb);
      }
      push(@orbits,$count);
    }
  }
  return @orbits;
}



sub next_in_orbit
{
  my($x)=@_;
  my($a)=( $x & 0x20 )>>5;
  my($b)=( $x & 0x10 )>>4;
  my($c)=( $x & 0x08 )>>3;
  return (($x<<1) + ($a ^ ($b&$c)))&(0x3f);
}


