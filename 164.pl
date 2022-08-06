use strict;
use warnings;
use Data::Dumper;
use Hashtools;

my($n)=20;
my($exp)=3;
my($sum_max)=9;

my($rtrans)=build_transitions();

my($rstates)=();

for my $s (keys(%$rtrans))
{
  if($s=~m/^0/)
  {
    $$rstates{$s}=0;
  }
  else
  {
    $$rstates{$s}=1;
  }
}

for(my($i)=$exp+1;$i<=$n;$i++)
{
  $rstates = apply_transitions($rstates);
}

my($sum_all)=@_;
for my $v (values(%$rstates))
{
  $sum_all += $v;
}
print $sum_all;

sub build_transitions
{
  my(%states)=();
  for(my($i)=0;$i<10**$exp;$i++)
  {
    my(@digits)=();
    my($nb)=$i;
    my($sum)=0;
    for(my($j)=0;$j<$exp;$j++)
    {
      my($left)=$nb%10;
      unshift(@digits,$nb%10);
      $nb = ($nb - $left)/10;
      $sum += $left;
    }
    
    if($sum <= $sum_max)
    {
      my(@nexts)=();
      my($state)=join("",@digits);
      my($sum_new)=$sum - $digits[0];
      my($new_state)=join("",@digits[1..$exp-1]);
      for(my($j)=0;$j<=($sum_max - $sum_new);$j++)
      {
        push(@nexts,$new_state."$j");
      }
      $states{$state} = \@nexts;
    }
  }
  return \%states;
}

sub apply_transitions
{
  my($rstates)=@_;
  my(%new_states)=();
  for my $s (keys(%$rstates))
  {
    foreach my $next (@{$$rtrans{$s}})
    {
      Hashtools::increment(\%new_states,$next,$$rstates{$s});
    }
  }
  return \%new_states;
}