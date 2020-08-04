use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );

my(@prod)=(1,10,100,1000,10000,100000,1000000);

my($max)=max(@prod);
my(@start)=();
my($nchiffres)=1;
my($number)=1;
while($number<=$max)
{
  push(@start,$number);
  $number+=$nchiffres*9*(10**($nchiffres-1));
  $nchiffres++;
}
push(@start,$number);

my($i);
my($produit)=1;
for($i=0;$i<=$#prod;$i++)
{
  my($idx)=find_interval($prod[$i]);
  my($diff)=$prod[$i]-$start[$idx-1];
  my($unit)=$diff%$idx;
  my($integer)=($diff-$unit)/$idx;
  $integer+=10**($idx-1);
  my(@digits)=split(//,$integer);
  $produit*=$digits[$unit];
}

print $produit;

sub find_interval
{
  my($n)=@_;
  my($j);
  for($j=1;$j<=$#start;$j++)
  {
    if($start[$j]>=$n)
    {
      return $j;
    }
  }
}
