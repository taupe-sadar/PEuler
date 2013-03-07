use strict;
use warnings;
use Data::Dumper;

#Resolution a la main :
# On cherche d, telk que 3/7 - n/d  = (3*d -7*n)/(7*d) soit petit
# On commence par chercher les solutions de 3*d - 7*n =1;
# Ca donne d = 7*k - 3
#          n = 3*k - 1

my($max)= 10**6; #maximum pour d


my($k)=int( ($max + 3)/7);
my($d) = 7*$k - 3; #On remarque que c'est tres proche de $max, q'une solution qvec 3/7 - n/d > 1 n'aurait aucune chance
my($n) = 3*$k - 1;

print $n;

