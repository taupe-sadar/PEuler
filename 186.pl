use strict;
use warnings;
use Data::Dumper;

# The reolution use groups. 
# for each call :
# - if none of the callers have been called, a group of 2 people is created
# - if only one has never been called, he is added to the other's group
# - if both already are in different groups, the groups are merged into one.


my($prime_minister)=524287;
my($prime_minister_group)=-1;
my($modulo)=1000000;
my($stop_condition)=$modulo *99 /100;

my(@circular_seq)=();
my($circular_size)=55;
for(my($i)=1;$i<=$circular_size;$i++)
{
  push(@circular_seq,(100003-200003*$i+300007*($i**3))%$modulo);
}
my($k)=0;

my(%adresses)=();

my($next_group_id)=0;
my(%groups)=();

my($called)=0;
my($max_size)=0;

my($call)=0;
while($prime_minister_group < 0 || ($#{$groups{$prime_minister_group}} + 1) <$stop_condition)
{
  my($s1)=next_sk();
  my($s2)=next_sk();
  
  next if $s1 == $s2;
  
  my($know1,$know2)=(exists($adresses{$s1}),exists($adresses{$s2}));
  if( !$know1 && !$know2 )
  {
    $adresses{$s1}=$next_group_id;
    $adresses{$s2}=$next_group_id;
    $groups{$next_group_id++} = [$s1,$s2];
    $called+=2;
    $max_size = 2 if($max_size < 2);
  }
  elsif( $know1 && $know2 )
  {
    my($g1,$g2)=($adresses{$s1},$adresses{$s2});
    
    if( $g1 != $g2 )
    {
      if($#{$groups{$g1}} < $#{$groups{$g2}} )
      {
        ($g1,$g2) = ($g2,$g1);
      }
 
      my($size1,$size2)=($#{$groups{$g1}} + 1 ,  $#{$groups{$g2}} + 1 );

      foreach my $s (@{$groups{$g2}})
      {
        $adresses{$s} = $g1;
        push(@{$groups{$g1}},$s);
      }
      delete $groups{$g2};
      $max_size = $size1+$size2 if($max_size < $size1+$size2);
    }
  }
  else
  {
    my($sknow,$snew)=$know1?($s1,$s2):($s2,$s1);
    my($group)=$adresses{$sknow};
    $adresses{$snew}=$group;
    push(@{$groups{$group}},$snew);
    $called++;
    $max_size = $#{$groups{$group}} if($max_size < $#{$groups{$group}});
  }
  
  if($call%100000 == 99999)
  {
    my $groups = keys %groups;
    # print "Called : $called, groups : $groups, max : $max_size\n";
  }
  
  # print $k." -> $n\n";
  
  for my $s ($s1,$s2)
  {
    if( $s==$prime_minister )
    {
      $prime_minister_group = $adresses{$s};
    }
  }
  $call++;
}
print $call;

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
