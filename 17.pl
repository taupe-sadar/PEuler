use strict;
use Data::Dumper;

my($end)=1000;
my(@letters_20)=("","one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen");
my(@letters_90)=("","","twenty","thirty","forty","fifty","sixty","seventy","eigthy","ninety");
my($hundred)="hundred";
my($and)="and";
my($thousand)="thousand";
my($i)=0;
my($bigsum)=0;
for($i=1;$i<=$end;$i++)
{
  $bigsum+=sum_letters($i);
}
# print string_letters($ARGV[0])."\n";
# print sum_letters($ARGV[0])."\n";
print $bigsum;

sub sum_letters
{
  my($i)=@_;
  my($sum)=0;
  my($unit)=$i%10;
  my($dizaine)=($i%100-$unit)/10;
  my($centaine)=($i%1000-$dizaine*10-$unit)/100;
  my($milier)=($i%10000-($centaine*100+$dizaine*10+$unit))/1000;
    
  if($milier>0)
  {
    $sum+=length($thousand)+length($letters_20[$milier]);
  }
  if($centaine>0)
  {
    $sum+=length($hundred)+length($letters_20[$centaine]);
    if($dizaine||$unit)
    {
      $sum+=length($and);
    }
  }
  if($dizaine>=2)
  {
    $sum+=length($letters_90[$dizaine])+length($letters_20[$unit]);
  }
  else
  {
    $sum+=length($letters_20[$dizaine*10+$unit]);
  }
  return $sum;
}

sub string_letters
{
  my($i)=@_;
  my($sum)="";
  my($unit)=$i%10;
  my($dizaine)=($i%100-$unit)/10;
  my($centaine)=($i%1000-$dizaine*10-$unit)/100;
  my($milier)=($i%10000-($centaine*100+$dizaine*10+$unit))/1000;
    
  if($milier>0)
  {
    $sum.="$letters_20[$milier] $thousand ";
  }
  if($centaine>0)
  {
    $sum.="$letters_20[$centaine] $hundred ";
    if($dizaine||$unit)
    {
      $sum.="$and ";
    }
  }
  if($dizaine>=2)
  {
    $sum.="$letters_90[$dizaine] $letters_20[$unit] ";
  }
  else
  {
    $sum.="$letters_20[$dizaine*10+$unit]";
  }
  return $sum;
}