use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Solver;
use Prime;
use Divisors;


my(@crible)=(0)x200000;

my(@divisors)=();
my(%residuals)=();

count_alex(\@divisors,\%residuals,100000);

sub count_alex
{
  my($rdivisors,$rresiduals,$limit)=@_;

  my($count)=0;
  
  my($div_index)=0;
  my($d)=0;
  while( 1 )
  {
    if($div_index <= $$rdivisors) 
    {
      $d = $$rdivisors[$div_index];
    }
    else
    {
      $d++;
    }
    
    my($mini_alex)=(4*$d + 2)*$d*$d;
    last unless($mini_alex < $limit);
    die "out of crible ($d)!" if ($d > $#crible);

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
    else
    {
      $crible[$d]=$first_p;
    }
    
    
    
    


    my($init)=2*$d + $first_p;


    #new implem : 
    my($last)=find_limit_alex($d,$limit);
    my($count1)=floor(($last-$init)/$d) + 1;
    my($count2)=($alt > 0)?(floor(($last-$init - $alt)/$d) + 1):0;
    die "WTF " if( $count2 < 0);
    push(@$rdivisors,$d);
    $$residuals{$d} = [$count1,$count2];



    print "[$d : $first_p] ($alt) : $count1 + $count2\n";
    <STDIN>;
    $count+= $count1 + $count2;
    if( 0 )
    {
      my($p)=$init;
      #old implem : test
      my($dcount1)=0;
      my($dcount2)=0;
      while(1)
      {
        my($alex)=alexandrian($p,$d);
        last unless($alex < $limit );
        # alex_trace($p,$d);
        $dcount1 ++;
        
        if($alt > 0)
        {
          $alex=alexandrian($p+$alt,$d);
          last unless($alex < $limit);
          # alex_trace($p+$alt,$d);
          $dcount2++;
        }
        $p+=$d;
      }
      
      
      if($count1!=$dcount1 || ($alt > 0 && $count2!=$dcount2))
      {
      print "-------------\n";
      print "$count1 $count2\n";
      print "$dcount1 $dcount2\n";
      print "-------------\n";
      <STDIN>;
      }
    }
  }
  print "$limit : $count\n";
  return $count;
}

sub find_limit_alex
{
  my($div,$stop)=@_;
  
  my($fn)= sub { my($p)=@_;return $p * (($p*$p +1)/$div - $p) * ($p - $div); };
  
  ### test
  # my($ftest)= sub {my($p)=@_;return $p * $p -1;};
  # my($x)=Solver::solve_no_larger_integer($ftest,65,1520);
  # print "test : $x\n";
  # <STDIN>;
  return Solver::solve_no_larger_integer($fn,floor(($stop*$div)**(1/4)),$stop);
}

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


