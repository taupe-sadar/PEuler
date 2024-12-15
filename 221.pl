use strict;
use warnings;
use Data::Dumper;
use Prime;
use Divisors;


my($p)=2;

while($p < 1000)
{
  my($frac)=$p*$p + 1;
  my(%dec)=Prime::decompose($frac);
  print "$p : $frac (".join(' x ',keys(%dec)).")\n";

  my(@divs)=Prime::all_divisors_no_larger(\%dec,$p);
  # print Dumper \@divs;
  for(my($i)=0;$i<=$#divs;$i++)
  {
    my($r)=$p - $divs[$i];
    my($q)=$frac/$divs[$i] - $p;
    my($a)=$p*$q*$r;
    print "---> $p $q $r => $a\n";
  }

  
  <STDIN>;
  $p++;
}