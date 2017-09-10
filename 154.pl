use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );


my($p)=5;
my($n)=200000;

my($ndecomposed)=dec_base( $n, $p );

# my($target_div)=12;

my(%hash)=();

for(my($i)=0; $i < 1000; $i++ )
{
  my($rdec)=dec_base($i,10);
 
  my($x)=0;
  for( my($j)=0; $j<= $#$rdec ; $j++)
  {
    $x+= $$rdec[ $j ]; 
  }
  
  $hash{$x} =  0 if(!exists($hash{$x}));
  $hash{$x}++;
} 



for( my($i)=-3; $i <= 30 ; $i++ )
{
  $hash{$i} =  0 if(!exists($hash{$i}));
  print "$i $hash{$i} ".num_triplets_terms($i,0,9)."\n";
}

sub list_divisors_pascal_pyramid
{
  my($ndec,$base)=@_;
  
  for( my($i)=0;$i<= $#$ndec; $i++ )
  {
    my($max_carry)=($i==0)?0:2;
    for( my($k)=0; $k<= $max_carry; $k++ )
    {
      my($max_carry_end)=($i==$#$ndec)?0:2;
      for( my($m)=0; $m<= $max_carry_end; $m++ )
      {
        my($num)= num_triplets_terms( $m * $base - $k, 0 , $base -1 );
      }
    }
  }
}

sub num_triplets_terms
{
  my($n,$low,$high)=@_;
  
  my($l_min)=max($low,$n-2*$high);
  my($l_max)=min($high,$n-2*$low);
  
  my($l0)=$n - $low - $high;
  my($l0_1)=min( $l0, $l_max );
  my($l0_2)=max( $l0+1, $l_min );
  
  
  my($num)=0;
  $num+= max( 0, $l0_1 - $l_min + 1 ) * ($l_min - ($n - 2*$high) + 1 +  $l0_1 -($n -2*$high) + 1  ) /2;
  $num+= max( 0, $l_max - $l0_2 + 1 ) * (($n - 2*$low) - $l_max + 1 + ($n -2*$low) - $l0_2+ 1  ) /2;
  return $num # A tester
}

sub dec_base
{
  my($n,$p)=@_;
  use integer;
  my(@dec)=();
  while( $n > 0 )
  {
    push(@dec,$n%$p);
    $n=$n/$p;
  }
  return \@dec;
}

# print_pascal(22);

sub print_pascal
{
  my($n)=@_;
  my(@rtab)=([1]);

  for(my($rec)=0;$rec<$n;$rec++)
  {
    push(@rtab,[1]); #new  = [$rec+1][-1] + [rec][0]
    for(my($k)=1;$k<=$rec;$k++)
    {
      push(@{$rtab[$k]},$rtab[$rec+1-$k][$k-1] + $rtab[$rec-$k][$k] );
    }
    push(@{$rtab[0]},$rtab[0][$rec]);
    
    for(my($j)=$rec;$j>0;$j--)
    {
      for(my($k)=$rec-$j;$k>0;$k--)
      {
        $rtab[$j][$k] += $rtab[$j-1][$k] + $rtab[$j][$k - 1];
      }
      $rtab[$j][0] += $rtab[$j-1][0] ;
    }
    
    for(my($k)=$rec;$k>0;$k--)
    {
      $rtab[0][$k] += $rtab[0][$k - 1];
    }
  }

  #printing
  my($max_length)=0;
  for(my($j)=0;$j<=$#rtab;$j++)
  {
    for(my($k)=0;$k<=$#{$rtab[$j]};$k++)
    {
      if( length($rtab[$j][$k]) > $max_length)
      {
        $max_length = length($rtab[$j][$k]);
      }
    }
  }

  for(my($j)=$#rtab;$j>=0;$j--)
  {
    for(my($k)=0;$k<=$#{$rtab[$j]};$k++)
    {
      print sprintf("%$max_length"."s",$rtab[$j][$k])." ";
    }
    print "\n";
  }
  
  
  
}
