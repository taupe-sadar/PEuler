use strict;
use warnings;
use Data::Dumper;

print count_digits(10,1);

sub count_pow10
{
  my($pow)=@_;
  return 10**($pow-1)*$pow;
}

sub count_digits
{
  my($n,$d)=@_;
  return 0 if($n eq "");
  
  my(@digits)=split('',$n);
  my($exp)=$#digits;
  my($head)=shift(@digits);
  my($suffix)=join("",@digits);
  
  my($val) = 0;
  $val += count_pow10($exp)*$head;
  $val += 10**$exp if($head > $d );
  
  if($suffix ne "" )
  {
    $val += ($suffix+1) if($head == $d );
    $val += count_digits($suffix,$d);
  }
  else
  {
    $val ++ if($head == $d );
  }
    
  return $val;
}