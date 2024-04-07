#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;

my($n)=40000000;
my($chain_target)=25;
my(@generated_2)=(0)x($n+1);

my($genrated_2_factor)=0;
my($current_generated_2)=0;
my($sum_generated2)=0;

Prime::pow_loop($n,\&init_generated2,\&incr_generated,\&count_generated);
print $sum_generated2;

sub init_generated2
{
  my($p)=@_;
  $genrated_2_factor = ($p == 2)?1:$generated_2[$p-1];
  $current_generated_2 = $genrated_2_factor;
  
  if( $genrated_2_factor == $chain_target - 2 )
  {
    $sum_generated2 += $p ;
  }
  
}

sub incr_generated
{
  $current_generated_2 += $genrated_2_factor;
}

sub count_generated
{
  my($nb,$prev,$max_elem)=@_;
  my($generated)=$generated_2[$prev] + $current_generated_2;
  
  $generated_2[$nb] = $generated;
}
