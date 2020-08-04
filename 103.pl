use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum );
use POSIX qw/floor ceil/;
use Sums;

# We consider here special sum sets starting with 0:
# (0 , a1, .., an, an+1, .. , a2n)
# (0 , a1, .., an, A , an+1, .. , a2n)
# and search for all of these sets, those which satisfy the non-equality condition.
#
# With on of these subset we can buil all subsets starting with constant "K" 
# (K , K+a1, .., K+ an-1, ...
# If K is too low, the set doesnt satisfy the inegality condition
# There exist an optimal K, Kopt which minimise the sum of the subset, respecting the inequality condition
# With 
# s0 = a1 + .. + an
# s1 = an+1 + .. + a2n
# Kopt * n + s0 = Kopt * ( n - 1)  + s1 + 1
# Kopt = s1 - s0 + 1
#
# We can associate an optimal sum to special set starting with 0 :
# Sopt = Kopt* (2n+1) + s0 + s1 = (2n+2)*s1 - (2n)*s0 + 2n+1
# Sopt = Kopt* (2n+2) + s0 + s1 + A = (2n+3)*s1 - (2n+1)*s0 + 2n+2 + A
#
 
my($n)=7;

my($nsub)= int( ($n-1) / 2);
my($parity)= $n%2;

my( $curent_min ) = "";
my( @best_set ) = ();
my( @curent_set)= (0);
my( @subset_sums)=( );

for( my($i)=2;$i<=$nsub;$i++)
{
  $subset_sums[$i] = [];  
}

find_recursively_special_sum_sets( $curent_min , \@curent_set, \@subset_sums, \@best_set );
 
print join("",@best_set);

sub find_recursively_special_sum_sets
{
  my( $curr_min, $rcurr_set, $rsubset_sums,$rbest_set )=@_;
  
  if( $#$rcurr_set + 1 == $n)
  {
    my($rs)= real_sum( @$rcurr_set ) ;
    $curr_min eq "" or $rs <= $curr_min or die "Invalid new min $rs > $curr_min \n";
    my($s0,$s1,$a,$offset)= get_s0_s1_a_offset($rcurr_set);
    for(my($i)=0;$i< $n; $i++ )
    {
      $$rbest_set[$i] = $$rcurr_set[$i]+$offset;
    }
    return $rs;
  }
  else
  {
    my($low)=$$rcurr_set[-1] + 1;
    my($high)= calculate_max( $rcurr_set, $curr_min );
    
    my($loop_found_better)= 0;
    for( my($nb) = $low; $high eq "max" || $nb<= $high; $nb ++ )
    {
      my(@new_set)= ( @$rcurr_set, $nb );
      my($is_special , $radditional_sum_sets ) = is_special_sum_set( $rsubset_sums, @new_set );
      if( $is_special )
      {
        my( @all_subsets )  = ( @$rsubset_sums,$radditional_sum_sets); 
        my($found_better) = find_recursively_special_sum_sets( $curr_min, \@new_set, \@all_subsets, $rbest_set);

        if( $found_better > 0 )
        {
          $high = calculate_max( $rcurr_set, $found_better );
          
          $curr_min = $found_better;
          $loop_found_better = 1;
        }
      }
    }
    
    if( $loop_found_better )
    {
      return $curr_min;
    }
    else
    {
      return 0;
    }
  }
}

sub real_sum
{
  my(@set) = @_;
  my($s0,$s1,$a,$offset) = get_s0_s1_a_offset( \@set );
  
  return ($offset * $n + $s0 + $s1 + ($parity==1 ? 0 : $set[$nsub+1]) );
}

sub get_s0_s1_a_offset
{
  my($rarray)=@_;
  my($s0) = sum( (@$rarray)[0..$nsub ] ); 
  my($s1) = sum( (@$rarray)[($nsub+ 2 - $parity)..$#$rarray] );
  my($a ) = ($parity==1 ? 0 : $$rarray[$nsub+1] );
  my($offset) = $s1 - $s0 +1;
  return ($s0,$s1,$a,$offset);
}

sub calculate_max
{
  my( $rset, $curr_min) = @_;
  if( $curr_min eq "" )
  {
     return "max";
  }
  else
  {
    my($idx)=$#$rset + 1;
    my($lastvalue)=$$rset[-1];
    
    my(@set_simulated)= @$rset;
    
    for(my($i) = $idx; $i < $n; $i++ )
    {
      $set_simulated[ $i ] = $lastvalue+1;
      $lastvalue ++;
    }
    
    my($minimal_sum_reachable) = real_sum( @set_simulated );
    
    #Delta represents the additional value to add to the reachable sum if we increase lastvalue by 1
    my($delta) = 0;
    #Influence in $s0
    if( $idx <= $nsub )
    {
      $delta -= ($nsub + 1 - $idx)*($n - 1); 
      $idx = $nsub+1;
    }
    #Influence in $a (if any)
    if( $parity == 0 && $idx == $nsub +1 )
    {
      $delta ++;
      $idx ++;
    }
    #Influence in $s1 (if any)
    $delta += ($n - $idx) * ($n + 1 );
    
    return floor( ( $curr_min - $minimal_sum_reachable ) / $delta ) + $set_simulated[$#$rset+1];
   }
}

sub is_special_sum_set
{
  my( $rsubsets, @set )=@_;
  
  my( @additional_sum_set) = ();
  
  # Testing 2-uplets

  my( @set2uplet )=();  
  for( my($a)=0; $a <= ($#set-1); $a++ )
  {
    my($s)= $set[$a] + $set[-1];
    if( is_in_sum_sets( $s, 0, $rsubsets ) )
    {
      return 0;
    }
    push( @set2uplet, $s); 
  }
  push (@additional_sum_set, \@set2uplet);
  
  # Testing highest-uplets
  my($highest_subset)= int($n/2);
  for( my($subset_size)= 3; $subset_size <= $highest_subset; $subset_size++ )
  {
    my($idx_known_sums)= $subset_size - 3;
    my($idx_sums_to_compare)= $subset_size - 2;
    my( @setnuplet ) =();
    for( my($a)=0; $a <= $#$rsubsets; $a++ )
    {
      for( my($b)=0; $b <= $#{$$rsubsets[$a][$idx_known_sums]}; $b++ )
      {
        my($s)= $$rsubsets[$a][$idx_known_sums][$b] + $set[-1];
        if( is_in_sum_sets( $s, $idx_sums_to_compare , $rsubsets ) )
        {
          return 0;
        }
        push( @setnuplet, $s); 
      }
    }
    push (@additional_sum_set, \@setnuplet);
  }

  return (1, \@additional_sum_set );
}

sub is_in_sum_sets
{
  my( $sum, $idx, $refset )=@_;
  for( my($a)=0; $a <= $#$refset; $a++ )
  {
    for( my($b)=0; $b <= $#{$$refset[$a][$idx]}; $b++ )
    {
      if( $$refset[$a][$idx][$b] == $sum)
      {
        return 1;
      }
    }
  }
  return 0;
}
