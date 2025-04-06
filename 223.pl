use strict;
use warnings;
use Data::Dumper;
use Prime;
use Residual;

# my($perimeter_max)=25000000;
my($perimeter_max)=1000000;

Prime::init_crible(200000);

my(@all_divisors)=();
my(%residuals)=();
Residual::calc_residuals(\@all_divisors,\%residuals,1,$perimeter_max/8);

my(@k)=(sort({$a <=> $b} keys(%residuals)));

print "num divs : ".($#k + 1)."\n";

my($count_egal,$count_sup,$count_inf,$count1_sup,$count1_inf)=(0,0,0,0,0);
$residuals{1} = [0];
foreach my $div (1,@k)
{
  
  my($s)=join(" ",@{$residuals{$div}});
  # print "$kk : $s\n";<STDIN>;
  
  for my $res (@{$residuals{$div}})
  {
    
    
    my($a) =$res;
    
    my($other)=($a*$a - 1)/$div;
    my($b)=($other-$div)/2;
    my($c)=($other+$div)/2;
    my($perimeter)=$a+$b+$c;
      
    
    while ($perimeter <= $perimeter_max)
    {
      
      #manage better
      # if($other%2 == $div%2 && $a>=$b && $b != 1 && $a >= $div)
      if($other%2 == $div%2 && $a >= $div  && $b !=1 )
      {
        
        if( $a == $b )
        {
          $count_egal++;
        }
        elsif( $a > $b )
        {
          if( $b == 1 )
          {
            $count1_inf++;
          }
          else
          {
            $count_inf++;
          }
        }
        elsif( $a < $b )
        {
          if( $a == 1 )
          {
            $count1_sup++;
          }
          else
          {
            $count_sup++;
          }
        }
        
        if($a <= $b )
        {
        print "** $div / $res ** \n";
        print "  ($a,$b,$c) ".($a*$a)." + ".($b*$b)." = ".($c*$c)." + 1 (perimeter : $perimeter)\n";
        # <STDIN>;
        }
      }
      
      
      
      
      $a+=$div;
      
      $other=($a*$a - 1)/$div;
      
      
      
      $b = ($other-$div)/2;
      $c = ($other+$div)/2;
      $perimeter = $a+$b+$c;
    }
  }
  
}
print " = : $count_egal\n";
print " a < b : $count_sup\n";
print " a > b : $count_inf\n";
print " a = 1 < b : $count1_sup\n";
print " a > b = 1 : $count1_inf\n";

