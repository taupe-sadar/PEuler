use strict;
use warnings;
use Data::Dumper;
use Sums;
use List::Util qw(max min);


# my($pol) = newPol(1,5,7);
# print Dumper $pol;
# print evalPol($pol,3,11);
# print "\n";<STDIN>;


# exit(0);

test(3,2);
test(5,5);
test(7,4);
test(4,7);
test(10,6);

sub test
{
  my($i,$j)=@_;
  my($v1) = rij($i,$j) + bf_dij($i,$j);
  my($v2) = rij($i,$j) + dij($i,$j);
  print "($i,$j) ";
  if( $v1 != $v2 )
  {
    print "*** Erreur ***: $v1 != $v2\n";
  }
  else
  {
    print "$v1\n";
  }
}


sub rij
{
  my($i,$j)=@_;
  return Sums::int_sum($i)*Sums::int_sum($j);
}

sub bf_dij
{
  my($i,$j)=@_;
  
  my($count)=0;
  
  for( my($x)= 0;$x <= $i; $x += 0.5 )
  {
    my($even)= (2*$x)%2 == 0;
    my($start_y)=  $even?1:0.5;
    for( my($y)= $start_y; $y <= $j; $y ++ )
    {
      
      for( my($n)= 1; ; $n ++ )
      {
        my($top)= $y - $n/2;
        
        
        last if( $top < 0 );
      
        for( my($m)= 1; ; $m ++ )
        {
          my($right)= $x + ($m + $n)/2;
          my($bottom)= $y + $m/2;
          last if( $right > $i || $bottom > $j ); 
          $count++;
        }
      }
    }
  }
  return $count;
}

sub dij
{
  my($i,$j)=@_;
  
  my($count)=0;
 
  for( my($x)= 0;$x <= $i; $x ++ )
  {
    my($n_limit3) = 2*( ($i - $x)-$j);
    
    $count +=  $j *($j+1)*($j-1)*2/3 ;
    
    if( $n_limit3 <= 0 )
    {
      my($subcount)=  (-2+3*$j);
      $subcount+= ($n_limit3 )*( -$n_limit3 + 3/2  -3*$j);
      
      $count += ($n_limit3 )*$subcount/6;
    }
  }
  
  for( my($x)= 1;$x <= $i; $x ++ )
  {
    my($n_limit3) = 2*( ($i - $x)-$j);
    
    $count += $j*(2*$j*$j+1)/3;
    
    if( $n_limit3 <= 0 )
    {
      my( $subcount)= ($n_limit3)*(-1/2  -$j  -$n_limit3/3);
      $subcount +=  -$j + 1/3;
      $count+= ( $n_limit3)/2*$subcount;
    }
  
  }
  return $count;
}

sub s1
{
  my($x)=@_;
  return $x*($x+1)/2;
}

sub s1_h
{
  my($x,$half)=@_;
  if( $half )
  {
    return ($x*$x)/2;
  }
  else
  {
    return s1($x);
  }
}


sub s2_h
{
  my($x,$half)=@_;
  if( $half )
  {
    return s1($x)*($x-1)*2/3 + $x/4;
  }
  else
  {
    return s2($x);
  }
}

sub s2
{
  my($x)=@_;
  return $x*($x+1)*(2*$x+1)/6;
}


