use strict;
use warnings;
use Data::Dumper;
use Prime;
use Gcd;
use Math::BigInt;


my($base)=10;
my($max)=1000;

my(%hash_base)=Prime::decompose($base);
my(@period)=(0,0);
my(%pordre);
my(%pkmin);

my($n);
my($maximum)=0;
my($argmax)=0;
for($n=2;$n<$max;$n++)
{
  my($p,$fact,$reste)=Prime::partial_decompose($n);
  if(defined($hash_base{$p}))
  {
    $period[$n]=$period[$n/$p];
  }
  elsif($reste!=1)
  {
    $period[$n]=Gcd::ppcm($period[$fact],$period[$reste]);
  }
  else # $reste=1 donc $fact=$p^$k avce $p premier 
  {
    if($p==2)
    {
      die "Very special case : not implemented !\n";
    }
    
    if(!defined($pordre{$p}))
    {
      $pordre{$p}=find_order($base,$p);
    }
      
    if($p==$fact)
    {
      $period[$n]=$pordre{$p};
    }
    else #cas p^k avec k > 1
    {
      if(!defined($pkmin{$p}))
      {
        $pkmin{$p}=find_kmin($base,$p,$pordre{$p});
      }
      my($m);
      my($other)=1;
      for($m=$p**$pkmin{$p};$m<$fact;$m*=$p)
      {
        $other*=$p;
      }
      $period[$n]=$pordre{$p}*$other;
    }
        
  }
  if($period[$n]>$maximum)
  {
    $maximum=$period[$n];
    $argmax=$n;
  }
}
print $argmax;

sub find_kmin
{
  my($b,$p,$pordre)=@_;
  my($big)=Math::BigInt->new($b);
  $big=$big**$pordre;#normalement la on a : $big = 1 + a0*p + a1*p^1 + ... 
  $big--;#et la on a meme pas le 1;
  $big/=$p;#et la  p-1
  my($kmin)=1;
  while(($big%$p)==0)
  {
    $big/=$p;
    $kmin++;
  }
  return $kmin;
}

sub find_order
{
  my($b,$p)=@_;
  my($r)=$b%$p;
  my($o)=1;
  while($r>1)
  {
    $r=($r*$b)%$p;
    $o++;
  }
  return $o;
}

