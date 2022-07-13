use strict;
use warnings;
use Data::Dumper;

# print count_digits(400001,1)."\n";

# exit(0);
print "Total : ".seek_count_digits(1);

sub seek_count_digits
{
  my($digit)=@_;
  my($k)=0;
  my($sum)=0;
  my($range)=1;  
    
  while($k<=12)
  {
    #Fenetre 10**k .. 10**k
    $sum += recursive_seek($range,$range,$range*10 - 1,$digit);
    $range*=10;
    $k++;
  }
  return $sum;
}

sub recursive_seek
{
  my($range,$low,$high,$d)=@_;
  
  my($fl)=count_digits($low,$d);
  my($fh)=count_digits($high,$d);
  
   # print "($range) $low,$high -> $fl,$fh\n"; <STDIN>;
  
  if($fh < $low || $fl > $high)
  {
    return 0;
  }
  else
  {
    my($sum)=0;
    my($start)=$low;
    if( $range == 1 )
    {
      if($fl == $low)
      {
        $sum += $fl;
        print "$fl\n";
      }
      for(my($i)=1;$i<=8;$i++)
      {
        my($try)=$low+$i;
        if(count_digits($try,$d) == $try)
        {
          $sum += $try;
          print "$try\n";
        }
      }
      if($fh == $high)
      {
        $sum += $fh;
        print "$fh\n";
      }
    }
    else
    {    
      my($reduce_range)=$range/10;
      for(my($i)=0;$i<=9;$i++)
      {
        $sum += recursive_seek($reduce_range,$start,$start+$range-1,$d);
        $start += $range;
      }
    }
    return $sum;
  }
}



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
