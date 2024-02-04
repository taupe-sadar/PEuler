#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use EulerTotient;

# my($S)=11;
# my($S)=1000001;
my($S)=12017639147;

my($n)=($S+3)/2;

my($parity)=$n%3;

my($count)=0;
if( $parity != 0 )
{
  my(%dec)=Prime::decompose($n);
  my($num_1mod3)=0;
  my($num_2mod3)=0;
  foreach my $p (keys(%dec))
  {
    if($p%3==1)
    {
      $num_1mod3 ++;
    }
    else
    {
      $num_2mod3 ++;
    }
  }
  my($extra)=($num_1mod3==0)?(1<<$num_2mod3):0;
  $count= 1/3*(EulerTotient::phi($n) + ($parity==1?(-1):1)*($extra));
}

print $count;
