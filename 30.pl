use strict;
use warnings;
use Data::Dumper;

my($z,$a,$b,$c,$d,$e);
my(@pow5)=();
for($a=0;$a<=9;$a++)
{
  $pow5[$a]=$a**5;
}
my($bigsum)=0;
for($z=0;$z<=3;$z++)
{
  for($a=0;$a<=9;$a++)
  {
    my($s1)="$z${a}0000";
    my($suma)=$pow5[$z]+$pow5[$a];
    for($b=0;$b<=9;$b++)
    {
      my($s2)="$z$a${b}000";
      my($sumb)=$suma+$pow5[$b];
      if($sumb>($s2+999))
      {
        last;
      }
      for($c=0;$c<=9;$c++)
      {
        $d=(-($z+$a+$b+$c))%10;
        my($s4)="$z$a$b$c${d}0";
        my($sumc)=$sumb+$pow5[$c]+$pow5[$d];
        for($e=0;$e<=9;$e++)
        {
          my($s5)="$z$a$b$c$d$e";
          my($sume)=$sumc+$pow5[$e];
          if($sume>$s5)
          {
            last;
          }
          if($sume==$s5)
          {
            
            if(($s5!=1) && ($s5 !=0 ))
            {
              $bigsum+=$s5;
            }
          }
        }
      }
    }
  }
}
print $bigsum;
