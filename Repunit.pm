package Repunit;
use strict;
use warnings;
use Data::Dumper;
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
  my(@keys_dec)=(keys(%decomposition));
  foreach $p (@keys_dec)
  {
    next if $p==2;
    $big_number*= $p**$decomposition{ $p };
  }
  my($final_order)=0;
  my($square_order) = try_squares_order( $base , $znz_size, $pvalue_2 );
  
  if( $square_order )
  {
    $final_order = $square_order;
  }
  elsif( $#keys_dec < 0 && Prime::fast_is_prime( $big_number ))
  {
    my($prod) = SmartMult::smart_mult_modulo( $base, $big_number , $znz_size );
    if( $prod == 1 )
    {
      $final_order = $big_number;
    }
    else
    {
      my($bigsqu_order)= try_squares_order( $prod , $znz_size, $pvalue_2 );
      $final_order = $bigsqu_order*$big_number if( $bigsqu_order );
      
    }
  }
      
  return ($final_order,$pvalue_2,$big_number);
}

sub group_unity_order
{
  my($znz_size)=@_;
  my( $order )= 0;
  my( $order_simple_to_calculate , $value2, $bignumber ) = group_unity_order_if_p_x_2n( $znz_size );
  if( $order_simple_to_calculate  )
  {
    return $order_simple_to_calculate;
  }
  else
  {
    my($num)=$base;
    for(my($order)=1; $order<=$bignumber; $order+=2)
    {
      if( $num % $znz_size == 1 )
      {
        return $order;
      }
      
      my($bigsqu_order)= try_squares_order( $num , $znz_size, $value2 );
      return $order*$bigsqu_order if( $bigsqu_order );

      $num *= ($base**2) ;
      $num  = $num% $znz_size;
    }
  }
  die "Could not find order of $base in Z/${znz_size}Z";
}

sub try_squares_order
{
  my($number,$znz_size,$max_pow_2)=@_;
  my($order)=1;
  while( $number !=1 && $max_pow_2 > 0 )
  {
    $number=($number**2)%$znz_size;
    $max_pow_2--;
    $order*=2;
  }
  if( $number == 1)
  {
    return $order;
  }
  else
  {
    return 0;
  }
}
1;
