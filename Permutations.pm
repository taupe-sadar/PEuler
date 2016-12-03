package Permutations;
use strict;
use warnings;
use Data::Dumper;
use Math::BigInt;
use List::Util qw( sum );

our(@facts)=(1,1);

my(%cache_cnk)=();

#Retourne le j-ieme sous ensemble de k elements parmi n 
sub subset
{
  my($n,$k,$j)=@_;
  (($k>=0)&&($n>0)&&($n>=$k)) or die "Out of range $j-th subset of size $k in $n";
  if($k==0)
  {
    return ();
  }
  if($n==1)
  {
    (($k==1)&&($j==0)) or die "Out of range $j-th subset of size $k in $n";
    return (0);
  }
  if($n==$k)
  {
    ($j==0) or die "Out of range $j-th subset of size $k in $n";
    return (0..$n-1);
  }
  if($k==1)
  {
    (($j>=0)&&($j<$n)) or die "Out of range $j-th subset of size $k in $n";
    return ($j);
  }
  my($maxmin)=$n-$k+1;
  my($size_subset)=cnk($n-1,$k-1);
  my($idx)=$j;
  for(my($a)=0;$a<$maxmin;$a++)
  {
    if($idx<$size_subset)
    {
      my(@perm)=subset($n-1-$a,$k-1,$idx);
      for(my($b)=0;$b<=$#perm;$b++)
      {
        $perm[$b]+=$a+1;
      }
      return ($a,@perm);
    }
    $idx-=$size_subset->bstr();
    $size_subset*=($n-$k-$a);
    $size_subset/=($n-$a-1);
  }
  die "Out of range $j in ($n,$k). Max ".cnk($n,$k);
}

#retourne le coefficient binomial C(n,k) = nombre de subsets k parmi n 
sub cnk
{
  my($n,$k)=@_;
  my($key)="$n-$k";
  if( !exists( $cache_cnk{$key}))
  {
    my($val)=new Math::BigInt(1);
    my($i)=0;
    for($i=0;$i<$k;$i++)
    {
      $val*=($n-$i);
      $val/=($i+1);
    }
    $cache_cnk{$key} = $val;
  }
  return $cache_cnk{$key};
}

#returns the numbers of permutations in a given set, where some elements are identical
# the input entry is the array of "identical elements.
# Ex : the set { 1,2,1,5,6,3,5} may be represented by : the perl array ( 2,1,2,1,1).
sub nb_permutations_with_identical
{
  my(@identicals)=@_;
  my( $n )= sum( @identicals);
  my($permutations)=1;
  for(my($i)=0;$i<= $#identicals; $i ++ )
  {
    $permutations*= cnk( $n, $identicals[$i]);
    $n -= $identicals[$i];
  }
  return $permutations;
}

#Returns all permuations where the ouput
# is not fully ordered. Ex : considering a set with 7
# elements, and with the "identical representation" 
# is (2,3,2), the permuations :
# ( 2,5,6,4,3,0,1 )
# ( 5,2,6,4,3,0,1 )
# ( 5,2,3,6,4,0,1 )
# ( 5,2,3,6,4,1,0 )
# are all considered equivalent, and count for one permutation.
# * the "identical represenattion" (1,1,1,1,...,1), returns the standard permutation
# * the "identical represenattion" ( n ), returns only one representation
# * nb_permutations_with_identical() return the nb of such permutations
# * idx parameter gives idx-th such permutation
sub permutations_not_ordered
{
  my($ridenticals,$idx)=@_;
  my( $n ) = sum( @$ridenticals);
  my( $first_identicals, @others ) = @$ridenticals;
  if( $#others < 0 )
  {
    return subset( $n , $first_identicals , $idx );
  }
  else
  {  
    my( $num_others ) = nb_permutations_with_identical( @others );
    my( $first_idx, $others_idx ) = ( int($idx/$num_others) , $idx % $num_others );
    my( @final_subset ) = subset( $n , $first_identicals, $first_idx );
    
    my( @unused_elts )=();
    for(my($i,$first_idx)=(0,0);$i<$n;$i++)
    {
      if( $first_idx > $#final_subset || $i != $final_subset[ $first_idx ] )
      {
        push( @unused_elts, $i );
      }
      else
      {
        $first_idx++;
      }
    }
    
    my( @others_subset ) = permutations_not_ordered( \@others, $others_idx );
    for(my($i)=0;$i<=$#others_subset;$i++)
    {
      push( @final_subset, $unused_elts[ $others_subset[ $i ] ] );
    }
    return @final_subset;
  }
}


#Retoure le n-ieme arrangement. Un arrangement de 'k' chiffres parmi 'fact' 
sub arrangement
{
  my($fact,$k,$n)=@_;
  my(@perm);
  if($fact==1)
  {
    @perm=(0);
  }
  elsif($k<=1)
  {
    return ($n);
  }
  else
  {
    my($f)=factorielle($fact-1)/factorielle($fact-$k);
    my($first)=int($n/$f);
    @perm=arrangement($fact-1,$k-1,$n%$f);
    my($i);
    for($i=0;$i<=$#perm;$i++)
    {
      if($perm[$i]>=$first)
      {
        $perm[$i]++;
      }
    }
    unshift(@perm,$first);
  }
  return @perm;
}

sub factorielle
{
  my($n)=@_;
  if($n<=0)
  {
    return 1;
  }
  if($n>$#facts)
  {
    my($i);
    for($i=$#facts+1;$i<=$n;$i++)
    {
      $facts[$i]=$i*$facts[$i-1];
    }
  }
  return $facts[$n];
}
#Decompose in factorial base
sub dec_base_fact
{
  my($n)=@_;
  my(@t)=(0);
  my($base)=2;
  while($n>0)
  {
    my($r)=$n%$base;
    push(@t,$r);
    $n=($n-$r)/$base;
    $base++;
  }
  return @t;
}

#Add two numbers in factorial decomposition (with coeffs a and b)
sub comb_facts
{
  my($refa,$refb,$coeffa,$coeffb)=@_;
  my($a)=0;
  my($retenue)=0;
  my(@sum)=(0);
  if(!defined($coeffa))
  {
    $coeffa=1;
  }
  if(!defined($coeffb))
  {
    $coeffb=1;
  }
  if(($#{$refa}<$#{$refb})||(($#{$refa}==$#{$refb})&&($$refa[-1]<$$refb[-1])))
  {
    my($r)=$refa;
    $refa=$refb;
    $refb=$r;
  }
  for($a=1;$a<=$#{$refb};$a++)
  {
    my($s)=$coeffa*$$refa[$a]+$coeffb*$$refb[$a]+$retenue;
    $sum[$a]=$s%$a;
    $retenue=($s-$sum[$a])/$a;
  }
  for($a=$#{$refb}+1;$a<=$#{$refa};$a++)
  {
    my($s)=$coeffa*$$refa[$a]+$retenue;
    $sum[$a]=$s%$a;
    $retenue=($s-$sum[$a])/$a;
  }
  while($retenue>0)
  {
    $sum[$a]=($retenue)%$a;
    $retenue=($retenue-$sum[$a])/$a;
    $a++;
  }
  return @sum;
  
}

1;
