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

# for( my($i)=0;$i<5;$i++)
# {
# print (join(" ",@{$pattern[$i]})."\n");
# }
# exit(0);

my(@adjacents)=([-1,-1],[-1,0],[-1,1],[1,-1],[1,0],[1,1]);
my(@cand_triplets)=();
my(%prime_links)=();
for(my($k)=0;$k<$prod;$k++)
{
  if($pattern[2][$k] == 0)
  {
    my(@adjs)=find_adj(\@pattern,2,$k,$prod);
    if($#adjs == 1 )
    {
      my(@neighbors)=("2-$k","$adjs[0][0]-$adjs[0][1]","$adjs[1][0]-$adjs[1][1]");
      push(@cand_triplets,[[2,$k],[$adjs[0][0],$adjs[0][1]],[$adjs[1][0],$adjs[1][1]]]);
      foreach my $n (@neighbors)
      {
        $prime_links{$n} = [] if( !exists($prime_links{$n}) );
        push(@{$prime_links{$n}},$#cand_triplets);
      }
    }
    elsif( $#adjs > 1 )
    {
      die "Not supported";
    }
    
    foreach my $a (@adjs)
    {
      my(@next_adj)=find_adj(\@pattern,$$a[0],$$a[1],$prod);
      foreach my $b (@next_adj)
      {
        if(!( $$b[0] == 2 && $$b[1] == $k ))
        {
          my(@neighbors)=("2-$k","$$a[0]-$$a[1]","$$b[0]-$$b[1]");
          push(@cand_triplets,[[2,$k],[$$a[0],$$a[1]],[$$b[0],$$b[1]]]);
          # print Dumper \@neighbors;<STDIN>;
          foreach my $n (@neighbors)
          {
            $prime_links{$n} = [] if( !exists($prime_links{$n}) );
            push(@{$prime_links{$n}},$#cand_triplets);
            
          }
          # print Dumper \%prime_links;
          
        }
      }
    }
  }
}
# print Dumper \@cand_triplets;
# <STDIN>;
print Dumper \%prime_links;
print Dumper $prime_links{"2-16"};
# <STDIN>;
# print Dumper $prime_links


print "$prod\n";
# print Dumper \@pattern;



sub find_adj
{
  my($rpattern,$x,$y,$max)=@_;
  my(@result)=();
  foreach my $a (@adjacents)
  {
    my(@neighbor)=($x + $$a[0], $y + $$a[1]);
    next if($neighbor[0]<0);
    next if($neighbor[0]>=5);
    my(@test)=@neighbor;
    
    $test[0] += $max if($test[1]<0);
    $test[0] -= $max if($test[1]>=$max);
    
    if($$rpattern[$test[0]][$test[1]] == 0)
    {
      push(@result,\@neighbor);
    }
  }
  return (@result);
}

