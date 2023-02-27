use strict;
use warnings;
use Data::Dumper;
use Gcd;

# 3   : 360
# 5   : 10600
# 7   : 111368
# 10  : 1101232
# 15  : 13638120
# 21  : 104845792
# 50  : 19879613488
# 100 : 1288029912888
# 105 : 1725323624056


my($radius)=3;

my(%ratios)=("0/1" => {"num"=> $radius-1, "ratio" => [0,1]});

my($y)=1;
my($sqy)=$y*$y;
my($sqradius)=$radius*$radius;
while( 2*$sqy < $sqradius )
{
  my($x)=$y;
  while($x*$x + $sqy < $sqradius)
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
  $sqy=$y*$y;
}

my(@ratios_occ)=();
foreach my $rv (sort sort_radius_fn values(%ratios))
{
  push(@ratios_occ,$$rv{"num"});
}

my($num_angles)=$#ratios_occ;

# print "$num_angles\n";

my($sum,$squares,$cubes)=(0,0,0);
for(my($i)=1;$i<$#ratios_occ;$i++)
{
  my($x)=$ratios_occ[$i];
  my($xx) = $x*$x;
  $sum+=$x;
  $squares+=$xx;
  $cubes+=$xx*$x;
}
my($S)=$sum*4 + $ratios_occ[0]*2 + $ratios_occ[-1]*2;
my($Q)=$squares*4 + $ratios_occ[0]*$ratios_occ[0]*2 + $ratios_occ[-1]*$ratios_occ[-1]*2;
my($C)=$cubes*4 + $ratios_occ[0]*$ratios_occ[0]*$ratios_occ[0]*2 + $ratios_occ[-1]*$ratios_occ[-1]*$ratios_occ[-1]*2;

my($all) = (( $S * $S -3 * $Q )*$S + 2 * $C)/6 * 2;

print $all;

sub sort_radius_fn
{
  return $$a{"ratio"}[0]* $$b{"ratio"}[1] <=> $$b{"ratio"}[0]*$$a{"ratio"}[1];
}