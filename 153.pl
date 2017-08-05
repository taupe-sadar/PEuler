use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Gcd;

my($max)=10**8;

my($sum)= calc_divs($max,floor(sqrt($max)));
$sum+= calc_all_divs_complex($max);
print $sum;

sub calc_divs
{
  my($num,$param)=@_;
  my($s)=0;
  my($k)=1;
  while(1)
  {
    my($f)= floor($num/$k);
    
    last if( $f <$param );
    
    $s += $f*$k;
    $k++;
  }
  
  my($last_bound)=$num;
  for(my($i)=2;$i<=$param;$i++)
  {
    my($bound)= floor($num/$i);
    $s+= sum_of_integers($bound+1,$last_bound) * ($i-1);
    $last_bound = $bound;
  }
  
  return $s;
}

sub calc_all_divs_complex
{
  my($num)=@_;
  my($s)=0;
  my($b)=1;
  while(1)
  {
    my($add_s)=calc_divs_complex_odd($num,$b,0);
    last if($add_s == 0);
    $s += $add_s;
    $b+=2;
  }
  $b=2;
  while(1)
  {
    my($add_s)=calc_divs_complex_even($num,$b,0);
    last if($add_s == 0);
    $s += $add_s;
    $b+=2;
  }
  
  $s+= calc_divs_diago_45($num);
  
  return $s;
}

sub calc_divs_diago_45
{
  my($num)=@_;
  return  sum_of_contributors( $num, 2 ) * 2;
}

sub calc_divs_complex_odd
{
  my($num,$b,$param)=@_;
  use integer;
  my($a)=$b+1;
  my($b2)=$b*$b;
  my($s)=0;
  while(1)
  {
    if( Gcd::optim_pgcd($b,$a) == 1 )
    {
      my($p)=$a*$a + $b2;
      last if($p>$num);
      my($x)= sum_of_contributors( $num, $p ) * ($a+$b);
      
      $s+=$x;
    }
    $a++;
  }
  return $s * 2;
}

sub calc_divs_complex_even
{
  my($num,$b,$param)=@_;
  use integer;
  my($a)=$b+1;
  my($b2)=$b*$b;
  my($s)=0;
  while(1)
  {
    if( Gcd::optim_pgcd($b,$a) == 1 )
    {
      my($p)=$a*$a + $b2;
      last if($p>$num);
      my($x)= sum_of_contributors( $num, $p ) * ($a+$b);
      
      $s+=$x;
    }
    $a+=2;
  }
  return $s * 2;
}

sub sum_of_contributors
{
  my($num,$div)=@_;
  my($s)=0;
  use integer;
  
  my($val,$k)=(0,1);
  
  while(1)
  {
    $val = ($num/($div*$k));
    last if( $val <= $k );
    $s+= $val*(($val+1) + ($k<<1))/2;
    $k++;
  }
  if( $k == $val )
  {
    $s+= $val;
  }
  
  $s -= ($k-1)*( $k -1) * $k /2;
  
  return $s;
}

sub sum_of_integers
{
  my($a,$b)=@_;
  return ($b-$a+1)*($a+$b)/2;
}