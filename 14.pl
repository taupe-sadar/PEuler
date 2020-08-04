use strict;
use Data::Dumper;

my(%hash_syracuse)=(1 => 1);
my($limit)=1000000;

my($start_number);
my($max)=1;
my($client)=(1);

for($start_number=2;$start_number<$limit;$start_number++)
{
  my($m)=get_length($start_number);
  if($m>=$max)
  {
    $max=$m;
    $client=$start_number;
  }
}

sub get_length
{
  my($number)=@_;
  my($steps)=0;
  while(!($number%2))
  {
    $number/=2;
    $steps++;
  }
  if(exists($hash_syracuse{$number}))
  {
    return $steps + $hash_syracuse{$number};
  }
  else
  {
    my($val)=get_length((3*$number + 1)/2)+2;
    $hash_syracuse{$number}=$val;
    return $val+$steps;
  }
}

print $client;