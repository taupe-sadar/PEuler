use strict;
use warnings;
use Data::Dumper;
use EulerTotient;
use Prime;
use Gcd;
use SmartMult;

# We use modulo to do a simpler calculation
# In Z/nZ, a**phi(n)=1 if pgcd(a,n)=1
# So at each iteration :
#   we do the euclide division : hyper_ex(a,n-1) = q * phi(n) + r
#   then : hyper_ex(a,n) = a**(q * phi(n) + r) = a**r = a**(hyper_ex(a,n-1) % phi(n))


print hyper_ex(1777,1855,10**8);

sub hyper_ex
{
  my($a,$n,$modulo)=@_;
  die "Not omplemented, if a^modulo != 1 " if(Gcd::pgcd($a,$modulo)!=1);

  return 0 if($modulo == 1);

  my(%dec)=EulerTotient::phi_decomposition($modulo);
  my($phi_modulo)=Prime::dec_to_nb(\%dec);
  
  my($smaller_ex)=hyper_ex($a,$n-1,$phi_modulo);
  return SmartMult::smart_mult_modulo($a,$smaller_ex,$modulo);
}