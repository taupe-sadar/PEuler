#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(max min);

# For each flea starting in position(x,y), we calculate the probability p(x,y,X,Y)
# of being in position(X,Y) after 50 steps. For each starting flea we have then a
# 2 dimensional array 30x30.
# 
# For optimization reason we may compute only the starting fleas such as 0 <= x <= y < 30/2,
# the others can be found by symetry in already calculated flea
#
# The esperance E of the number of empty cells after 50 steps, may be expressed as the sum of
# the esperance of empty in one single cell e(X,Y), over all cells
#   E = sum e(X,Y)
# As there can be at most 1 empty cell in 1 cell
#   e(X,Y) = Prod_x_y( (1-p(x,y,X,Y)) )

my($grid_size)=30;
my($steps)=50;

my(@probas_grids)=();
for(my($i)=0;$i<$grid_size/2;$i++)
{
  my($rprobas_line)=$probas_grids[$i];
  my(@g)=();
  for(my($j)=0;$j<=$i;$j++)
  {
    push(@g,compute_probas_flea($i,$j));
  }
  push(@probas_grids,\@g);
}

my($esperance)=0;
my($count)=0;
for(my($i)=0;$i<$grid_size/2;$i++)
{
  for(my($j)=0;$j<=$i;$j++)
  {
    my($esp) = calc_esperance_one_cell(\@probas_grids,$i,$j);
    $esperance += $esp * (($i==$j)?4:8);
    $count += (($i==$j)?4:8);
  }
}
print $esperance;

sub compute_probas_flea
{
  my($x,$y)=@_;
  my(@grid)=();
  for(my($i)=0;$i<$grid_size;$i++)
  {
    my(@t)=(0)x$grid_size;
    push(@grid,\@t);
  }
  
  $grid[$x][$y]=1;
  for(my($step)=1;$step<=$steps;$step++)
  {
    for(my($i)=0;$i<=$#grid;$i++)
    {
      my($iborder)=($i==0 || $i==$#grid)?1:0;
      my($rgrid_line)=$grid[$i];
      my($start_j)=($x+$y+$step+1+$i)%2;
      for(my($j)=$start_j;$j<=$#$rgrid_line;$j+=2)
      {
        next if($grid[$i][$j]==0);
        
        my($num_borders)=4-((($j==0 || $j==$#grid)?1:0)+$iborder);
        my($proba)=($grid[$i][$j])/$num_borders;
        $grid[$i-1][$j]+=$proba if($i>0);
        $grid[$i+1][$j]+=$proba if($i<$#grid);
        $grid[$i][$j-1]+=$proba if($j>0);
        $grid[$i][$j+1]+=$proba if($j<$#grid);
        $grid[$i][$j] = 0;
      }
    }
  }
  return \@grid;
}

sub calc_esperance_one_cell
{
  my($grid,$i,$j)=@_;
  my($esperance)=1;

  my(@points_4)=([$i,$j],[f($i),$j],[$i,f($j)],[f($i),f($j)]);
  my(@points_8)=(@points_4,[$j,$i],[f($j),$i],[$j,f($i)],[f($j),f($i)]);

  for(my($x)=0;$x<$grid_size/2;$x++)
  {
    for(my($y)=0;$y<=$x;$y++)
    {
      my($rpoints)=($x==$y)?(\@points_4):(\@points_8);
      for my $p (@$rpoints)
      {
        my($grid_selected)=$$grid[$x][$y][$$p[0]][$$p[1]];
        $esperance *= (1-$grid_selected) if($grid_selected != 0);
      }
    }
  }
  return $esperance;
}

sub f
{
  my($x)=@_;
  return $grid_size - $x - 1;
}
