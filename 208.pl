#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;

# We have
# cos(2pi /5) = cos( -2pi/5) = (1-sqrt(5))/4
# cos(4pi /5) = cos( -4pi/5) = (-1-sqrt(5))/4
# sin(2pi /5) = - sin( -2pi/5) = sqrt((5 + sqrt(5))/8)
# sin(4pi /5) = - sin( -4pi/5) = sqrt((5 - sqrt(5))/8)
# cos(0)=1, sin(0)=0
#
# Let us consider the five vectors v_k=[cos(2pi*k/5),sin(2pi*k/n)] with k in [-2;2]
# One can prove that any rational weighting sum(a_k,v_k), with a_k rational is possible 
# if and only if all a_k are equal
#
# Then let us consider the arcs as such vectors, for simplicity.
# A complete loop of such arcs is possible only if there is a multiple of 5 arcs (n x 5),
# and that the same amount of vector of each type is used (n)
# 
# We represent the current path with 2 variables : the vector (v_k) used, an orientation (positive,negative)
#
# At each step, only 2 possibilities
# - the orientation stills the same, using next vector v_k+1 if oriention positive, v_k-1 if negative
#   with k wrapping (from -2 to +2)
# - the orientation changes, using the same vector vk
#
# The algorithm is working on a state [ o, c0, c1, c2, c3, c4 ] where o is the current orientation, and the c_k are 
# the current counting of v_k used.
# We use a basic encoding for storing in a hash


my($num_arcs)=70;
my($num_per_arc)=$num_arcs/5;

my($counts)={encode_idx(0,0,0,0,0,0) => 1};
for(my($arc_count)=1;$arc_count<=$num_arcs;$arc_count++)
{
  my(%new_counts)=();
  foreach my $idx (keys(%$counts))
  {
    my($last,@count_arcs_type)=decode_idx($idx);
    if($last < 5)
    {
      my(@state)=(@count_arcs_type);
      my($next)=($last+1)%5;
      if($state[$next] < $num_per_arc)
      {
        $state[$next]++;
        Hashtools::increment(\%new_counts,encode_idx($next,@state),$$counts{$idx});
        $state[$next]--;
      }
      
      if($state[$last] < $num_per_arc)
      {
        $state[$last]++;
        Hashtools::increment(\%new_counts,encode_idx($last+5,@state),$$counts{$idx});
      }
    }
    else
    {
      my(@state)=(@count_arcs_type);
      my($next)=($last-1)%5;
      if($state[$next] < $num_per_arc)
      {
        $state[$next]++;
        Hashtools::increment(\%new_counts,encode_idx($next+5,@state),$$counts{$idx});
        $state[$next]--;
      }

      if($state[$last-5] < $num_per_arc)
      {
        $state[$last-5]++;
        Hashtools::increment(\%new_counts,encode_idx($last-5,@state),$$counts{$idx});
      }
    }
  }
  $counts = \%new_counts;
}
my($final_count)=0;
for my $e (keys(%$counts))
{
  $final_count+=$$counts{$e};
}
print $final_count;

sub encode_idx
{
  my(@args)=@_;
  my($idx)=0;
  for(my($i)=0;$i<=$#args;$i++)
  {
    $idx += $args[$i]<<($i*4);
  }
  return $idx; 
}

sub decode_idx
{
  my($idx)=@_;
  my(@args)=();
  for(my($i)=0;$i<=5;$i++)
  {
    push(@args, $idx & 0x0f);
    $idx >>=4;
  }
  return (@args); 
}