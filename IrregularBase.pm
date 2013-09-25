package IrregularBase;
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );

sub new
{
  my ($class,$rbase,$rinit) = @_;
  my $this = {};
  bless($this, $class);
  $this->{"base"} = [ @$rbase ];
  $this->{"max"}  = [ map( {$_ - 1} @$rbase) ];
  $this->{"nb"}   = [ @$rinit ];
  for(my($i)=$#$rinit+1;$i<=$#$rbase;$i++)
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
  
  for(my($i)=0;$i<= $#{$$this{"base"}}; $i++)
  {
    $opposite[$i] = $$this{"max"}[$i] - $$this{"nb"}[$i];
  }
  return IrregularBase->new( $$this{"base"}, \@opposite ) ;
}

sub use_nb_as_base
{
  my( $this )=@_;
  my( $base_max ) = $#{$$this{"base"}};
  for(my($i)=$base_max;$i>= 0; $i--)
  {
    if( $$this{"nb"}[ $i ] == 0 )
    {
      
    }
  }
}

sub compare
{
  my( $this, $other_irregular ) = @_;
  my( $max_el ) = min( $#{$$this{"base"}}, $#{$$other_irregular{"base"}} ) ;
  for( my($i)=$max_el;$i>= 0; $i-- )
  {
    return 1 if $$this{"nb"}[$i] > $$other_irregular{"nb"}[$i];
    return -1 if $$this{"nb"}[$i]< $$other_irregular{"nb"}[$i];
  }
  return 0;
}

sub clone
{
  my( $this ) = @_;
  return IrregularBase->new( $$this{"base"}, $$this{"nb"} ) ;
}


1;
