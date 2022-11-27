use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Prime;
use Gcd;

# The maximum of function k -> (N/k)^k is reached for N/e.
# Needs to know if the best value for floor(N/e) or ceil(N/e)
# Use log function for the comparaison

my($limit)=10000;
my($d)=0;

for(my($s)=5;$s<=$limit;$s++)
{
  my($kmin_real)=$s/exp(1);
  my($kfloor)=floor($kmin_real);
  
  my($kopt)=find_minimal_fraction($kfloor,$s);
  
  my($is)=finite_fraction($s,$kopt);
  # print "--- s : $s / kfloor : $kfloor / kopt : $kopt / ".($s/$kopt)." ($is)\n";
  if($is)
  {
    $d-=$s;
  }
  else
  {
    $d+=$s;
  }
}
print $d;


sub find_minimal_fraction
{
  my($n,$size)=@_;
  my($cond)=(log($n+1) + $n*log(1+1/$n)) > log($size);
  if( (log($n+1) + $n*log(1+1/$n)) > log($size))
  {
    return $n;
  }
  else
  {
    return $n+1;
  }
  
}

sub finite_fraction
{
  my($s,$k)=@_;
  my($pgcd)=Gcd::pgcd($s,$k);
  my(%primes)=Prime::decompose($k/$pgcd);
  foreach my $p (keys(%primes))
  {
    return 0 if($p!=2 && $p != 5);
  }
  return 1;
}