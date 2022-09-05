use strict;
use warnings;
use Data::Dumper;
use integer;

print power2_ways((5**5)**5,25); #means 5^25 * 2^25


sub power2_ways
{
  my($n,$zeros)=@_;
  $zeros = 0 if(!defined($zeros));
  
  my($nb)=$n;
  my($current_zeros)=$zeros;
  my(@zeros_binary_list)=();
  while($nb>0)
  {
    if(($nb & 0x1) == 0)
    {
      $current_zeros++;
    }
    else
    {
      unshift(@zeros_binary_list,$current_zeros);
      $current_zeros = 0;
    }
    $nb >>= 1;
  }

  my($f)=1;
  my($g)=1;

  for my $ai (@zeros_binary_list)
  {
    ($f,$g) = ($f + $ai*$g, $f + ($ai+1)*$g);
  }
  return $f;
}