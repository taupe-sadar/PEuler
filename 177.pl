use strict;
use warnings;
use Data::Dumper;
use Math::Trig;
use POSIX qw/floor ceil/;
use List::Util qw(max);

# Scheme representing the diagonals, and angles
#              /
#             /
#            /
# alpha1    /theta      beta1
# ---------------------------
# alpha2  /             beta2
#        /
#       /
#      /
#
# We must have : 
#    [cotan(beta2)  - cotan(theta)] / [cotan(beta1)  + cotan(theta)] 
#  = [cotan(alpha2) + cotan(theta)] / [cotan(alpha1) - cotan(theta)]
#
# the algorithm is a bit tricky because it must manage equality cases

my(@cotans)=(10**6);

for(my($angle)=1;$angle<=179;$angle++)
{
  push(@cotans,cot(toRadian($angle)));
}

my($total)=0;

for(my($theta)=2;$theta<=89;$theta++)
{
  my($count)=0;
  my($pitheta)=180-$theta;
  my($cot_theta) = $cotans[$theta];
  
  for(my($alpha2)=ceil($pitheta/2);$alpha2<$pitheta;$alpha2++)
  {
    my($dalpha2) = $cotans[$alpha2] + $cot_theta;
    
    for(my($beta1)=$pitheta-$alpha2;$beta1<=$alpha2;$beta1++)
    {
      my($dbeta1) = $cotans[$beta1] + $cot_theta;
      my($prod)=$dalpha2* $dbeta1;
      
      my($minalpha1) = ($beta1 == $pitheta-$alpha2)?ceil($theta/2):1;
      
      my(@cots)=();
      
      for(my($alpha1)=$theta-1; $alpha1 >= $minalpha1;$alpha1--)
      {
        my($dalpha1) = $cotans[$alpha1] - $cot_theta;
        my($cot_beta2) = $cot_theta + $prod / $dalpha1;
        push(@cots, $cot_beta2);
        
        last if($beta1 == $alpha2 && $cotans[$alpha1] > $cot_beta2 + 1e-8 );
        
        my($beta2)= test_integer_angle($cot_beta2,$theta);
        if($beta2>0)
        {
          $count++;
        }
      }
    }
  }
  # print "$theta : $count\n";
  $total+=$count;
}
#Special case for 90, cot(90) = 0
{
  my($count)=0;
  my($theta)=90;
  my($theta_2)=$theta/2;
  for(my($alpha1)=$theta_2;$alpha1<$theta;$alpha1++)
  {
    my($minalpha2)=$theta - $alpha1 + (($alpha1==$theta_2)?0:1);
    for(my($alpha2)=max(1,$minalpha2);$alpha2<=$alpha1;$alpha2++)
    {
      my($minbeta1)=max(1,$theta - $alpha1,$theta - $alpha2 + (($alpha2 < $theta_2)?1:0));
      for(my($beta1)=$alpha1;$beta1>=$minbeta1;$beta1--)
      {
        my($cot_beta2) = $cotans[$alpha2] / $cotans[$alpha1] * $cotans[$beta1] ;
        
        my($beta2)= test_integer_angle($cot_beta2);
        if($beta2>0)
        {
          $count++;
        }
      }
    }
  }
  # print "90*** : $count\n";
  $total+=$count;
}

print $total;

sub test_integer_angle
{
  my($angle_cot)=@_;
  my($angle) =  360 * acot($angle_cot)/(2*pi);
  my($integer)=floor($angle + 0.5);
  my($frac)=abs($angle - $integer);
  
  if( $frac < 1e-9)
  {
    if( $frac >  1e-12 )
    {
      print "($angle_cot -> $angle) ($integer + $frac)\n";
      # <STDIN>;
    }
    
    return $integer;
  }
  return 0;
}

sub toRadian
{
  my($a)=@_;
  return $a*2*pi/360;
}

