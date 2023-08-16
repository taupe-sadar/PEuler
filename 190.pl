use strict;
use warnings;
use Data::Dumper;
use Sums;

# With x_m = f( x_1, ... , x_m-1 ) = m - (x_1 + ... + x_m-1),
# we have : for i in [ 1; m-1 ] 
#    dPm / dx_i = i * Pm / x_i - m * Pm / x_m
# So dPm / dx_i = 0 <=> For i != j , x_i/i = x_j/j
#     x_i = i * x_1
#     x_1 + ... + m * x_1 = m
#     x_1 = 2/(m+1)
#     x_i = 2*i/(m+1)
# Finally Pm = prod( (2*i/(m+1))**i )

my($sum)=0;
for(my($i)=2;$i<=15;$i++)
{
  $sum+=pm($i);
}
print $sum;

sub pm
{
  my($m)=@_;
  my($prod)=[1];
  for(my($a)=1;$a<=$m;$a++)
  {
    for(my($b)=1;$b<=$a;$b++)
    {
      $prod = base_mult( $prod, 2*$a, $m+1 );
    }
  }
  my($unit_idx)=Sums::int_sum($m);
  my($count)=0;
  for(my($e)=$#$prod;$e>=$unit_idx;$e--)
  {
    $count*= $m+1;
    $count+= $$prod[$e];
  }
  return $count;
}

sub base_mult
{
  my($vec,$coeff,$base)=@_;
  my(@mult)=map( {$_*$coeff} @$vec);
  for(my($d)=0;$d<=$#mult;$d++)
  {
    my($q,$r) = (int($mult[$d]/$base),$mult[$d]%$base);
    $mult[$d] = $r;
    if( $q > 0 )
    {
      if( $d == $#mult )
      {
        push(@mult,$q);
      }
      else
      {
        $mult[$d+1]+=$q;
      }
    }
  }
  return \@mult;
}