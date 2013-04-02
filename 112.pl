use strict;
use warnings;
use Data::Dumper;
use Bouncy;
#no warnings 'recursion';
# print Bouncy::count_bouncy_power10( 100 );

my(%store_bouncy)=( 100 => 0);

my($target_percentage)=99;

my($power10)=2;
my($ratio_found)=-1;
while( $ratio_found == -1 )
{
  $ratio_found = seek_ratio_dichotomy_geometrical( $power10 );
  $power10++;
}

print $ratio_found;

sub seek_ratio_dichotomy_geometrical
{
  my($minpower)=@_;
  my($min)= 10**$minpower;
  my($max)= $min*10;
  if( ratio_possibly_reached( $min,$max) )
  {
    return seek_ratio_dichotomy_interval( 1, 10, $minpower );
  }
  if( ratio_order( $max ) == 0)
  {
    return $max;
  }
  return -1;
}  

sub seek_ratio_dichotomy_interval
{
  my( $min, $max, $scale )=@_;
  my($middle)= int( ($min+$max)/2);
  if( $scale == 0 )
  {
    for( my($i)=$min+1; $i < $max; $i++ )
    {
      if( ratio_order($i) == 0 )
      {
        return $i;
      }
    }
  }
  else
  {
    my($middle)= int(($min+$max)/2);
    my($power)= 10**$scale;
    
    if( $middle == $min )
    {
      my($found) = seek_ratio_dichotomy_interval( $min*10 , $max*10, $scale - 1 );
      return $found if( $found>=0 );
    }
    else
    {
      if( ratio_possibly_reached( $min*$power, $middle*$power ) )
      {
        my($found) = seek_ratio_dichotomy_interval( $min , $middle, $scale );
        return $found if( $found>=0 );
      }
      if( ratio_order( $middle*$power ) == 0 )
      {
        return $middle*$power;
      }
      if( ratio_possibly_reached( $middle*$power, $max*$power ) )
      {
        my($found) = seek_ratio_dichotomy_interval( $middle , $max, $scale );
        return $found if( $found>=0 );
      }

    }
  }
  return -1;
}

sub ratio_possibly_reached
{
  my($min,$max)=@_;
  my($bouncy_min,$bouncy_max)=( Bouncy::count_bouncy( $min ), Bouncy::count_bouncy( $max ) );
  
  
  return ( $bouncy_max * 100 >= ( $min + $bouncy_max - $bouncy_min  ) * $target_percentage ) 
      || ( $bouncy_min * 100 >= ( $max - $bouncy_max + $bouncy_min  ) * $target_percentage );
  
}

sub ratio_order
{
  my($n)=@_;
  return ((Bouncy::count_bouncy( $n )*100) <=> ($n* $target_percentage ));
}
