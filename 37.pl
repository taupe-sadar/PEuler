use strict;
use warnings;
use Data::Dumper;
use Prime;
use Hashtools;


my(@postfixes)=(2,3,5,7);
my(@prefixes)=(2,3,5,7);

my(@newpost);
my(@newpre);

my($count)=0;
my($sum)=0;
while($count<11)
{
  my(@newpost)=();
  my(@newpre)=();
  my(%hash)=();
  my($i,$j);
  for($i=0;$i<=$#postfixes;$i++)
  {
    my(@test)=(1,2,3,5,7,9);
    for($j=0;$j<=$#test;$j++)
    {
      my($number)=$test[$j].$postfixes[$i];
      if(Prime::is_prime($number))
      {
        if($test[$j]!=2)
        {
          push(@newpost,$number);
        }
        Hashtools::increment(\%hash,$number);
      }
    }
  }

  for($i=0;$i<=$#prefixes;$i++)
  {
    my(@test)=(1,3,5,7,9);
    for($j=0;$j<=$#test;$j++)
    {
      my($number)=$prefixes[$i].$test[$j];
      if(Prime::is_prime($number))
      {
        push(@newpre,$number);
        Hashtools::increment(\%hash,$number);
      }
    }
  }

  foreach $i (keys(%hash))
  {
    if($hash{$i}==2)
    {
      $count++;
      $sum+=$i;
    }
  }
  @postfixes=@newpost;
  @prefixes=@newpre;
}

print $sum;
