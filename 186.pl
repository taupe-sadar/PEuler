use strict;
use warnings;
use Data::Dumper;

my(@circular_seq)=();
my($circular_size)=55;
my($modulo)=1000000;
for(my($i)=1;$i<=$circular_size;$i++)
{
  push(@circular_seq,(100003-200003*$i+300007*($i**3))%$modulo);
}
my($k)=0;

while(1)
{
  my($n)=next_sk();
  # print $k." -> $n\n";
  if($n==524287)
  {
    print $k." -> $n\n";
    print"Found\n";
    <STDIN>;
  }
}

sub next_sk
{
  my($sk)=0;
  if($k < $circular_size)
  {
    $sk = $circular_seq[$k];
  }
  else
  {
    my($idx)=$k%$circular_size;
    my($nb)=($circular_seq[$idx]+$circular_seq[($k+31)%$circular_size])%$modulo;
    $sk = $circular_seq[$idx] = $nb;
  }
  $k++;
  return $sk;
}
