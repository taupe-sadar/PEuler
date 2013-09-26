package IrregularBase;
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );

sub new
{
  my ($class,$rmax,$rinit) = @_;
  my $this = {};
  bless($this, $class);
  $this->{"max"}  = [ @$rmax ];
  $this->{"nb"}   = [ @$rinit ];
  for(my($i)=$#$rinit+1;$i<=$#$rmax;$i++)
  {
    $$this{"nb"}[ $i ] = 0 ;
  }
  return $this;
}

sub iterate
{
  my($this)=@_;
  my($i)=0;
  while( $i <= $#{$$this{"max"}} )
  {
    if(  $$this{"nb"}[$i] < $$this{"max"}[$i] )
    {
      $$this{"nb"}[$i]++;
      return 1;
    }
    else
    {
      $i++;
    }
  }
  return 0;
}


sub uniterate
{
  my($this)=@_;
  my($i)=0;
  while( $i <= $#{$$this{"max"}} )
  {
    if(  $$this{"nb"}[$i] > 0 )
    {
      $$this{"nb"}[$i]--;
      return 1;
    }
    else
    {
      $$this{"nb"}[$i] = $$this{"max"}[$i] ;
      $i++;
    }
  }
  return 0;
}

sub get_nb
{
  my( $this ) = @_;
  return @{$$this{"nb"}};
}

sub opposite
{
  my( $this )=@_;
  my( @opposite ) = ();
  
  for(my($i)=0;$i<= $#{$$this{"max"}}; $i++)
  {
    $opposite[$i] = $$this{"max"}[$i] - $$this{"nb"}[$i];
  }
  return IrregularBase->new( $$this{"max"}, \@opposite ) ;
}

sub use_nb_as_base
{
  my( $this )=@_;
  my( $last_non_nul_idx ) = $#{$$this{"max"}};
   
  $last_non_nul_idx-- while( $$this{"nb"}[$last_non_nul_idx]  == 0);
  if( $last_non_nul_idx < $#{$$this{"max"}} )
  {
    splice( @{$$this{"nb"}}, $last_non_nul_idx + 1 );
  }
  
  @{$$this{"max"}} = @{$$this{"nb"}};
}

sub compare
{
  my( $this, $other_irregular ) = @_;
  
  my( $this_last, $other_last ) = ( $#{$$this{"max"}}, $#{$$other_irregular{"max"}} );
  
  my( $max_common_el ) = max( $this_last, $other_last ) ;
  
  for( my($i)=$max_common_el;$i>= 0; $i-- )
  {
    return 1 if( $i > $other_last && $$this{"nb"}[$i] > 0 );
    return -1 if( $i > $this_last && $$other_irregular{"nb"}[$i] > 0 );
    return 1 if $$this{"nb"}[$i] > $$other_irregular{"nb"}[$i];
    return -1 if $$this{"nb"}[$i]< $$other_irregular{"nb"}[$i];
  }
  return 0;
}

sub clone
{
  my( $this ) = @_;
  return IrregularBase->new( $$this{"max"}, $$this{"nb"} ) ;
}


1;
