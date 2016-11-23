use strict;
use warnings;
use Data::Dumper;
use Math::BigInt;
use SmartMult;
use POSIX qw/floor ceil/;

# Apres calcul on se rend compte que les coefficients Cnk 
# qui ne sont pas multiples de p on la propriete :
# "Dans l'addition en base p de n et n-k, il n'y a pas de retenue"
# parce que v_p( Cnk ) = somme( ri ) (ri restes de l'addition )

my($p)= 7;

my($size)=Math::BigInt->new(100);

test(6);
test(7);
test(8);
test(13);
test(14);
test(15);
test(48);
test(49);
test(50);
test(100);
test(200);
test(340);
test(342);
test(343);
test(344);
test(764);

print numPascalDivs($size);

sub numPascalDivs
{
  my($n)=@_;
  return ($n+2)/2*($n+1)/2 - numPascalNonDivs($n);
}

sub test
{
  my($limit)=@_;
  my($sum)=0;
  for(my($x)=0;$x<=$limit;$x++)
  {
    $sum+=lineNonPascal($x);
  }
  my($bf)= numPascalNonDivs($limit);
  if( $sum == $bf)
  {
    print "$limit : $sum\n";
  }
  else
  {
    print "**** $limit Error : $bf != $sum ****\n";
  }  
}

sub lineNonPascal
{
  my($x)=@_;
  my(@d)= decBase( $x );
  my($prod)=1;
  for(my($i)=0;$i<=$#d;$i++)
  {
    $prod *= $d[$i]+1;
  }
  return $prod;
}


sub numPascalNonDivs
{
  my($n)=@_;
  
  my(@decomposition)= decBase( $n );
  my($sum)=0;
  
  my($sum_of_int_p)=sumOfInt($p);
  
  my($current_prod)=1;
  
  for( my($i)=$#decomposition; $i >= 0 ; $i-- )
  {
    my($prod)= $current_prod;
    if( $i > 0)
    {
      $prod *= SmartMult::smart_mult($sum_of_int_p,  $i );
    }
    $prod *= sumOfInt( $decomposition[$i] );
    
    $sum +=  $prod;
    $current_prod *= ($decomposition[$i]+1);
  }
  $sum+= $current_prod;
  
  return $sum;
}


sub decBase
{
  my($n)=@_;
  my(@dec)=();
  while( $n > 0)
  {
    push(@dec,$n%$p);
    $n= floor($n/$p);
  }
  return @dec;
}

sub sumOfInt
{
  my($n)= @_;
  return $n*($n+1)/2;
}