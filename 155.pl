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

my(%values)=(1=>[[Fraction->new(1),0,0]]);
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
          my($sum_frac)=$$valk[0] + $$valj[0]->inverse();
          my($key)=($sum_frac->numerator() >  $sum_frac->denominator())?Fraction::print_frac($sum_frac):Fraction::print_frac($sum_frac->inverse());
          
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
          my($sum_frac)=$$valk[0]->inverse() + $$valj[0]->inverse();
          my($key)=($sum_frac->numerator() >  $sum_frac->denominator())?Fraction::print_frac($sum_frac):Fraction::print_frac($sum_frac->inverse());
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

sub dual
{
  my($obj)=@_;
  if($$obj[0] eq '1')
  {
    return ['1'];
  }
  elsif($$obj[0] eq '+')
  {
    return ['o',dual($$obj[1]),dual($$obj[2])];
  }
  elsif($$obj[0] eq 'o')
  {
    return ['+',dual($$obj[1]),dual($$obj[2])];
  }
  
  die "Unexpected";  
}

sub print_obj
{
  my($obj)=@_;
  if($$obj[0] eq '1')
  {
    return '1';
  }
  elsif($$obj[0] eq '+')
  {
    return '('.print_obj($$obj[1]).' + '.print_obj($$obj[2]).')';
  }
  elsif($$obj[0] eq 'o')
  {
    return '('.print_obj($$obj[1]).' o '.print_obj($$obj[2]).')';
  }
  
}