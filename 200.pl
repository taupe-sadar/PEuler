#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/ceil/;

# No real optimisation.
# Only progressively raising the limit of squbes, with some idx system,
# in order to stop when the number of squbes is enough large

my($sqube_nb)=200;
my($limit_possible)=10**16;
my($limit_crible)=ceil(($limit_possible/8)**(1/2));

Prime::init_crible($limit_crible+1000);

my(@primes)=();
my(@squbes)=();
my($limit_sqube)=10**4;
my($p)=Prime::next_prime();
while($#squbes+1 < $sqube_nb)
{
  my($limit_p)=ceil(($limit_sqube/8)**(1/2));
  while($p < $limit_p)
  {
    push(@primes,[0,$p*$p,$p*$p*$p]);
    $p=Prime::next_prime();
  }
  search_more_squbes(\@primes,\@squbes,$limit_sqube);
  $limit_sqube*=5;
}
@squbes=sort({$a <=> $b}@squbes);

print $squbes[$sqube_nb-1];

sub search_more_squbes
{
  my($rprimes,$rsqubes,$limit_max)=@_;
  for(my($i)=0;$i<=$#$rprimes;$i++)
  {
    my($pi,$j_start)=@{$$rprimes[$i]};
    my($pi3)=$$rprimes[$i][2];
    for(my($j)=$j_start;$j<=$#$rprimes;$j++)
    {
      next if($j==$i);
      my($sqube)=$pi3*$$rprimes[$j][1];
      
      if( $sqube <= $limit_max )
      {
        push(@$rsqubes,$sqube) if(valid_sqube($sqube));
      }
      else
      {
        $$rprimes[$i][1] = $j;
        last;
      }
      
      if($j == $#$rprimes)
      {
        $$rprimes[$i][1] = $#$rprimes+1;
      }
    }
  }
}

sub valid_sqube
{
  my($x)=@_;
  return 0 unless($x=~m/200/);
  my(@digits)=split(//,$x);
  my($pow)=1;
  for(my($d)=$#digits;$d>=0;$d--)
  {
    my($current_digit)=$digits[$d];
    for(my($v)=0;$v<=9;$v++)
    {
      next if($current_digit==$v);
      return 0 if(Prime::is_prime($x-($current_digit - $v)*$pow));
    }
    $pow*=10;
  }
  return 1;
}
