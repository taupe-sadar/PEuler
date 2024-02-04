#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor ceil/;
use List::Util qw( sum );
use Permutations;

# Using p-valuations of cnks, and storing the value in a double array

my($first_rows)=51;
my($n)=$first_rows-1;

Prime::init_crible($n+100);

my(@pascal_array)=();
for(my($i)=0;$i<=$n;$i++)
{
  my(@line)=(0)x (floor($i/2)+1);
  push(@pascal_array,\@line);
}

my($p)=Prime::next_prime();
while($p <= sqrt($n))
{
  for(my($i)=$p*$p;$i<=$n;$i++)
  {  
    my($ipval)=Prime::fact_p_valuation($i,$p);
    
    for(my($j)=0;$j<=floor($i/2);$j++)
    {
      next if( $pascal_array[$i][$j] == 1);
      my($pval)=$ipval - Prime::fact_p_valuation($j,$p) - Prime::fact_p_valuation($i-$j,$p);
      my($a,$b)=(Prime::fact_p_valuation($j,$p),Prime::fact_p_valuation($i-$j,$p));
      
      $pascal_array[$i][$j] = 1 if($pval>=2);
    }
  }
  $p=Prime::next_prime();
}
my(%unique_cnk)=();
for(my($i)=0;$i<=$n;$i++)
{
  for(my($j)=0;$j<=floor($i/2);$j++)
  {
    if($pascal_array[$i][$j] == 0)
    {
      my($x)=Permutations::cnk($i,$j);
      $unique_cnk{$x}=1;
    }
  }
}
my($count)=sum(keys(%unique_cnk));
print $count;



