use strict;
use warnings;
use Data::Dumper;

my($final_sum)=0;
for(my($d)=1;$d<=9;$d++)
{
  $final_sum += seek_count_digits($d);
}
print $final_sum;

sub seek_count_digits
{
  my($digit)=@_;
  my($k)=0;
  my($sum)=0;
  my($range)=1;  
  my($crosses_diag)=1; 
  while($crosses_diag)
  {
    #Fenetre 10**k .. 10**(k+1) - 1
    my($s,$cd) = recursive_seek($range,$range,$range*10 - 1,$digit);
    $sum +=$s;
    $crosses_diag = $cd;
    $range*=10;
    $k++;
  }
  print "($digit) Stop at (".($k-1).") : $sum\n";
  return $sum;
}

sub recursive_seek
{
  my($range,$low,$high,$d)=@_;
  
  my($fl)=count_digits($low,$d);
  my($fh)=count_digits($high,$d);
  
  # print "($range) $low,$high -> $fl,$fh\n"; #<STDIN>;
  
  if($fh < $low )
  {
    return (0,1);
    
  }
  elsif( $fl > $high)
  {
    return (0,0);
  }
  else
  {
    my($sum)=0;
    my($may_cross_diag)=0;
    my($start)=$low;
    if( $range == 1 )
    {
      if($fl == $low)
      {
        $sum += $fl;
      }
      for(my($i)=1;$i<=8;$i++)
      {
        my($try)=$low+$i;
        if(count_digits($try,$d) == $try)
        {
          $sum += $try;
        }
      }
      if($fh == $high)
      {
        $sum += $fh;
      }
      $may_cross_diag = 1;
    }
    else
    {    
      my($reduce_range)=$range/10;
      for(my($i)=0;$i<=9;$i++)
      {
        my($s,$mcd)=recursive_seek($reduce_range,$start,$start+$range-1,$d);
        $sum += $s;
        $may_cross_diag = 1 if($mcd == 1);
        $start += $range;
      }
    }
    return ($sum,$may_cross_diag);
    
  }
}

sub count_pow10
{
  my($pow)=@_;
  return 0 if($pow == 0);
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
