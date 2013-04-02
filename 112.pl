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
  return -1;
}  

sub seek_ratio_dichotomy_interval
{
  my( $min, $max, $scale )=@_;
  my($middle)= int( ($min+$max)/2);
  if( $middle > $min )
  {
    
  }
}

sub ratio_possibly_reached
{
  my($min,$max)=@_;
  my($bouncy_min,$bouncy_max)=( Bouncy::count_bouncy( $min ), Bouncy::count_bouncy( $max ) );
  return ( ($bouncy_min + $bouncy_max)*100 >= ( $min + $bouncy_max ) * $target_percentage );
}

sub ratio_order
{
  my($n)=@_;
  return Bouncy::count_bouncy( $n )*100 <=> $n* $target_percentage )
}