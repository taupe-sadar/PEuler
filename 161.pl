use strict;
use warnings;
use Data::Dumper;

my($wide)=9;
my($num_states)=3**$wide;

my(@transitions)=();
for(my($i)=0;$i<$num_states;$i++)
{
  push(@transitions,[(0)x$num_states]);
}
my(@workspace)=();
for(my($i)=0;$i<$wide;$i++)
{
  push(@workspace,[0,0,0]);
}
for(my($i)=0;$i<2;$i++)
{
  push(@workspace,[1,1,1]);
}

my(@pieces) = (
  [[0,1],[0,2]],
  [[1,0],[2,0]],
  [[0,1],[-1,1]],
  [[0,1],[1,1]],
  [[1,0],[1,1]],
  [[1,0],[1,1]]
);


for(my($s)=0;$s<$num_states;$s++)
{
  init_workspace($s);
  fill_with_pieces_rec($s,0);
}

sub init_workspace
{
  my($state)=@_;
  my($row)=0;
  while($row < $wide)
  {
    my($level)=$state%3;
    
    for(my($i)=0;$i<3;$i++)
    {
      $workspace[$row][$i]= ($i < $level ? 1 : 0);
    }
    $state = ($state -$level)/3;
    $row++;
  }
}

sub fill_with_pieces_rec
{
  my($state,$current_row)=@_;
  
  while($current_row < $wide && $workspace[$current_row][0] == 1)
  {
    $current_row++;
  }
  
  if( $current_row == $wide )
  {
    write_transition($state);
  }
  else
  {
    for(my($p)=0;$p<=$#pieces;$p++)
    {
      if(try_add_piece($current_row,$p))
      {
        fill_with_pieces_rec($state,$current_row+1);
        remove_piece($current_row,$p);
      }
    }
  }
}

sub write_transition
{
  my($state)=@_;
  my($next_state)=0;
  
  for(my($i)=$wide-1;$i>=0;$i--)
  {
    if($workspace[$i][2] == 1)
    {
      $next_state+=2;
    }
    elsif($workspace[$i][1] == 1)
    {
      $next_state++;
    }
    $next_state*=3 if($i>0);
  }
  
  $transitions[$state][$next_state]++;
}

sub try_add_piece
{
  my($row,$pidx)=@_;
  my($piece)=$pieces[$pidx];
  if( $workspace[$row + $$piece[0][0] ][ $$piece[0][1] ] == 0 &&
      $workspace[$row + $$piece[1][0] ][ $$piece[1][1] ] == 0 
    )
  {
    $workspace[$row + $$piece[0][0] ][ $$piece[0][1] ] = 1;
    $workspace[$row + $$piece[1][0] ][ $$piece[1][1] ] = 1;
    return 1;
  }
  else
  {
    return 0;
  }
}

sub remove_piece
{
  my($row,$pidx)=@_;
  my($piece)=$pieces[$pidx];
  $workspace[$row + $$piece[0][0] ][ $$piece[0][1] ] = 0;
  $workspace[$row + $$piece[1][0] ][ $$piece[1][1] ] = 0;
}

