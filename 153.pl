use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Gcd;

#Test of sum of contributors 

my( @refs ) = ( 1, 2, 4, 5 ,9, 10, 25, 20.5,30,40,49,64,64.1,63.9,81,80.5,81.1,101,100000);
my(@res)= ( 1, 4, 15, 21, 69, 87, 522, 339, 762, 1342, 1987, 3403, 3403, 3276, 5435, 5314, 5435, 8401, 8224740835 );

if( 0 )
{

for( my($i)=0;$i<=$#refs;$i++)
{
  my($test)=  sum_of_contributors( $refs[$i], 1 );
  if( $test != $res[$i] )
  {
    print "Error : $refs[$i] should be $res[$i] instead of $test\n";
  }
}
exit(1);

}


my($max)=10**8;

my($sum)= calc_divs($max,floor(sqrt($max)));
print "--> $sum\n";
$sum+= calc_all_divs_complex($max);
print "--> $sum\n";

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
    my($add_s)=calc_divs_complex($num,$b,0);
    # print "$b : $add_s\n";
    last if($add_s == 0);
    $s += $add_s;
    $b++;
  }
  
  $s+= calc_divs_diago_45($num);
  
  return $s;
}

sub calc_divs_diago_45
{
  my($num)=@_;
  return  sum_of_contributors( $num, 2 ) * 2;
}

sub calc_divs_complex
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
      
      # print "$a $b ($p): $x\n";
      $s+=$x;
    }
    $a++;
  }
  return $s * 2;
}

sub sum_of_contributors
{
  my($num,$div)=@_;
  # print "__ : $div\n";
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

sub sum_integers_from_1
{
  my($n)=@_;
  return $n*($n+1)/2;
}

sub sum_of_integers
{
  my($a,$b)=@_;
  return ($b-$a+1)*($a+$b)/2;
}