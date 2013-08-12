package EulerTotient;
use strict;
use warnings;
use Prime;
use Sums;

#Those functions use the equations with Moebius function
# d = prod( pi**ki )
# mu(d)=  0 if some ki > 1,  (-1)**(nb of pi) else

sub sum_phi
{
  my($max)=@_;
  Prime::init_crible($max);
  my(%moebius)=();
  
  my($p)=Prime::next_prime();
  my($sum_of_phi)=$max**2; #on initialise avec k=1;
  while($p<=($max/2))
  {
    my($limit)=int($max/$p);
    my($e);
    my(@keys)=keys(%moebius);
    foreach $e (@keys)
    {
      
      if( $e > $limit )
	    {
        delete $moebius{$e};
        next;
	    }
	    my($newp)=$p*$e;
	    $moebius{$newp}= -$moebius{$e};
	    $sum_of_phi+= int($max/$newp)**2 * $moebius{$newp};
	    
    }
    
    $moebius{$p}= -1;
    $sum_of_phi-= $limit**2;
    $p=Prime::next_prime();
  }
  
  while($p<=$max) #Ici $p >$max/2 le tableau est vide donc $limit = $max/p < 2
  {
    $sum_of_phi -=1;
    $p=Prime::next_prime();
  }
  
  
  $sum_of_phi = ($sum_of_phi + 1)/2  ;
  return $sum_of_phi;
}

#return the sum of all phi(n) that are in [0;1/m]

sub sum_phi_x
{
  my($max , $m) =@_;
  ($m=~m/^\d+$/ && $m!=0) or die "sum_phi_x : $m Must be a positive non null integer";
  if($m == 1)
  {
    return sum_phi( $max );
  }
  
  Prime::init_crible($max);
  my(%moebius)=();
  
    my($p)=Prime::next_prime();
  
  my($sum_of_phi_div)=Sums::sum_integer_div_by($max,$m); #on initialise avec k=1;
  while($p<=($max/2))
  {
    my($limit)=int($max/$p);
    my($e);
    my(@keys)=keys(%moebius);
    foreach $e (@keys)
    {
	    
	    if( $e > $limit )
	    {
        delete $moebius{$e};
        next;
	    }
	    my($newp)=$p*$e;
	    $moebius{$newp}= -$moebius{$e};
	    
	    $sum_of_phi_div+=  Sums::sum_integer_div_by( int($max/$newp),$m)* $moebius{$newp};
	    
    }
	
    $moebius{$p}= -1;
    
    $sum_of_phi_div-= Sums::sum_integer_div_by( $limit,$m);
    
    $p=Prime::next_prime();
  }
  #On peut sauter la derniere etape car  $m > 1;
  #while($p<=$max) #Ici $p >$max/2 le tableau est vide donc $limit = $max/p < 2
  #{
  #	$sum_of_phi -= sum_integer_div_by( 1,$m);
  #	$p=Prime::next_prime();
  #}
  
  # Attention on retourne 1/m dans le calcul
    return $sum_of_phi_div ;
}


1;
