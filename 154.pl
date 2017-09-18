use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );

my($nb)=200000;

my($ndecomposed_5)=dec_base( $nb, 5 );
my($ndecomposed_2)=dec_base( $nb, 2 );

my(%cache_num_triplets_5)=();
my(%cache_num_triplets_2)=();

my($target_div)=12;

my($nodiv_5,$div_5)= list_divisors_pascal_pyramid( $ndecomposed_5, 5 );
my($nodiv_2,$div_2)= list_divisors_pascal_pyramid( $ndecomposed_2, 5 );

sub list_divisors_pascal_pyramid
{
  my($ndec,$base)=@_;
  
  my($cache)={"min" => 0, "max"=> $base-1,"values" => []};
  
  my(%states)=(0=>{0=>1},1=>{},2=>{});
  
  for( my($i)=0;$i<= $#$ndec; $i++ )
  {
    my(%current_state)=%states;
    %states=(0=>{},1=>{},2=>{});
    
    my($max_carry)=($i==0)?0:2;
    for( my($k)=0; $k<= $max_carry; $k++ )
    {
      my($rstate)=$current_state{$k};
        
      my($max_carry_end)=($i==$#$ndec)?0:2;
      for( my($m)=0; $m<= $max_carry_end; $m++ )
      {
        my($num) = cache_nt( $cache, $m * $base + $$ndec[$i] - $k );
        
        foreach my $ncarry (keys(%$rstate))
        {
          my($carr)= $ncarry + $k;
          if( !exists($states{$m}{$carr}) )
          {
            $states{$m}{$carr} = 0;
          }
          $states{$m}{$carr} += $num * $$rstate{$ncarry};
        }
        
      }
    }
  }
  
  my($num_nodiv,$num_div)=(0,0);
  foreach my $k (keys(%{$states{0}}))
  {
    if( $k < $target_div )
    {
      $num_nodiv+=$states{0}{$k};
    }
    else
    {
      $num_div+=$states{0}{$k};
    }
  }
  return  ($num_nodiv,$num_div);
}

sub cache_nt
{
  my($cache, $n)=@_;
  if( !exists($$cache{$n}  ))
  {
    $$cache{$n} = num_triplets_terms( $n, $$cache{"min"}, $$cache{"max"} );
  }
  return $$cache{$n};
}


sub cache_nt5
{
  my($n)=@_;
  if( !exists($cache_num_triplets_5{$n}  ))
  {
    $cache_num_triplets_5{$n} = num_triplets_terms( $n, 0, 4 );
  }
  return $cache_num_triplets_5{$n};
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
  return $num;
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
