use strict;
use warnings;
use Data::Dumper;
use Gcd;

my($radius)=105;

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
  # print $$rv{"num"}." ".$$rv{"ratio"}[0]."/".$$rv{"ratio"}[1]."\n"; <STDIN>;
  push(@ratios_occ,$$rv{"num"});
}
# print Dumper \@ratios_occ;

my($num_angles)=$#ratios_occ;

print "$num_angles\n";

my(@cumulated)=($ratios_occ[0]);
for(my($i)=1;$i<=4*$num_angles+1;$i++)
{
  push(@cumulated,$cumulated[-1] + get_occs($i));
}

my($all)=0;
for(my($high_angle)=2;$high_angle < 4*$num_angles; $high_angle++)
{
  my($prod_high)=get_occs($high_angle);
  # print "($high_angle) : $prod_high\n";
  for(my($low_angle)=0;$low_angle <= ($high_angle)-2; $low_angle++)
  {
    my($prod)=$prod_high * get_occs($low_angle,\@ratios_occ);
    # print "  ($low_angle) : $prod * ".(($cumulated[$high_angle-1] - $cumulated[$low_angle]))."\n";
    
    $prod *= ($cumulated[$high_angle-1] - $cumulated[$low_angle]);
    $all += $prod;
  }
}

print $all * 2;

sub get_occs
{
  my($angle,$roccs)=@_;
  if( $angle <= $num_angles )
  {
    return $ratios_occ[$angle];
  }
  elsif($angle <= 2*$num_angles)
  {
    return $ratios_occ[2*$num_angles - $angle];
  }
  elsif($angle <= 3*$num_angles)
  {
    return $ratios_occ[$angle - 2*$num_angles];
  }
  else
  {
    return $ratios_occ[4*$num_angles - $angle];
  }
}


sub sort_radius_fn
{
  return $$a{"ratio"}[0]* $$b{"ratio"}[1] <=> $$b{"ratio"}[0]*$$a{"ratio"}[1];
}