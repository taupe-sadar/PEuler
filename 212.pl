#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my($num_cuboids)=50000;
my($space)=10000;
my($width)=399;
my($divisions)=25;

my(@cuboids)=();

for(my($c)=0;$c<$num_cuboids;$c++)
{
  my($cubo)=cuboid($gen);
  my(@xidx)=(idx_div($$cubo[0]),idx_div($$cubo[0]+$$cubo[3]-1));
  my(@yidx)=(idx_div($$cubo[1]),idx_div($$cubo[1]+$$cubo[4]-1));
  my(@zidx)=(idx_div($$cubo[2]),idx_div($$cubo[2]+$$cubo[5]-1));
  push(@cuboids,$cubo);
}


my($gen)=generator();

my($c1)=cuboid($gen);
my($c2)=cuboid($gen);

print Dumper $c1;
print Dumper $c2;

sub idx_div
{
  my($coord)=@_;
  return $coord*$divisions/($space+$width);
}


sub cuboid
{
  my($generator)=@_;
  my(@parameters)=();
  for(my($i)=0;$i<3;$i++)
  {
    push(@parameters,gen_next($generator)%$space);
  }
  for(my($i)=0;$i<3;$i++)
  {
    push(@parameters,1+gen_next($generator)%$width);
  }
  return \@parameters;
}

sub generator
{
  my($current)=0;
  my(@state)=();
  return [$current,\@state];
}

sub gen_next
{
  my($generator)=@_;
  $$generator[0]++;
  my($k)=$$generator[0];
  if($k <= 55)
  {
    push(@{$$generator[1]},(100003 - 200003*$k+300007*$k*$k*$k)%1000000);
    return $$generator[1][$k-1];
  }
  else
  {
    my($kidx)=($k-1)%55;
    my($other_idx)=($kidx-24+55)%55;
    $$generator[1][$kidx] += $$generator[1][$other_idx];
    return $$generator[1][$kidx];
  }
}

