use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use Prime;

my($n);
for($n=7654321;$n>=1234567;$n-=2)
{
  if(test_pandigital($n))
  {
    if(Prime::fast_is_prime($n))
    {
      last;
    }
  }
}

print $n;

sub test_pandigital
{
  my($num)=@_;
  if($num=~m/0/)
  {
    return 0;
  }
  my($j);
  for($j=9;$j>length($num);$j--)
  {
    if($num=~m/$j/)
    {
      return 0;
    }
  }
  my(%hash)=();
  my(@t)=split(//,$num);
  my($i);
  for($i=0;$i<=$#t;$i++)
  {
    Hashtools::increment(\%hash,$t[$i]);
  }
  return (keys(%hash)==length($num));
}
