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

my($size)=SmartMult::smart_mult(Math::BigInt->new(10),9);

print numPascalDivs($size-1);

sub numPascalDivs
{
  my($n)=@_;
  return numPascalNonDivs($n);
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