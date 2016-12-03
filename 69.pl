use strict;
use warnings;
use Data::Dumper;
use Prime;

#Onutilise la super propriete :
# Si n = produit ( pi**ki)
# alors phi(n)= produit( pi**(ki-1) * (pi-1) )
#et du coup n/phi(n) = produit( pi/(pi - 1) )
my($n)=1;
my($nextn)=1;
my($max)=10**6;
while($nextn<$max)
{
    $n=$nextn;
    $nextn*=Prime::next_prime();
}
print $n;
