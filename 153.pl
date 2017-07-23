use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

my($max)=5;

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
  my($a)=1;
  my($s)=0;
  while(1)
  {
    my($p)=$a*$a*2;
    last if($p>$num);
    $s += floor($num/$p) * $a *2;
    $a++;
  }
  return $s;
}

sub calc_divs_complex
{
  my($num,$b,$param)=@_;
  my($a)=$b+1;
  my($b2)=$b*$b;
  my($s)=0;
  while(1)
  {
    my($p)=$a*$a + $b2;
    last if($p>$num);
    $s += floor($num/$p) * ($a+$b) *2;
    $a++;
  }
  return $s;
}

sub sum_of_integers
{
  my($a,$b)=@_;
  return ($b-$a+1)*($a+$b)/2;
}