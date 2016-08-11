use strict;
use warnings;
use Data::Dumper;

# Si on considere le retenues (xi) de l'operation 
# xn xn-1 xn-2     x2   x1   x0   (0)
#    an   an-1 ... a3   a2   a1   a0
#    a0   a1       an-3 an-2 an-1 an
#
#  Pour n'avoir que des nombres impairs, il faut que :
#  xn-i = xi ET  xn-i-1 = xi-1
#
# Du coup on en deduit :
# n : impair ( nb chiffres pair )
# - xi : 0 ( Cas [1] )
#
# n : pair ( nb chiffres impair )
# - x2i : X (tous a 1 ou tous a 0)
# - x2i+1 : 0
#
# a cause du an/2 + an/2 on doit avoir xn/2-1 = 1, 
# Donc :
# - n = 2[4], => X = 1,         ( Cas [2] )
# - n = 0[4] : pas de solutions ( Cas [3] )
# 

my($nb_digits ) = 8;

my( $sum ) = 0;

for( my($n)=0; $n < $nb_digits; $n++)
{
  my( $congruence ) = $n%4;
  if( $congruence == 0 )
  {
    next;
  }
  elsif( $congruence == 2 )
  {
    my($possibilities)=(2*10)**(($n-2)/4 + 1) * 5 * 25**(($n-2)/4 );
    $sum += $possibilities;
  }
  else
  {
    my($possibilities)= (2*10) * (2*15)**(($n-1)/2);
    $sum += $possibilities;
  }
}

print $sum;
