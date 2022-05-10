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

my(%values)=(1=>{"1/1" => Fraction->new(1)});

my($n)=18;

for(my($i)=2;$i<=$n;$i++)
{
  my(%vals)=();
  for(my($j)=1;($i-$j) >= $j;$j++)
  {
    my($k)=$i-$j;
    foreach my $valj (values(%{$values{$j}}))
    {
      foreach my $valk (values(%{$values{$k}}))
      {
        my(@candidates)=();
        
        push(@candidates,$valj + $valk);
        push(@candidates,Fraction->new(1)/$valk + $valj);
        
        # if($j > 1)
        {
          push(@candidates,Fraction->new(1)/$valj + $valk);
        }
        {
          my($harmonic)=Fraction->new(1)/((Fraction->new(1))/$valj + Fraction->new(1)/$valk);
          if( $harmonic->numerator() < $harmonic->denominator() )
          {
            $harmonic = Fraction->new(1)/$harmonic;
          }
          push(@candidates,$harmonic);
        }

        foreach my $c (@candidates)
        {
          my($key)=Fraction::print_frac($c);
          my($found)=0;
          for(my($prev)=1;$prev<$i;$prev++)
          {
            if(exists($values{$prev}{$key}))
            {
              $found=1;
              last;
            }
          }
          $vals{$key}=$c unless($found);
        }
      }
    }
  }
  
  $values{$i} = \%vals;
  my(@num)=(keys(%vals));
  print "$i : ".($#num+1)."\n";
  # print Dumper \%vals;<STDIN>;  
}

