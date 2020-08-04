use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use List::Util qw( max min );

my($min_diff)="-1";
my($pentagonal)=1;
my(@tab_pentagonal)=(0);
my(%hash_pentagonal)=();
my($n)=1;
while($min_diff==-1) 
{
  for(my($j)=$#tab_pentagonal-1;$j>0;$j--)
  {
    my($diff)=$pentagonal-$tab_pentagonal[$j];
    if(exists($hash_pentagonal{$diff}))
    {
      my($sum)=$pentagonal+$tab_pentagonal[$j];
      my($ksum)=ceil(sqrt(2*$sum/3));
      if($sum==($ksum*(3*$ksum-1)/2))
      {
        $min_diff = $diff;
      }
    }
  }
  push(@tab_pentagonal,$pentagonal);
  $hash_pentagonal{$pentagonal}=1;
  $n++;
  $pentagonal+=(3*$n-2);
}
my(@limits)=(0);
my($size_lim)=calc_limit();

for(my($interval_idx)=$size_lim;$interval_idx>0;$interval_idx--)
{
  my($change) = ($interval_idx==$size_lim)?process_interval_classic($interval_idx):process_interval_fast($interval_idx);
  if($change)
  {
    $size_lim=calc_limit();
    $interval_idx = $size_lim;
  }
}
print $min_diff;

sub process_interval_classic
{
  my($inter)=@_;
  while($n < $limits[$inter] )
  {
    for(my($j)=$#tab_pentagonal-1;$j>0;$j--)
    {
      my($diff)=$pentagonal-$tab_pentagonal[$j];
      if($min_diff<$diff)
      {
        last;
      }
      if(exists($hash_pentagonal{$diff}))
      {
        my($sum)=$pentagonal+$tab_pentagonal[$j];
        my($ksum)=ceil(sqrt(2*$sum/3));
        if($sum==($ksum*(3*$ksum-1)/2))
        {
          if($min_diff > $diff)
          {
            $min_diff = $diff;
            return 1;
          }
        }
      }
    }
    push(@tab_pentagonal,$pentagonal);
    $hash_pentagonal{$pentagonal}=1;
    $n++;
    $pentagonal+=(3*$n-2);
  }
  return 0;
}

sub process_interval_fast
{
  my($inter)=@_;
  while($n < $limits[$inter] )
  {
    for(my($k)=1;$k<=$inter;$k++)
    {
      my($diff)=$pentagonal-$tab_pentagonal[$n-$k];
      if($min_diff<$diff)
      {
        last;
      } 
      if(exists($hash_pentagonal{$diff}))
      {
        my($sum)=$pentagonal+$tab_pentagonal[$n-$k];
        my($ksum)=ceil(sqrt(2*$sum/3));
        if($sum==($ksum*(3*$ksum-1)/2))
        {
          if($min_diff > $diff)
          {
            $min_diff = $diff;
            return 1;
          }
        }
      }
    }
    push(@tab_pentagonal,$pentagonal);
    $hash_pentagonal{$pentagonal}=1;
    $n++;
    $pentagonal+=(3*$n-2);
  }
  return 0;
}

sub calc_limit
{
  my($size_tab)=min(100,floor(sqrt(2*$min_diff/3)));
  
  for(my($i)=1;$i<=$size_tab;$i++)
  {
    my($current)=floor((3*$i+1)/6+($min_diff/(3*$i)));
    if(($i>1)&&($current>=$limits[$i-1])&&($current<=$n))
    {
      $size_tab=$i-1;
      last;
    }
    else
    {
      $limits[$i]=$current;
    }
  }
  return $size_tab;
}
