use strict;
use warnings;
use Data::Dumper;

use Hashtools;
use integer;

my($n)=10**11;
my($count)=0;
for(my($i)=2;$i<=10;$i++)
{
  $count+= ulam_2_2k1(2*$i+1,$n-1);
}
print $count;

sub ulam_2_2k1
{
  my($v,$idx)=@_;
  
  my($mask)=(1<<($v+1))-1;
  my($state)=$mask;
  my($ulam)=$v;
  
  my(@list)=();
  
  my($left)=$state & 0x1;
  my($shift)=$state >> $v;
  $state = (($state << 1) | ($left^$shift))& $mask;
  if( $shift == 1 )
  {
    push(@list,$ulam);
  }
  $ulam += 2;

  while($state != $mask)
  {
    $left = $state & 0x1;
    $shift=$state >> $v;
    $state = (($state << 1) | ($left^$shift))& $mask;
    if( $shift == 1 )
    {
      push(@list,$ulam);
    }
    $ulam += 2;
  }
  my($period) = $ulam - $list[0];
  my($num) = $#list + 1;
  
  if($idx == 0)
  {
    return 2;
  }
  elsif($idx == ($v+5)/2)
  {
    return 2 * $v + 2;
  }
  
  #Counting the two even numbers
  my( $fix ) = ($idx < $v)? -1 : -2;
  
  my($value)= ($idx/$num)*$period + $list[$idx%$num + $fix] ;
  return $value;
}

