#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my($width)=32;
my($height)=10;

my(@transitions)=(0)x(3**$width);
my(@end_of_wall_reachable)=(0)x(3**$width);

my(@state_increasing)=(0)*$width;
my($dec_state)=\@state_increasing;

for(my($state)=0;$state<=$#array;$state++)
{
  if( valid($dec_state) || $state == 0 )
  {
    $transitions[$state] = calc_transitions($dec_state);
    $end_of_wall_reachable = calc_end_of_wall_reachable($dec_state);
  }
  incr($dec_state);
}

sub valid
{
  my($rstate)=@_;
  for(my($i)=0;$i<$#$rstate;$i++)
  {
    return 0 if($$rstate[$i]==$$rstate[$i+1]);
  }
  return 1;
}

sub encode
{
  my($rstate)=@_;
  my($encoded)=0;
  for(my($i)=$#$rstate;$i>=0;$i--)
  {
    $encoded=3*$encoded + $$rstate[$i];
  }
  return $encoded;
}

sub calc_transitions
{
  my($rstate)=@_;
  my(%next_states)=();
}

sub calc_end_of_wall_reachable
{
  my($rstate)=@_;
  for(my($i)=0;$i<=$#$rstate;$i++)
  {
    return 0 if($$rstate[$i]==0);
  }
  return 1;
}