use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );

my($nb)=200000;

my($ndecomposed_5)=dec_base( $nb, 5 );
my($ndecomposed_2)=dec_base( $nb, 2 );

print Dumper $ndecomposed_5;
print Dumper $ndecomposed_2;

#Implem naive :
my(@pows_5)=(1);
while( $pows_5[-1] < $nb )
{
  push(@pows_5, 5 * $pows_5[-1] );
}
my(@pows_2)=(1);
while( $pows_2[-1] < $nb )
{
  push(@pows_2, 2 * $pows_2[-1] );
}


my(@counts5)=(0,0,0,0,0,0,0,0);
my(@counts2)=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

for( my($k)=0; $k <= $nb; $k++ )
{
  my($pval_5) = 0;
  for( my($i) = 1; $i <= $#pows_5; $i++ )
  {
    # last if( $pows_5[$i] > $k );
    $pval_5 ++ if( ($nb % $pows_5[$i]) < ($k % $pows_5[$i]) );
  }

  $counts5[$pval_5]++;

  my($pval_2) = 0;
  for( my($i) = 1; $i <= $#pows_2; $i++ )
  {
    # last if( $pows_2[$i] > $k );
    $pval_2 ++ if( ($nb % $pows_2[$i]) < ($k % $pows_2[$i]) );
  }    
  
  $counts2[$pval_2]++;
  
  # for( my($m)=0; $m <= $k; $m++ )
  # {
    
  # }
}

print Dumper \@counts5;
print Dumper \@counts2;

(@counts5)=(1,0,0,0,0,0,0,0);
(@counts2)=(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

my($big_p_5)=0;
my($big_p_2)=0;

my($curr_p5)=0;
my($curr_p2)=0;

for( my($i)=0;$i < $nb; $i++ )
{
  my($curr_i) = $i + 1;
  my($remv_i) = $nb - $i;
  
  my($pv_5) = pv($remv_i,5) - pv($curr_i,5);
  my($pv_2) = pv($remv_i,2) - pv($curr_i,2);
  $curr_p5 += $pv_5;
  $curr_p2 += $pv_2;
  
  if( $curr_p5 <0 )
  {
    print "Error : ($i) curr_p5 : $curr_p5\n";<STDIN>;
  }
  if( $curr_p2 <0 )
  {
    print "Error : ($i) curr_p2 : $curr_p2\n";<STDIN>;
  }
  
  $counts5[$curr_p5]++;
  $counts2[$curr_p2]++;
}

print Dumper \@counts5;
print Dumper \@counts2;

sub pv
{
  my($n,$p)=@_;
  return 0 if( $n == 0 );
  my($count)=0;
  while( ($n % $p) == 0 )
  {
    $count++;
    $n/=$p;
  }
  return $count;
}





exit(0);





my(%cache_num_triplets_5)=();
my(%cache_num_triplets_2)=();

my($target_div)=12;

my($nodiv_5,$div_5)= list_divisors_pascal_pyramid( $ndecomposed_5, 5 );
my($nodiv_2,$div_2)= list_divisors_pascal_pyramid( $ndecomposed_2, 5 );


my($cnk_div_5)=calc_cnk_div($ndecomposed_5,5,5,12);


sub calc_cnk_div
{
  my($ndec,$p,$min_requiered_exp,$max_requiered_exp)=@_;
  my($size)=$#$ndec+1;
  my($val)=0;
  my($current_state)=[0]x($size);
  my($current_carry)=[0]x($size+1);
  my($current_num_carry)=0;
  
  get_next_state(  ); 
  
  return {};
}

# sub get_next_state
# {
  # my($ndec, $st, $car, $min, $max, $p )=@_;
  
  # increment_state( $st, $p );
  # my($sum_carry) = update_carry( $ndec, $st, $car );
  
  # my( $missing_carry ) = $sum_carry - $min;
  # my( $exedent_carry ) = $max - $sum_carry;
  
  # if( $missing_carry > 0 )
  # {
    # $sum_carry = next_more_carry( $ndec, $st, $car, $missing_carry, $p );
  # }
  # elsif( $exedent_carry > 0 )
  # {
    # $sum_carry = next_less_carry( $ndec, $st, $car, $exedent_carry, $p )
  # }
  
  # my($increased)= $ncar < $min;
  # if( $need_reach_min )
  # {
    # my($idx)=1;
    # while( $ncar < $min )
    # {
      # if( $$st[$idx] == 0 )
      # {
        # $$st[$idx++] = 1;
        # $ncar++;
      # }
    # }
  # }
  
  # if( !$increased )
  # {
  
  # }
  
  
  # if( $increased )
  # {
    # Having lowest
    # my($new_st)=[0]x($#$st+1);
    
    # for( my($i)=0; $i<=$#$st; $i++ )
    # {
      # my($target)= $$car[$i+1] * $p + $$st[$i] - $$car[$i];
      
      # TODO move elsewhere, better
      # my(@array_bourrin)=(0,0,0,0,0,1,2,3,4,-1); #sentinel, for both  cases -1 and 2p-1 
      
      # $$new_st[$i] = $array_bourrin[$target]; 
      # if( $$new_st[$i] < 0 )
      # {
        # Argh : find next carry iteration
      # }
      
    # }
    # return $new_st;
  # }
# }

# sub next_more_carry
# {
  # my($ndec, $st, $car, $missing_carry, $p ) = @_;
  
  
# }

# sub next_less_carry
# {
  # my($ndec, $st, $car, $exedent_carry, $p ) = @_;
  
  
# }

# sub increment_state
# {
  # my($rstate, $p)=@_;
  # $$rstate[0]++;
  # for( my($i)=0; $i <= $#$rstate; $i++ )
  # {
    # if( $rstate[$i] == $p )
    # {
      # $rstate[$i] = 0;
      # $rstate[$i+1]++;
    # }
    # else
    # {
      # last;
    # }
  # }
# }

# sub update_carry
# {
  # my( $ndec, $rstate, $car )=@_;
  # $$car[0]=0;
  # my($count)=0;
  # for( my($i)=0; $i <= $#$rstate; $i++ )
  # {
    # if( $$ndec[$i] < ($$rstate[$i]+ $$car[$i]) )
    # {
      # $$car[$i+1] = 1;
      # $count++;
    # }
  # }
  # return $count;
# }

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

# sub cache_nt
# {
  # my($cache, $n)=@_;
  # if( !exists($$cache{$n}  ))
  # {
    # $$cache{$n} = num_triplets_terms( $n, $$cache{"min"}, $$cache{"max"} );
  # }
  # return $$cache{$n};
# }


# sub cache_nt5
# {
  # my($n)=@_;
  # if( !exists($cache_num_triplets_5{$n}  ))
  # {
    # $cache_num_triplets_5{$n} = num_triplets_terms( $n, 0, 4 );
  # }
  # return $cache_num_triplets_5{$n};
# }


# sub num_triplets_terms
# {
  # my($n,$low,$high)=@_;
  
  # my($l_min)=max($low,$n-2*$high);
  # my($l_max)=min($high,$n-2*$low);
  
  # my($l0)=$n - $low - $high;
  # my($l0_1)=min( $l0, $l_max );
  # my($l0_2)=max( $l0+1, $l_min );
  
  
  # my($num)=0;
  # $num+= max( 0, $l0_1 - $l_min + 1 ) * ($l_min - ($n - 2*$high) + 1 +  $l0_1 -($n -2*$high) + 1  ) /2;
  # $num+= max( 0, $l_max - $l0_2 + 1 ) * (($n - 2*$low) - $l_max + 1 + ($n -2*$low) - $l0_2+ 1  ) /2;
  # return $num;
# }

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
