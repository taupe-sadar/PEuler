#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;

my($n)=10000;

my(@first_primes)=(2,3,5,7,11,13);
my($prod)=1;
for(my($i)=0;$i<=$#first_primes;$i++)
{
  $prod*=$first_primes[$i];
}

my(@pattern)=();
for(my($i)=-2;$i<=2;$i++)
{
  my(@neighbor_pattern)=(0)x($prod);
  my($base)=($n-1+$i)*($n+$i)/2 + 1;
  my($end)=$base + $n-1 +$i;
  for(my($j)=0;$j<=$#first_primes;$j++)
  {
    my($p)=$first_primes[$j];
    my($rem)=$base%$p;
    my($div_start)=($rem==0)?0:($p-$rem);
    for(my($mult)=$div_start;$mult<$prod;$mult+=$p)
    {
      $neighbor_pattern[$mult]=1;
    }
  }
  push(@pattern,\@neighbor_pattern);
}

my(@adjacents)=([-1,-1],[-1,0],[-1,1],[1,-1],[1,0],[1,1]);
my(@prime_groups)=();
for(my($k)=0;$k<$prod;$k++)
{
  my(@group)=();
  my(%all)=();
  if($pattern[2][$k] == 0 )
  {
    my(@adjs)=find_adj(\@pattern,2,$k,$prod);
  }
}

sub find_adj
{
  my($rpattern,$x,$y,$max)=@_;
  my(@result)=();
  foreach my $a (@adjacents)
  {
    my(@neighbor)=($x + $$a[0], $y + $$a[1]);
    next if($neighbor[1]<0);
    next if($neighbor[1]>=5);
    my(@test)=@neighbor;
    $test[0] += $max if($test[0]<0);
    $test[0] -= $max if($test[0]>=0);
    if($rpattern[$test[0]][$test[1]] == 0)
    {
      push(@result,\@neighbor);
    }
  }
}

# print (join(" ",@{$pattern[$i+2]})."\n");

print "$prod\n";
# print Dumper \@pattern;
