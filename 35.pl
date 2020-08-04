use strict;
use warnings;
use Data::Dumper;
use Prime;

my($max)=1000000;

Prime::init_crible(1000100);
my($sum)=0;
#On enleve 2 il est trop chiant
my($p)=Prime::next_prime();
$sum++;
$p=Prime::next_prime();
my(%circulars)=();
while($p<$max)
{
  if(($p=~m/0/)||($p=~m/2/)||($p=~m/4/)||($p=~m/6/)||($p=~m/8/))
  {
    $p=Prime::next_prime();
    next;
  }
  if(exists($circulars{$p}))
  {
    $p=Prime::next_prime();
    next;
  }
  my($l)=length($p);
  my($pp)=$p;
  my(%hash_circ)=();
  my($stop)=0;
  my($k);
    
  for($k=0;$k<$l;$k++)
  {
    if(Prime::is_prime($pp))
    {
      $hash_circ{$pp}=1;
    }
    else
    {
      $stop=1;
      last;
    }
  
    $pp=~m/^(\d)(.*)$/;
    $pp="$2$1";
  }
  
  if(!$stop)
  {
    foreach $k (keys(%hash_circ))
    {
      $circulars{$k}=1;
      $sum++;
    }
  }
  $p=Prime::next_prime();
}

print $sum;

