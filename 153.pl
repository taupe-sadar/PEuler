use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Gcd;
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
    print "$b : $add_s\n";
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
  my($a)=$b+1;
  my($b2)=$b*$b;
  my($s)=0;
  while(1)
  {
    if( Gcd::pgcd($a,$b) == 1 )
    {
      my($p)=$a*$a + $b2;
      last if($p>$num);
      my($x)= sum_of_contributors( $num, $p ) * 2 * ($a+$b);
      
      # print "$a $b ($p): $x\n";
      $s+=$x;
    }
    $a++;
  }
  return $s;
}

sub sum_of_contributors
{
  my($num,$div)=@_;
  # print "__ : $div\n";
  my($s)=0;
  my($k) = 1;
  
  my($limit)= ceil( sqrt($num/$div) );
  
  while(1)
  {
    my($val) = floor($num/($k*$div));
    last if($val < $limit);
    $s+= $k * $val;
    $k++;    
  }
  # print "S1 : $s\n";
  my($last_bound)=floor($num/$div);
  for(my($i)=2;$i<=$limit;$i++)
  {
    my($bound)= floor($num/($div*$i));
    $s+= sum_of_integers($bound+1,$last_bound) * ($i-1);
    $last_bound = $bound;
  }
  return $s;
}

sub sum_of_integers
{
  my($a,$b)=@_;
  return ($b-$a+1)*($a+$b)/2;
}