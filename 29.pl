use strict;
use warnings;
use Data::Dumper;
use Sums;

my($max)=100;

my(%powers)=();
my(@d_prod)=();
my($i)=0;
my($sum)=0;
my(@tab)=(0);
my(%hash)=();
for($i=2;$i<=$max;$i++)
{
  if(exists($powers{$i}))
  {
    next;
  }
  my($pow)=2;
  my($i_pow)=$i**$pow;
  while($i_pow<=$max)
  {
    $powers{$i_pow}=1;
    $pow++;
    $i_pow=$i**$pow;
  }
  if(!defined($d_prod[$pow-1]))
  {
    $d_prod[$pow-1]=dinstinct_prod($pow-1);
  }

  $sum+=$d_prod[$pow-1];
}

print $sum;
#Fonction indeplacable : depend de $max et @tab et %hash
sub dinstinct_prod #return card( {k*a / 2<=k<=max and 1<=a<=amax }) 
{
  my($amax)=@_;
  if($#tab<$amax)
  {
    my($a,$b);
    for($a=$#tab+1;$a<=$amax;$a++)
    {
      for($b=2;$b<=$max;$b++)
      {
        if(!exists($hash{$a*$b}))
        {
          $hash{$a*$b}=1;
        }
      }
      $tab[$a]=keys %hash;
    }
  }
  return $tab[$amax];
}
