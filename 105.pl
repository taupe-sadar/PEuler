use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum );

my($sum_of_special_sum_sets ) =0;
my(@non_parentheses_patterns)=([],[]);

open( FILE, "105_sets.txt" );
my($line)="";
while(defined($line=<FILE>))
{
  chomp($line);
  my(@set) = sort({$a<=>$b} split(',',$line));
  
  if( is_special_sum_set( \@set ) )
  {
    $sum_of_special_sum_sets += sum( @set );
  }
}
close( FILE );



print $sum_of_special_sum_sets;

sub is_special_sum_set
{
  my($rset)= @_;
  my($special)=0;
  
  if(  is_set_all_subset_increasing_for_sum( $rset ) )
  {
    if ( is_set_all_subset_sums_different( $rset ) )
    {
      $special = 1;
    }
  }
  return $special;
}

sub is_set_all_subset_increasing_for_sum
{
  my( $rset ) = @_;
  my($size)= $#$rset+1;
  my($subsize)=int( ($size -1)/2 );
  my($is_odd)= $size%2;
  my($s0) = sum( @$rset[0..$subsize] );
  my($s1) = sum( @$rset[($subsize+2-$is_odd)..$#$rset] );
  
  return ( $s0>$s1 );
}

sub is_set_all_subset_sums_different
{
  my( $rset ) = @_;
  my($size)= $#$rset+1;
  for(my($subsetsize)=2;$subsetsize<= int( $size/2); $subsetsize ++ )
  {
    if(!defined($non_parentheses_patterns[ $subsetsize ] ) )
    {
      build_non_parentheses_pattern( $subsetsize );
    }
    
    my($rparenthese_pattern_array)=$non_parentheses_patterns[ $subsetsize ];
    for( my($i)=0; $i<= $#$rparenthese_pattern_array; $i++ )
    {
      my(@subset_test)=init_subset_test( 2*$subsetsize );
      do
      {
        if( equality_subsets( $rset, $$rparenthese_pattern_array[$i], \@subset_test ) )
        {
          return 0;
        }
      }
      while( iterate_subsets( \@subset_test ,$size ) );
    }
  }
  return 1;
}

sub build_non_parentheses_pattern
{
  my($size)=@_;
  $non_parentheses_patterns[ $size ] = [];
  my(@t)=(0);
  recursive_build_non_parentheses_pattern( $size, 1,1, @t );
}

sub recursive_build_non_parentheses_pattern
{
  my( $size, $is_valid, $num_0 , @t ) = @_;
  if( $#t == 2*$size - 1) 
  {
    !$is_valid or die "Unvalid parenthese pattern\n";
    push( @{$non_parentheses_patterns[ $size ]}, \@t  );
  }
  else
  {
    if($is_valid && ($#t+1 > 2*$num_0 ) )
    {
      $is_valid = 0; 
    }
    
    if( $is_valid && $num_0 == $size -1 )
    {
      recursive_build_non_parentheses_pattern( $size, $is_valid, $num_0 , @t , 1 );
    }
    elsif( $num_0 == $size )
    {
      recursive_build_non_parentheses_pattern( $size, $is_valid, $num_0 , @t , 1 );
    }
    elsif( $#t + 1 - $num_0 == $size )
    {
      recursive_build_non_parentheses_pattern( $size, $is_valid, $num_0+1 , @t , 0 );
    }
    else
    {
      recursive_build_non_parentheses_pattern( $size, $is_valid, $num_0+1 , @t , 0 );
      recursive_build_non_parentheses_pattern( $size, $is_valid, $num_0 , @t , 1 );
    }
  }
}

sub init_subset_test
{
  my( $s ) = @_;
  my(@init)=();
  for(my($i)=0;$i<$s;$i++ )
  {
    push(@init,$i);
  }
  return @init;
}

sub iterate_subsets
{
  my( $rsubset_test ,$size ) = @_;
  my($max_value)= $size -1;
  
  for(my($idx) = $#$rsubset_test; $idx >=0; $idx --,$max_value-- )
  {
    if( $$rsubset_test[ $idx ] < $max_value )
    {
      my($new_value)= $$rsubset_test[ $idx ] + 1;
      for(my($j) = $idx; $j <= $#$rsubset_test; $j++, $new_value++  )
      {
        $$rsubset_test[ $j ] = $new_value;
      }
      return 1;
    }
  }
  return 0;
}

sub equality_subsets
{
  my( $rset, $rparenthese_pattern, $rsubset_test ) = @_;
  
  my($s0,$s1)=(0,0);
  for( my($i)= 0;$i<= $#$rsubset_test; $i++ )
  {
    if( $$rparenthese_pattern[$i] == 0 )
    {
      $s0 += $$rset[ $$rsubset_test[$i] ];
    }
    else
    {
      $s1 += $$rset[ $$rsubset_test[$i] ];
    }
  }
  return ($s0 == $s1);
}
