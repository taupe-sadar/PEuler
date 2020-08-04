use strict;
use warnings;
use Data::Dumper;
use TriangleData;

open(FILE,"67_triangle.txt");
my(@TRIANGLE)=<FILE>;
close(FILE);

my($i,$j);
for($i=0;$i<=$#TRIANGLE;$i++)
{
  my(@ref)=split(/ /,$TRIANGLE[$i]);
  $TRIANGLE[$i]=\@ref;
}
print TriangleData::get_max_path(\@TRIANGLE);


