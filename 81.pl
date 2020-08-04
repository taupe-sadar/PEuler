use strict;
use warnings;
use Data::Dumper;
use MatrixPaths;

my($size)=MatrixPaths::init("81_matrix.txt");

MatrixPaths::set_start(0,0);

for(my($a)=0;$a<$size;$a++)
{
  my($b0)= ($a==0) ? 1 :0;
  for(my($b)=$b0;$b<$size;$b++)
  {
    MatrixPaths::compute_min_up_left($a,$b);
  }
}

print MatrixPaths::get_bestdistance($size-1,$size-1);



