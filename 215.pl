#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my($width)=32;
my($height)=10;
my($num_states)=3**$height;

my(@transitions)=();
my(@end_of_wall_reachable)=(0)x($num_states);

my(@state_increasing)=(0)x$height;
my($dec_state)=\@state_increasing;

for(my($state)=0;$state<=$num_states;$state++)
{
  if( valid($dec_state) || $state == 0 )
  {
    push(@transitions, calc_transitions($dec_state));
    # print "$state\n";
    # print Dumper $transitions[$state]; <STDIN>;
    $end_of_wall_reachable[$state] = calc_end_of_wall_reachable($dec_state);
  }
  else
  {
    push(@transitions,[]);
  }
  incr($dec_state);
}

my(@state_counting)=(0)x$num_states;
$state_counting[0] = 1;

my($rstate_counting)=\@state_counting;
for(my($i)=1;$i<$width;$i++)
{
  $rstate_counting = iterate_counting($rstate_counting,\@transitions);
  # print Dumper \@transitions;
  # print Dumper $rstate_counting;<STDIN>;
}


my($final_count)=0;
for(my($state)=0;$state<=$#$rstate_counting;$state++)
{
  if($end_of_wall_reachable[$state])
  {
    $final_count += $$rstate_counting[$state];
  }
}
print $final_count;

sub valid
{
  my($rstate)=@_;
  for(my($i)=0;$i<$#$rstate;$i++)
  {
    return 0 if($$rstate[$i]==0 && $$rstate[$i+1]==0);
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

sub incr
{
  my($rstate)=@_;
  my($idx)=0;
  while($idx <= $#$rstate)
  {
    if($$rstate[$idx] == 2)
    {
      $$rstate[$idx++] = 0;
    }
    else
    {
      $$rstate[$idx]++;
      last;
    }
  }
}

sub calc_transitions
{
  my($rstate)=@_;

  my(@possible_state)=();
  my(@next_states)=calc_transitions_rec($rstate,\@possible_state);
  
  return \@next_states;
}

sub calc_transitions_rec
{
  my($rstate,$rpossible)=@_;

  if($#$rstate == $#$rpossible)
  {
    # print ('['.join("",@$rstate)."] -> ");
    # print ('['.join("",@$rpossible)."]\n");
    # <STDIN>;
    
    return (encode($rpossible));
  }
  else
  {
    my($step)=$#$rpossible+1;
    my(@nexts)=();
    if( $$rstate[$step] == 0 )
    {
      @nexts = (1);
    }
    elsif( $$rstate[$step] == 1 )
    {
      @nexts = (0,2);
    }
    elsif( $$rstate[$step] == 2 )
    {
      @nexts = (0);
    }
    
    # print "Loop ($step)\n";
    # print ('['.join("",@$rstate)."]\n");
    # print ('['.join("",@$rpossible)."]");
    # print (' -> ['.join("",@nexts)."]\n");
    # <STDIN>;

    my(@sols)=();
    foreach my $case (@nexts)
    {
      if( $step == 0 || $case != 0 || $$rpossible[-1] != 0)
      {
        push(@$rpossible,$case);
        push(@sols,calc_transitions_rec($rstate,$rpossible));
        pop(@$rpossible);
      }
    }
    return (@sols);
  }
}

sub iterate_counting
{
  my($rcounting,$rtransitions)=@_;
  my(@new_counting)=(0)x($#$rcounting+1);
  for(my($i)=0;$i<=$#$rcounting;$i++)
  {
    foreach my $t (@{$$rtransitions[$i]})
    {
      $new_counting[$t] += $$rcounting[$i]; 
    }
  }
  return \@new_counting;
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