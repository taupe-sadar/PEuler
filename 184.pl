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
for(my($i)=1;$i<2*$num_angles;$i++)
{
  push(@cumulated,$cumulated[-1] + get_occs($i));
}

my($sum_period)=$cumulated[2*$num_angles-1];

my($all)=0;
for(my($high_angle)=0;$high_angle < 2*$num_angles; $high_angle++)
{
  my($prod_high)=get_occs($high_angle);
  # print "($high_angle) : $prod_high\n";
  for(my($low_angle)=0;$low_angle < 2*$num_angles; $low_angle++)
  {
    my($prod)=$prod_high * get_occs($low_angle);
    
    # my($prod_low) = get_occs($low_angle,\@ratios_occ);
    # print "  ($low_angle) : $prod_low\n";
    
    
    if( $high_angle > $low_angle )
    {
      my($diff) = ($cumulated[$high_angle-1] - $cumulated[$low_angle]);
      $prod *= $diff*3 + $sum_period;
      
    }
    else
    {
      
      my($diff) = ($high_angle > 0) ? $cumulated[$high_angle-1]:0;
      $diff += $sum_period - $cumulated[$low_angle];
      $prod *= $diff;
      
    }
    
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
  else
  {
    return $ratios_occ[2*$num_angles - $angle];
  }
}


sub sort_radius_fn
{
  return $$a{"ratio"}[0]* $$b{"ratio"}[1] <=> $$b{"ratio"}[0]*$$a{"ratio"}[1];
}