use strict;
use warnings;
use Data::Dumper;
use Palindrome;
use List::Util qw( max min );
use Math::BigInt;

my($max_number)=10000;
my($max_iterations)=50;
my(%iterations)=();
my(%known_iterations)=();
my($count)=0;


for(my($i)=$max_number-1;$i>=0;$i--)
{
  my($it)=iterations_lychrel($i,0);
  if($it>=$max_iterations)
  {
    $count++;
  }
}
print $count;

sub iterations_lychrel
{
  my($number,$depth)=@_;
  if(exists($iterations{$number}))
  {
    return $iterations{$number};
  }
  elsif(($depth+1)>=$max_iterations)
  {
    $known_iterations{$number}=1;
    return 1;
  }
  elsif(exists($known_iterations{$number}))
  {
    if(($depth+$known_iterations{$number})>=$max_iterations)
    {
      return $known_iterations{$number};
    }
  }
  
  my($rev)=join("",reverse(split(//,$number)));
  my($itered);
  if(length($number)>=14)
  {
    my($big)=Math::BigInt->new($number);
    $big=$big+$rev;
    $itered=$big->bstr();
  }
  else
  {
    $itered=$number+$rev;
  }
  
  if(Palindrome::is_palindromic($itered))
  {
    return 1;
  }
  elsif($itered<$max_number)
  {
    my($iters)=min($max_iterations,1+iterations_lychrel($itered,0));
    $iterations{$number}= $iters;
    return $iters;
  }
  else
  {
    my($iters)=min($max_iterations,1+iterations_lychrel($itered,$depth+1));
    $known_iterations{$number}= $iters;
    return $iters; 
  }
}
