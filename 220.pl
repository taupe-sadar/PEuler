use strict;
use warnings;
use Data::Dumper;
use List::Util qw( min max );

my($moves_target)=10**12;

my(@vectors)=([1,0]);
my(@facings)=(0);
my(@moves)=(1);
while($moves[-1] < $moves_target)
{
  my($vector,$facing,$move) = dragon_move($vectors[-1],$facings[-1],$moves[-1]);
  push(@vectors,$vector);
  push(@facings,$facing);
  push(@moves,$move);
}

my($final_pos)=find_position($#moves,[0,0],1,$moves_target,0);
print "$$final_pos[0],$$final_pos[1]";

sub find_position
{
  my($dragon,$position,$facing,$target_moves,$reverse_searching)=@_;
  
  if($dragon == 0 )
  {
    return $position;
  }
  else
  {
    my($dragon_moves)=$moves[$dragon];
    die "Invalid target moves $target_moves > $dragon_moves" if($target_moves > $dragon_moves);
    
    my($angle)=($facing + $reverse_searching)%4;
    
    if($target_moves < $dragon_moves/2)
    {
      return find_position($dragon - 1, $position, $angle, $target_moves, 0);
    }
    else
    {
      my($rotated)=vec_rotate($vectors[$dragon - 1],$angle);
      my($offset)=vec_add($position,$rotated);
      my($face)=($angle + $facings[$dragon - 1] + 2*$reverse_searching - 1)%4;
      return find_position($dragon - 1, $offset, $face, $target_moves - $dragon_moves/2, 1);
    }
  }
  
}

sub vec_add
{
  my($v1,$v2)=@_;
  return [$$v1[0]+$$v2[0],$$v1[1]+$$v2[1]];
}

sub vec_rotate
{
  my($v,$rot)=@_;
  return [$$v[0]*ph($rot)+$$v[1]*ph($rot+1),$$v[0]*ph($rot-1)+$$v[1]*ph($rot)];
}

sub ph
{
  my($r)=@_;
  return 0 if($r%2 == 1);
  return 1 - (($r/2)%2)*2;
}

sub dragon_move
{
  my($vec,$face,$moves)=@_;
  my($new_vec)=vec_add($vec,vec_rotate($vec,3));
  return ($new_vec, 2, $moves*2);
  
}
