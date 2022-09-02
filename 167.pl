use strict;
use warnings;
use Data::Dumper;
use integer;

# In order to calculate ulam sequences, two properties must be proved
#   1) If an ulam sequence has only finite even terms, the sequence is periodic
#   2) For init values (2,v), with v = 2k + 1 (k >= 5) there are only 2 even terms
# These are proven in research papers (Finch 1992) and (Schmerl,Fpiegel 1994)
#
# As part of the proof, and the methodology to determine the sequence elements,
# We can notice that
#  1) (2,2v + 2) are the 2 only even terms, therefore
#  2) An odd term x is part of the sequence iff 
#    (x - 2) is part of the sequence XOR (x - (2v + 2)) is part of the sequence
#  3) Then an algorithm may use a circular state of the (v+1) elements 
#     [ x(n), x(n+2), ... , x(n + 2v) ] in order to compute all elements
#  
# This implementation use a binary representation for the previous state, where x(n-2) 
# is the highest bit, for example (v=5) 0b100011 means that only x(n-2) x(n-10) x(n-12) 
# are part of the sequence.
# Then the algorithm left shifts this state, gathering x(n) on the left, creating x(n + 2v + 2)
# on the right.
# once the initial state is reached for the first time, we have the period, and then we can compute 
# any term

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

