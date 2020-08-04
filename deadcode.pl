use strict;
use warnings;
use Gcd;
use Data::Dumper;

sub insert_sorted_set
{
  my($reftab,$num)=@_;
  my($idx)=0;
  for($idx=0;$idx<=$#{$reftab};$idx++)
  {
    if($$reftab[$idx]==$num)
    {
      return;
    }
    elsif($$reftab[$idx]>$num)
    {
      last;
    }
  }
  splice(@{$reftab},$idx,0,$num);
  
}

sub list_divisors
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
    my(@sublist_divisors)=list_divisors(%h);
    my(@ret)=@sublist_divisors;
    for(my($a)=0;$a<=$#sublist_divisors;$a++)
    {
      my($f)=1;
      for(my($b)=1;$b<=$n;$b++)
      {
        $f*=$p;
        push(@ret,$f*$sublist_divisors[$a])
      }
      
    }
    return @ret;
    
  }
  
}

# root = first element e of Z/pZ such that the order
# of e is p - 1;
sub investigating_roots_of_zpz
{
  my($n)=55440;
  #my($n)=210;
  
  my(@qs)=();
  
  my(@divisors)=list_divisors(Prime::decompose($n));
  
  my($e)=new Math::BigInt(1);
  
  for(my($m)=0;$m<=$#divisors;$m++)
  {
    my($prime)=$divisors[$m]+1;
    push(@qs,$prime) if(Prime::is_prime($prime));
  }
  
  for(my($m)=0;$m<=$#qs;$m++)
  {
    my($vp)=0;
    my($q)=$n;
    my($prime) = $qs[ $m ];
    while($q%$prime==0)
    {
      $q/=$prime;
      $vp++;
    }
    $e*=($prime**($vp+1));
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
      
    die "WAT ? not prime $qs[$i]" if  SmartMult::smart_mult_modulo($g,$qs[$i]-1,$qs[$i]) !=1 ;
      
      my($found)=1;
      foreach my $p (keys(%dec))
      {
        my($o)=($qs[$i]-1)/$p;
        
        if( SmartMult::smart_mult_modulo($g, $o,$qs[$i]) == 1 ) # pas generateur du groupe
        {
          $found=0;
          last;
        }
        
      }
      last if($found);
      
      
    }
    $roots{$qs[$i]}=$g;
  }
  
  print Dumper \%roots;

}

sub investigating_continude_fractions
{
  my(@q)=(9,1,7,37);
  print quad_to_string(@q)." = \n";
  my($count)=0;
  while($count < 10 )
  {
    my($a,@q2 )= next_quad(@q);
    print "X$count = $a + 1/X".($count+1)."\n";
    my($div)="";
    $q2[2]*=($q2[1]**2);
  $q2[1]=1;
    
    die "Invalid quad A = $a , q = ".join(" ",@q) if(($q2[2]-$q2[0]**2)%$q2[3] != 0 );
    print "X".($count+1)." = ".quad_to_string(@q2)."\n";
    
    @q=@q2;
    $count ++;
  }
}

sub quad_to_string
{
  my(@quad)=@_;
  my($s)=$quad[1]>0?"+ ":"- ";
  $s.= $quad[1] unless abs($quad[1])==1;
  
  return "( ".$quad[0]." ".$s."sq[ ".$quad[2]." ] ) / ".$quad[3];
}

sub next_quad
{
  my($b,$c,$n,$r)=@_;
  if($r < 0)
  {
    $c = -$c;
    $b = -$b;
    $r = -$r; 
  }
  my($f)=($b+$c*sqrt($n))/$r;
  
  my($aa)=($f<0)?int(- $f )-1:int($f);
  
  my($bb)=$aa*$r-$b;
  my($rr)=$c**2*$n-$bb**2;
  my($d1)=Gcd::pgcd($r*$bb,$rr);
  my($d2)=Gcd::pgcd($r*$c,$rr);
  my($d3)=Gcd::pgcd($d1,$d2);
  
  if($rr < 0)
  {
    $c = -$c;
    $bb = -$bb;
    $rr = -$rr; 
  }
  return ($aa , $bb*$r/$d3, $c*$r/$d3, $n, $rr/$d3 );
 }
