package Repunit;
use strict;
use warnings;
use Prime;
use EulerTotient;
use SmartMult;

my($base)= 10 ;

sub set_base
{
  my($b)=@_;
  $base = $b;
}


sub group_unity_order_if_p_x_2n
{
  my($znz_size)=@_;
  my($minus_part,%decomposition) = EulerTotient::phi_decomposition( $znz_size );
  my( $pvalue_2 )= 0;
  while( $minus_part%2 == 0 )
  {
    $minus_part/=2;
    $pvalue_2++;
  }
  if( exists( $decomposition{ 2 } ) )
  {
    $pvalue_2 += $decomposition{ 2 };
    delete $decomposition{ 2 };
  }
  
  my($p);
  my($big_number)=$minus_part;
  foreach $p (keys(%decomposition))
  {
    next if $p==2;
    $big_number*= $p**$decomposition{ $p };
  }
  if( Prime::fast_is_prime( $big_number ))
  {
    my($prod) = SmartMult::smart_mult_modulo( $big_number , $ 
  }
  else
  {
    return 0;
  }
}

sub group_unity_order
{
  my($znz_size)=@_;
  my( $order )= 0;
  my( $order_simple_to_calculate , $rvalue2, $rbignumber ) = group_unity_order_if_p_x_2n( $znz_size );
  if( $order_simple_to_calculate  )
  {
    return $order;
  }
  
  
}

1;
