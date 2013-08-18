use strict;
use warnings;
use Data::Dumper;
use Prime;
use Time::HiRes qw(time);
use List::Util qw( max min );
use POSIX qw/floor ceil/;
use Math::BigInt;
use Permutations;
use SmartMult;
use Hashtools;


#my($n)=55440;
my($n)=210;

my(%h)=Prime::decompose($n);
my(@qs)=();

my(@divisors)=divs(%h);



my($e)=new Math::BigInt(1);

for(my($m)=0;$m<=$#divisors;$m++)
{
  my($prime)=$divisors[$m]+1;
  
  if(Prime::is_prime($prime))
  {
    push(@qs,$prime);
    my($vp)=0;
    my($q)=$n;
    while($q%$prime==0)
    {
      $q/=$prime;
	    $vp++;
    }
    $e*=($prime**($vp+1));
  }
}
$e*=2;

print "$e ->".length($e)." \n";

my(%roots)=();
for(my($i)=0;$i<=$#qs;$i++)
{
  if($qs[$i]==2)
  {
    next;
  }
  my(%dec)=Prime::decompose($qs[$i]-1);
  my($g)=1;
  
  
  while(1)
  {
    $g++;
    my($p);
    my($a)= SmartMult::smart_mult_modulo($g,$qs[$i]-1,$qs[$i]);
    
    if( SmartMult::smart_mult_modulo($g,$qs[$i]-1,$qs[$i]) != 1) ## pas premier avec $qs[$i]
    {
	    next;
    }
    my($found)=1;
    foreach $p (keys(%dec))
    {
	    my($o)=($qs[$i]-1)/$p;
	    
	    if( SmartMult::smart_mult_modulo($g, $o,$qs[$i]) == 1 ) # pas generateur du groupe
	    {
        $found=0;
        last;
	    }
	    
    }
    if($found)
    {
	    last;
    }
  }
  $roots{$qs[$i]}=$g;
}

print Dumper \%roots;

sub divs
{
  my(%h)=@_;
  my(@k)=keys(%h);
  if($#k==-1)
  {
    return (1);
  }
  else
  {
    my($p)=$k[0];
    my($n)=$h{$p};
    delete $h{$p};
    my(@subdivs)=divs(%h);
    my(@ret)=@subdivs;
    for(my($a)=0;$a<=$#subdivs;$a++)
    {
	    my($f)=1;
	    for(my($b)=1;$b<=$n;$b++)
	    {
        $f*=$p;
        push(@ret,$f*$subdivs[$a])
	    }
      
    }
    return @ret;
    
  }
  
}
