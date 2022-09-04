use strict;
use warnings;
use Data::Dumper;
use Bezout;
use POSIX qw/ceil/;

# The rotation equation is : 
#  ( b * 10^(n-1) + a ) = k * ( a * 10 + b ), 10^(n-1) > a >= 10^(n-2), b < 10
#  a ( k * 10  - 1 ) = b * ( 10^(n-1) - k )
#
#  Using b and k as parameters, we only need to know if the factor (k * 10  - 1) 
#  divides b * ( 10^(n-1) - k ), and check that 'a' is big enough
#
#  Calculation is made in limited Z/(factor Z) for checking divisibility, 
#  and Z/(10**5 Z) for outputing '10a + b' values 

my($n_max)=100;
my($digits)=5;
my($res_modulo)=10**$digits;
my($modulo_part)=10**($digits-1);

my($sum)=0;
for(my($k)=1;$k<=9;$k++)
{
  my($factor)= $k*10 - 1;
  for( my($b)=ceil($factor/10);$b<=9; $b ++ )
  {
    my($n)=1;
    my($big_nb) = (1 - $k + $factor)%$factor;
    my($res_nb) = (1 - $k + $modulo_part)%$modulo_part;
    
    while($n<$n_max)
    {
      $big_nb = (($big_nb + $k)*10 - $k) % $factor;
      $res_nb = (($res_nb + $k)*10 - $k) % $modulo_part;
      $n++;
      
      my($prod)=($big_nb * $b)%$factor;
      if($prod == 0)
      {
        my($a) = $res_nb * $b * Bezout::znz_inverse($factor,$modulo_part);
        my($rotative)=$a*10 + $b;
        $sum = ($sum + $rotative)%$res_modulo;
      }
    }
  }
}

print $sum;
