#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

 # For reminder
 # 2 : 2
 # 3 : 4
 # 4 : 8
 # 5 : 20
 # 6 : 42
 # 7 : 102
 # 8 : 250
 # 9 : 610
 # 10 : 1486
 # 11 : 3710
 # 12 : 9228
 # 13 : 23050
 # 14 : 57718
 # 15 : 145288
 # 16 : 365820
 # 17 : 922194
 # 18 : 2327914

my(%values)=(1=>[[[1,1],0,0]]);
my(%known)=("1/1"=>1);
my($n)=18;
my($count)=1;

for(my($i)=2;$i<=$n;$i++)
{
  my(@vals)=();
  for(my($j)=1;($i-$j) >= $j;$j++)
  {
    my($news)=0;
    my($discards)=0;
    my($skipped)=0;
    my($k)=$i-$j;
    foreach my $valk (@{$values{$k}})
    {
      for(my($a)=0;$a<= ($#{$values{$j}}); $a++)
      {
        my($valj)=$values{$j}[$a];
        if($$valj[1] <= $$valk[2] )
        {
          my($sum_frac)=add($$valk[0],inv($$valj[0]));
          my($key)=($$sum_frac[0] > $$sum_frac[1])?print_frac($sum_frac):print_frac(inv($sum_frac));
          if(exists($known{$key}))
          {
            $discards++;
          }
          else
          {
            push(@vals,[$sum_frac,$count++,$$valj[1]]);
            $news++;
            $known{$key} = 1;
          }
        }
        else
        {
          $skipped+= $#{$values{$j}} - $a +1 ;
          last;
        }
      }
      for(my($a)=0;$a<= ($#{$values{$j}}); $a++)
      {
        my($valj)=$values{$j}[$a];
        if($$valj[1] <= $$valk[1] )
        {
          my($sum_frac)=add(inv($$valk[0]),inv($$valj[0]));
          my($key)=($$sum_frac[0] > $$sum_frac[1])?print_frac($sum_frac):print_frac(inv($sum_frac));
          if(exists($known{$key}))
          {
            $discards++;
          }
          else
          {
            push(@vals,[$sum_frac,$count++,$$valj[1]]);
            $news++;
            $known{$key} = 1;
          }
        }
        else
        {
          $skipped+= $#{$values{$j}} - $a +1 ;
          last;
        }
      }
    }
    print "  $j + ".($i-$j)." : news : $news, discards : $discards, skip : $skipped\n";
  }
  
  $values{$i} = \@vals;
  print "$i : ".($#vals+1)."\n";
}

sub add
{
  my($f,$g)=@_;
  my($res)=[$$f[0]*$$g[1] + $$f[1]*$$g[0],$$f[1]*$$g[1]];
  reduce($res);
  return $res;
}

sub reduce
{
  my($f)=@_;
  my($a)=($$f[0]>$$f[1])?$$f[0]:$$f[1];
  my($b)=($$f[0]>$$f[1])?$$f[1]:$$f[0];
  while($b >0 )
  {
    my($r)=$a%$b;
    $a=$b;
    $b=$r;
  }
  $$f[0] = $$f[0]/$a;
  $$f[1] = $$f[1]/$a;
}

sub inv
{
  my($f)=@_;
  my($res)=[$$f[1],$$f[0]];
  return $res;  
}

sub print_frac
{
  my($f)=@_;
  return "$$f[0]/$$f[1]";
}
