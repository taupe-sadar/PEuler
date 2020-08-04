use strict;
use warnings;
use Data::Dumper;


my($sack)=200;

my(@tab)=(1);
my($a,$b,$c);

for($a=1;$a<=$sack;$a++)
{
  $tab[$a]=0;
  for($b=0;$b<=int($a/5);$b++)
  {
    my($reste)=$a-5*$b;
    $tab[$a]+=int($reste/2)+1;
  }
}

my(@tab10)=(1);
for($a=1;$a<=$sack;$a++)
{
  $tab10[$a]=0;
  for($b=0;$b<=int($a/10);$b++)
  {
    my($reste)=$a-10*$b;
    $tab10[$a]+=$tab[$b]*$tab[$reste];
  }
}

my(@tab100)=(1);
for($a=1;$a<=$sack;$a++)
{
  $tab100[$a]=0;
  for($b=0;$b<=int($a/100);$b++)
  {
    my($reste)=$a-100*$b;
    $tab100[$a]+=$tab10[$b]*$tab10[$reste];
  }
}

print $tab100[$sack];
