#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use POSIX qw/floor/;

# First calculation of the distribution of probabilities of possible values
# with the given sets of dices (9 dices face 4, 6 dices faces 6)
#
# Let F be the random variable of sum of fours, and S the random variable of sum of sixes
# Then the probability that event A = "fours win againts sixes" is
# P(A) = P( F > S ) 
#      = sum_i( P(F = i) and P(S < i)) 
#      = sum_i P(F = i) * sum_{ j < i } P(S = j) 

my($precision)=10**7;

my($fours)=dice_distribution(9,4);
my($denom_fours)=4**9;
my($sixes)=dice_distribution(6,6);
my($denom_sixes)=6**6;

my($all_denom) = $denom_fours * $denom_sixes;

my(%cumul_six)=();
my($cumul)=0;
foreach my $v (sort({$a<=>$b}(keys(%$sixes))))
{
  $cumul_six{$v}=$cumul;
  $cumul+=$$sixes{$v};
}

my($sum_proba)=0;
foreach my $v (sort({$a<=>$b}(keys(%$fours))))
{
  $sum_proba += $$fours{$v} * $cumul_six{$v};
}
my($round)=floor($sum_proba/$all_denom * $precision + 0.5)/$precision;
print $round;

sub dice_distribution
{
  my($num_dices,$num_faces)=@_;
  my($distribution)={0=>1};
  for(my($i)=0;$i<$num_dices;$i++)
  {
    my(%distr)=();
    for(my($j)=1;$j<=$num_faces;$j++)
    {
      foreach my $v (keys(%$distribution))
      {
        Hashtools::increment(\%distr,$v+$j,$$distribution{$v});
      }
    }
    $distribution = \%distr;
  }
  return $distribution;
}
