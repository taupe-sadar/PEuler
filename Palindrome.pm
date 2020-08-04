package Palindrome;
use strict;
use warnings;
use Data::Dumper;

sub is_palindromic
{
  my($n)=@_;
  my($reverse_n)=join("",reverse(split(//,$n)));
  return ($n == $reverse_n);
}

sub binary_palindromic
{
  my($n)=@_;
  my(@tt)=();
  while($n>0)
  {
    my($r)=$n%2;
    push(@tt,$r);
    $n=($n-$r)/2;
  }
  my($a);
  my($l)=int(($#tt+1)/2);
  for($a=0;$a<$l;$a++)
  {
    if($tt[$a]!=$tt[$#tt-$a])
    {
      return 0;
    }
  }
  return 1;
}
1;
