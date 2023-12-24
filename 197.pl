#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor/;

my($un)=-1;

for(my($i)=0;$i<1005;$i++)
{
  $un=floor(2**(30.403243784-$un*$un))*10**-9;
  print "$i : $un\n";
}
