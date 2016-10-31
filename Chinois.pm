package Chinois;
use ChinoisC;
use strict;
use warnings;

my($base)= 1<<32;

sub chinoisPrime
{
  my($x)=@_;
  return ChinoisC::longChinoisTest($x>>32,$x&0xffffffff);
}
1;
