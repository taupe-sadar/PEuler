use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

my( $nb_of_digits ) = 4;
my( %remember_all_calcs )=();

my( $string_best ) = "";
my( $highest_best)= -1;

loop_all_operations_on_strictly_ascending_numbers( $nb_of_digits );

print $string_best;

sub loop_all_operations_on_strictly_ascending_numbers
{
  my( $max_digits, @digits )=@_;
  if( $#digits < 0 )
  {
    for( my($i)=0;$i <= 9; $i ++ )
    {
      my($ret )= loop_all_operations_on_strictly_ascending_numbers( $max_digits , @digits, $i );
      if( $ret )
      {
        if ( $i == 0)
        {
          return 1;
        }
        last;
      }
    }
  }
  elsif( $#digits +1 < $max_digits )
  {
    if( $digits[-1] == 9 )
    {
      return 1;
    }
    else
    {
      for( my($i)=$digits[-1]+1;$i <= 9; $i ++ )
      {
        my($ret) = loop_all_operations_on_strictly_ascending_numbers( $max_digits , @digits, $i );
        if( $ret )
        {
          if ( $i == $digits[-1] + 1 )
          {
            return 1
          }
          last;
        }
      }
    }
  }
  else
  {
    my($rreachables)= all_operations( @digits );
    my($highest) = highest_consecutive( $rreachables );
    if( $highest > $highest_best )
    {
      $highest_best = $highest;
      $string_best = join("",@digits);
    }
  }
  return 0;
}

sub all_operations
{
  my( @set_of_digits)=@_;
  my( $sdigits) = join( "", @set_of_digits );
  if( !exists( $remember_all_calcs{ $sdigits } ) )
  {
    my($rtab_of_subsets)= list_all_subset_pairs( \@set_of_digits  );
    my(%calc_list)=();
    for( my($entry)= 0; $entry <= $#$rtab_of_subsets ; $entry++)
    {
      my( @subset1) = @{$$rtab_of_subsets[$entry][0]};
      my( @subset2) = @{$$rtab_of_subsets[$entry][1]};
      my( $rreachable_numbers1)=();
      my( $rreachable_numbers2)=();
      if( $#subset1 == 0 )
      {
        $rreachable_numbers1={ $subset1[0] => 1 };
      }
      else
      {
        $rreachable_numbers1= all_operations ( @subset1 );
      }
      
      if( $#subset2 == 0 )
      {
        $rreachable_numbers2={ $subset2[0] => 1 };
      }
      else
      {
        $rreachable_numbers2= all_operations ( @subset2 );
      }
      operate_add( \%calc_list,  $rreachable_numbers1, $rreachable_numbers2 );
      operate_minus( \%calc_list,  $rreachable_numbers1, $rreachable_numbers2 );
      operate_minus( \%calc_list,  $rreachable_numbers2, $rreachable_numbers1 );
      operate_multiply( \%calc_list,  $rreachable_numbers1, $rreachable_numbers2 );
      operate_divide( \%calc_list,  $rreachable_numbers1, $rreachable_numbers2 );
      operate_divide( \%calc_list,  $rreachable_numbers2, $rreachable_numbers1 );
    }
    $remember_all_calcs{ $sdigits } = \%calc_list;
  }

  return $remember_all_calcs{ $sdigits };
}

sub list_all_subset_pairs
{
  my( $rset )=@_;
  my( @list)=();
  if( $#$rset == 1 )
  {
    push( @list, [ [ $$rset[0] ], [ $$rset[1] ] ] ); 
  }
  else # assuming @$rest cannot be shorter than 2 elements
  {
    my(@subset)=@$rset;
    my($first)=shift( @subset );
    my($rsublist) = list_all_subset_pairs( \@subset );
    my(@firstsubset)=($first);
    push( @list, [ \@firstsubset , \@subset ]);
    for( my($entry)= 0; $entry <= $#$rsublist; $entry++)
    {
      my( @tab1) = @{$$rsublist[ $entry ][0]}; 
      my( @tab2) = @{$$rsublist[ $entry ][1]}; 
      my( @tab3) = ($first , @tab1);
      my( @tab4) = ($first , @tab2);
         
      push( @list, [ \@tab3 , \@tab2 ]) ;
      push( @list, [ \@tab4 , \@tab1 ]);
    }
  }
  return \@list;
}

sub highest_consecutive
{
  my($rnumbers)=@_;
  my($i)=0;
  while( 1 ) #lol
  {
    $i++;
    if( !exists( $$rnumbers{ $i } ) )
    {
      last;
    }
  }
  return ($i -1);
}

sub operate_add
{
  my($rh,$r1,$r2)=@_;
  my($k1,$k2)=();
  foreach $k1 (keys(%$r1))
  {
    foreach $k2 (keys(%$r2))
    {
      $$rh{ $k1 + $k2 } = 1;
    }
  }
}

sub operate_minus
{
  my($rh,$r1,$r2)=@_;
  
  my($k1,$k2)=();
  foreach $k1 (keys(%$r1))
  {
    foreach $k2 (keys(%$r2))
    {
      if( $k1 - $k2 >=0 )
      {
        $$rh{ $k1 - $k2 } = 1;
      }
    }
  }
}

sub operate_multiply
{
  my($rh,$r1,$r2)=@_;
  
  my($k1,$k2)=();
  foreach $k1 (keys(%$r1))
  {
    foreach $k2 (keys(%$r2))
    {
      $$rh{ $k1 * $k2 } = 1;
    }
  }
}

sub operate_divide
{
  my($rh,$r1,$r2)=@_;
  my($k1,$k2)=();
  foreach $k1 (keys(%$r1))
  {
    foreach $k2 (keys(%$r2))
    {
      if( $k2 != 0 )
      {
        $$rh{ $k1/$k2 } = 1;
      }
    }
  }
}
