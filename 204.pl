#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;

my($max_hamming)=10**9;
my($type)=100;
# my($max_hamming)=10**8;
# my($type)=5;

Prime::init_crible($type);
my(%numbers)=(1=>1);
my($p)=Prime::next_prime();
while($p<=$type)
{
  my($pow)=$p;
  my(@vals)=(sort({$a<=>$b}keys(%numbers)));
  
  while($pow<=$max_hamming)
  {
    for(my($i)=0;$i<=$#vals;$i++)
    {
      my($val)=$vals[$i]*$pow;
      last if($val > $max_hamming);
      $numbers{$val}=1;
    }
    $pow*=$p;
  }
  $p=Prime::next_prime();
}
my($num)=scalar(keys(%numbers));
print $num;
