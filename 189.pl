use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);

# Let us consider one raw of reverse/straight triangles
# A state number of a raw is represented by a number, 
# which base-3 decomposition describes the colors of the triangles 
# in the raw with (for example) (R):0, (G):1, (B):2.
# For example : the number 012221(base3) represent a raw R G B B B G
#
# The algorithm consists in finding which state in a raw can lead to 
# another state in the the next raw 


my($triangles_count)=[1,1,1];

for(my($layer)=1;$layer<=7;$layer++)
{
  #####
  my($num_states)=3**$layer;
  my(@reverse_triangles_count)=(0)x$num_states;
  
  for(my($state)=0;$state<$num_states;$state++)
  {
    my($d)=dec($state,$layer);
    my($partials)=[0];
    my($exp)=1;
    for(my($pos)=0;$pos<=$#$d;$pos++)
    {
      my(@new_partials)=();
      for(my($pidx)=0;$pidx<=$#$partials;$pidx++)
      {
        my($forbid)=$$d[$pos];
        push(@new_partials,$$partials[$pidx] + $exp * (($forbid + 1)%3));
        push(@new_partials,$$partials[$pidx] + $exp * (($forbid + 2)%3));
      }
      $exp*=3;
      $partials = \@new_partials;
    }
    
    for(my($pidx)=0;$pidx<=$#$partials;$pidx++)
    {
      $reverse_triangles_count[$$partials[$pidx]] += $$triangles_count[$state];
    }
  }
  #######
  
  my($num_states_straight)=3**($layer+1);
  my(@new_triangles_count)=(0)x$num_states_straight;
  
  for(my($state)=0;$state<$num_states;$state++)
  {
    my($d)=dec($state,$layer);
    my($partials)=[0];
    my($exp)=1;
    for(my($pos)=0;$pos<=$#$d + 1;$pos++)
    {
      my(@new_partials)=();
      for(my($pidx)=0;$pidx<=$#$partials;$pidx++)
      {
        if($pos==0 || $pos==$#$d + 1 || $$d[$pos] == $$d[$pos-1])
        {
          my($forbid) = ($pos==$#$d + 1) ? $$d[$pos-1] : $$d[$pos];
          push(@new_partials,$$partials[$pidx] + $exp * (($forbid + 1)%3));
          push(@new_partials,$$partials[$pidx] + $exp * (($forbid + 2)%3));
        }
        else
        {
          my($allowed) = ( ($$d[$pos] + 1) % 3 == $$d[$pos-1]) ? (($$d[$pos] + 2) % 3) : (($$d[$pos] + 1) % 3);
          push(@new_partials,$$partials[$pidx] + $exp * $allowed);
        }
      }
      $exp*=3;
      $partials = \@new_partials;
    }
    for(my($pidx)=0;$pidx<=$#$partials;$pidx++)
    {
      $new_triangles_count[$$partials[$pidx]] += $reverse_triangles_count[$state];
    }
  }
  $triangles_count = \@new_triangles_count;
}
print sum(@$triangles_count);

sub dec
{
  my($x,$n)=@_;
  my(@d)=();
  for(my($a)=0;$a<$n;$a++)
  {
    push(@d,$x%3);
    $x=int($x/3);
  }
  return \@d;
}