#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Fraction;

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

my(%values)=(1=>[Fraction->new(1)]);
my(%known)=("1/1"=>1);
my($n)=18;

for(my($i)=2;$i<=$n;$i++)
{
  my(@vals)=();
  for(my($j)=1;($i-$j) >= $j;$j++)
  {
    print "  $j + ".($i-$j)." : ";
    my($news)=0;
    my($discards)=0;
    my($k)=$i-$j;
    foreach my $valj (@{$values{$j}})
    {
      foreach my $valk (@{$values{$k}})
      {
        my($sum)=$valj + $valk;
        my($h1)=$valk->inverse() + $valj;
        my($harmonic)=$valj->inverse() + $valk->inverse();
        if( $harmonic->numerator() < $harmonic->denominator() )
        {
          $harmonic = $harmonic->inverse();
        }
        my(@candidates)=($sum,$h1,$harmonic);
        
        if($j > 1)
        {
          push(@candidates,$valj->inverse() + $valk);
        }
        
        foreach my $c (@candidates)
        {
          my($key)=Fraction::print_frac($c);
          
          if(exists($known{$key}))
          {
            $discards++;
          }
          else
          {
            push(@vals,$c);
            $news++;
            $known{$key} = 1;
          }
        }
      }
    }
    print " news : $news, discards : $discards\n"; 
  }
  
  $values{$i} = \@vals;
  print "$i : ".($#vals+1)."\n";
  # print Dumper \%vals;<STDIN>;  
}

