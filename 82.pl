use strict;
use warnings;
use Data::Dumper;
use MatrixPaths;

my($size)=MatrixPaths::init("82_matrix.txt");

for(my($b)=0;$b<$size;$b++)
{
    MatrixPaths::set_start($b,0);
}
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
	if( $y +1 == $size -1)
	{
	    $minimum = $r;
	    last;
	}
	  
    }
    MatrixPaths::compute_if_not_available($x,$y,'up');
    MatrixPaths::compute_if_not_available($x,$y,'down');
    
}

print $minimum;
    
