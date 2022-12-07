use strict;
use warnings;
use Data::Dumper;
use Gcd;

my($radius)=5;

my(%ratios)=("0/1" => {"num"=> $radius-1, "ratio" => [0,1]});

my($y)=1;
while( 2*$y*$y < $radius*$radius )
{
  my($x)=$y;
  while($x*$x + $y*$y < $radius*$radius)
  {
    my($d)=Gcd::pgcd($x,$y);
    my($numerator,$denominator)=($y/$d,$x/$d);
    my($key)="$numerator/$denominator";
    if(!exists($ratios{$key}))
    {
      $ratios{$key} = {"num"=> 0, "ratio" => [$numerator,$denominator]};
    }
    $ratios{$key}{"num"}++;
    $x++;
  }
  $y++;
}

my(@ratios_occ)=();
foreach my $rv (sort sort_radius_fn values(%ratios))
{
  print $$rv{"num"}."\n";
  push(@ratios_occ,$$rv{"num"});
}


sub sort_radius_fn
{
  
  print Dumper $ra;<STDIN>;
  
  return $$ra{"ratio"}[0]* $$rb{"ratio"}[1] <=> $$rb{"ratio"}[0]*$$ra{"ratio"}[1];
}