use strict;
use warnings;
use Data::Dumper;
use MatrixPaths;

my($size)=MatrixPaths::init("83_matrix.txt");

MatrixPaths::set_start(0,0);
MatrixPaths::sort_shortest_keys();

my($minimum)=-1;
while( 1 )
{
  my($x,$y)=split("-",MatrixPaths::get_best_distance());

  if( !defined($x))
  {
    last;
  }
  my($r)= MatrixPaths::compute_if_not_available($x,$y,'right');
  if( $r !=-1 && $minimum == -1)
  {
    if( ($y +1 == $size -1)  && ($x  == $size -1) )
    {
      $minimum = $r;
      last;
    }
  }
  $r=MatrixPaths::compute_if_not_available($x,$y,'down');
  if( $r !=-1 && $minimum == -1)
  {
    if( ($y == $size -1)  && ($x+1  == $size -1) )
    {
      $minimum = $r;
      last;
    }
  }
  MatrixPaths::compute_if_not_available($x,$y,'left');
  MatrixPaths::compute_if_not_available($x,$y,'up');
}

print $minimum;
