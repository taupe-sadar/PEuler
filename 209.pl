#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor/;
use Permutations;

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
    
    print "C_$n-$k : $p\n";
    
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


