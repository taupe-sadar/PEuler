use strict;
use warnings;
use Data::Dumper;
use Prime;
use Residual;

# my($perimeter_max)=25000000;
my($perimeter_max)=100;

Prime::init_crible(200000);

my(@all_divisors)=();
my(%residuals)=();
Residual::calc_residuals(\@all_divisors,\%residuals,1,$perimeter_max*10);

my(@k)=(sort({$a <=> $b} keys(%residuals)));

print "num divs : ".($#k + 1)."\n";

my($final_count)=0;
foreach my $div (@k)
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
      
    
    my($count)=0;
    my($s1,$s2)=("","");
    while ($perimeter <= $perimeter_max)
    {
      
      #manage better
      # if($other%2 == $div%2 && $a>=$b && $b != 1 && $a >= $div)
      if($other%2 == $div%2 && $a<=$b && $a != 1 && $a >= $div)
      {
        # if($count==0)
        # {
          # $s1="  (a,b,c) : ($a,$b,$c) ".($a*$a)." + ".($b*$b)." = ".($c*$c)." + 1 (perimeter : $perimeter)\n";
        # }
          # $s2="  (a,b,c) : ($a,$b,$c) ".($a*$a)." + ".($b*$b)." = ".($c*$c)." + 1 (perimeter : $perimeter)\n";
        
        print "** $div / $res ** \n";
        print "  (a,b,c) : ($a,$b,$c) ".($a*$a)." + ".($b*$b)." = ".($c*$c)." + 1 (perimeter : $perimeter)\n";
        # <STDIN>;
        $count++;
      }
      
      $a+=$div;
      
      $other=($a*$a - 1)/$div;
      
      
      
      $b = ($other-$div)/2;
      $c = ($other+$div)/2;
      $perimeter = $a+$b+$c;
    }
    if($count > 0)
    {
    # print "** $div / $res ** \n";
    print "--> $count\n";
    # print "--> $s1\n";
    # print "--> $s2\n";
    # <STDIN>;
    }
    $final_count += $count;
    
  }
  
}
print "Final : $final_count\n";

