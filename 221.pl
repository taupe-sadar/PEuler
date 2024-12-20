use strict;
use warnings;
use Data::Dumper;
use Prime;
use Divisors;

my($limit)=10**15;

my(@crible)=(0)x100000;

my($count)=0;
for( my($d)=1; ; $d++ )
{
  my($dcount)=0;
  
  my($mini_alex)=alexandrian(5*$d/2, $d);
  last unless($mini_alex < $limit);

  next if($crible[$d] < 0);
  my($first_p)=fetch_residual($d);
  if( $first_p == -1 )
  {
    my($mult)=$d;
    while($mult <= $#crible)
    {
      $crible[$mult]=-1;
      $mult+=$d;
    }
    next;
  }
  
  next if($first_p == -1);
  
  my($alt)=($d==1)?0:($d - 2*$first_p);
  
  print "[$d : $first_p] ($alt)\n";

  my($p)=2*$d + $first_p;
  
  while(1)
  {
    my($alex)=alexandrian($p,$d);
    last unless($alex < $limit );
    alex_trace($p,$d);
    $dcount ++;
    
    if($alt > 0)
    {
      $alex=alexandrian($p+$alt,$d);
      last unless($alex < $limit);
      alex_trace($p+$alt,$d);
      $dcount++;
    }
    $p+=$d;
  }
  print "-------------\n";
  print "$dcount\n";
  print "-------------\n";
  $count+= $dcount;
  <STDIN>;
  
}
print $count;

sub alexandrian
{
  my($p,$d)=@_;
  my($frac)=$p*$p + 1;
  return $p * ($frac/$d - $p) * ($p - $d);
}

sub alex_trace
{
  my($p,$d)=@_;

  my($frac)=$p*$p + 1;
  my($r)=$p - $d;
  my($q)=$frac/$d - $p;
  my($a)=$p*$q*$r;
  print "---> $p $q $r => $a\n";
}

sub fetch_residual
{
  my($d)=@_;
  for(my($x)=0;$x<=$d/2;$x++)
  {
    return $x if(($x*$x+1)%$d == 0);
  }
  return -1;
}


