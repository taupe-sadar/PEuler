use strict;
use warnings;
use Data::Dumper;
use Sums;
use List::Util qw(max min);

# Ici on compte :
# La somme des rectangles "droits", faciles a compter rij = sum( i ) * sum( j )
# Et la somme des rectangles "obliques" plus difficile a compter : dij
# L'idee est de prendre les huit types differents :
# - largeur pair/imapair
# - longueur pair/imapair
# - debut sur le bord / sur la premiere demi moitie
# et on compte le nombre de translations valides.
#
# On trouve que rij = s( i-1, j-1) + 5*s( i, j ) + s( i, j-1) + s( i-1, j) 
# avec S( a,b ) = m*(m+1)*(m-1)*(2M-m)/12. avec m = min(a,b) et M = max( a,b )
#
# Ca se calcule = rij = (2M - m )*m * (4m^2 - 1) - m/2
# 
# Apres il faut tout sommer. C'est long et chiant et ca fait une formule enorme.

my($x,$y)=(43,47);
print (sum_rij($x,$y) + sum_dij_calc($x,$y));

sub rij
{
  my($i,$j)=@_;
  return Sums::int_sum($i)*Sums::int_sum($j);
}

sub dij
{
  my($i,$j)=@_;
  
  my($count)=0;
 
  my($M)= max($j,$i);
  my($m)= min($j,$i);
  
  $count += -$m/2;
  $count += (2*$M  - $m)*(-1 + 4*$m*$m)*$m/6 ;
  
  
  return $count;
}

sub dij_calc
{
  my($i,$j)=@_;
  
  return sab($i-1,$j-1) + 5*sab($i,$j) + sab($i+1,$j) + sab($i,$j+1)
}

sub sum_dij_bf
{
  my($i,$j)=@_;
  my($sum)=0;
  for(my($a)=0;$a<=$i;$a++)
  {
    for(my($b)=0;$b<=$j;$b++)
    {
      $sum+=dij($a,$b);
    }
  }
  return $sum;
}

sub sum_dij_calc
{
  my($i,$j)=@_;

  my($M)= max($j,$i);
  my($m)= min($j,$i);
  
  my($sum)= $m*($m+1)*($m-1)*(2*$m*$m*$m+6*$m*$m+7*$m+1)/30;
  
  my($subsum)= $M*(2*$m*$m+2*$m-1)/6;
  $subsum += ($m-1)*(2*$m*$m+10*$m+17)/30;
  
  $sum+= ($M-$m)*$m*($m+1)/2 * $subsum;
  
  return $sum;
}


sub sum_rij
{
  my($i,$j)=@_;
  return ($i*($i+1)*($i+2)/6 )*($j*($j+1)*($j+2)/6 )
  
}


sub sab
{
  my($i,$j)=@_;
  my($M)= max($j,$i);
  my($m)= min($j,$i);
  return $m*($m+1)*($m-1)*(2*$M - $m)/12;
}

