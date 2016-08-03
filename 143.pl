use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor ceil/;

# on commence par checher les triplets x^2 = q^2 + q*r + r^2
# ca forme un triangle dont l'angle oppose a x vaut 2pi/3
#
# Pour ca on dit que :
# (2x)^2 = ( 2q + r )^2 + 3*r^2
# En faisant une recherche comme pour les triplets pythagoriciens on trouve des solutions primitives de la forme :
# ( x, q, r ) = (3p^2 + s^2)/4 , (3p+s)*(p-s)/4,  p*s  (1 <= s < p ) p^s = 1 et s n'est pas multiple de 3
#  ET 
# ( x, q, r ) = (p^2 + 3s^2)/4 , (p-3s)*(p+s)/4,  p*s  (1 <= s < p/3 ) p^s = 1 et p n'est pas multiple de 3
#  

my(%single_sum)=();

my( %store ) =();

my($bound) = 120000; 

my( $p_bound ) = sqrt( $bound * 4 );

my($sum) = 0;

for( my($p)= 1; $p <= $p_bound; $p+=2 )
{
  my($p2)=$p*$p;
  
  my($maxs) = $p/3;
  for( my($s)= 1; $s < $p; $s+=2 )
  {
    next if( Gcd::pgcd($p,$s)!=1 );
    my($s2)=$s*$s;
  
    if( $s%3 != 0 )
    {
      my( $x ) = (3 * $p2 + $s2)/4;
      my( $r ) = $p*$s;
      my( $q ) = (3 * $p2 - $s2 - 2 * $r)/4;
      
      store_n_seek( $x, $q, $r);
    }
    
    if( $s < $maxs && $p%3 != 0 )
    {
      my( $x ) = ( $p2 + 3 * $s2)/4;
      my( $r ) = $p*$s;
      my( $q ) = ( $p2 - 3* $s2 - 2 * $r)/4;
      store_n_seek( $x, $q, $r);
    }
  }
}

print $sum;

sub store_n_seek
{
  my( $x, $q, $r )= @_;
  
  return if( $q%2 == 1 && exists($store{$q}) && exists($store{$q}{$r}));
  
  my($limit) = $q+$r;
  
  return if( $limit > $bound );
  
  my($limit_k)= floor( $bound/$limit );
  for( my($k) = 1; $k <= $limit_k; $k++ )
  {  
    find_qr($k*$q,$k*$r);
    
    half_store( $x*$k, $q*$k, $r*$k);
    half_store( $x*$k, $r*$k, $q*$k);
  }
}

sub half_store
{
  my( $x, $q, $r )= @_;
  
  if( !exists($store{ $q }))
  {
    $store{$q} = {$r => $x};
  }
  else
  {
    $store{$q }{$r} = $x;
  }
}

sub find_qr
{
  my($q,$r) = @_;
  if( exists( $store{$q} ) )
  {
    foreach my $other (keys(%{$store{$q}}))
    {
      if( exists( $store{$other}{$r} ) )
      {
        my($add)= $q + $r + $other;
        if( $add <= $bound )
        {
          my($s)=$q + $r + $other;
          if( !exists($single_sum{$s}) )
          {
            $single_sum{$s} = 1;
            print "$s\n";
            $sum += $s;
          }
        }
      }
    }
  }
}
