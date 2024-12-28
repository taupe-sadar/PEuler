use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Solver;
use Prime;
use Divisors;

my($highest_div)=2000000;

Prime::init_crible($highest_div + 1000);

my($p)=Prime::next_prime();
my(@all_divisors)=([1]);
my(%residuals)=(1=>0);
while($p < $highest_div )
{
  if( $p%4 != 3 )
  {
  
  my($prev_residual)=$residuals{$p} = fetch_residual($p);
  my($prev_pow)=$p;
  my(@pows)=($p);
  for(my($pow)=$p*$p;$pow < $highest_div;$pow*=$p)
  {
    $prev_residual = fetch_pow_residual($prev_pow,$pow,$prev_residual);
    print "New : $p $pow $prev_residual\n";
    last if( $prev_residual == -1);

    
    
    
    
    $residuals{$pow} = $prev_residual;
    $prev_pow = $pow;
    push(@pows,$pow);
  }
  <STDIN>;
  
  
  }
  
  $p=Prime::next_prime();
}
sub fetch_pow_residual
{
  my($prev_pow,$pow,$res)=@_;
  for(my($pow_res)=$res;$pow_res<$pow;$pow_res+=$prev_pow)
  {
    if( ($pow_res*$pow_res + 1)%$pow == 0)
    {
      return ( $pow_res <= $pow/2 )?$pow_res: ($pow - $pow_res);
    }
  }
  return -1;
}
sub fetch_multiple_residual
{
  my($p1,$res1,$p2,$res2)=@_;
  for(my($pow_res)=$res;$pow_res<$pow;$pow_res+=$prev_pow)
  {
    if( ($pow_res*$pow_res + 1)%$pow == 0)
    {
      return ( $pow_res <= $pow/2 )?$pow_res: ($pow - $pow_res);
    }
  }
  return -1;
}

####

my(@crible)=(0)x200000;

my(@divisors)=();

my($born)=1000000;
my($res)=0;
while($res < 150000)
{
   $res = count_alex(\@divisors,\%residuals,$born);
   print "$born, $res ($#divisors)\n";
   
   <STDIN>;
   $born *= 10;
}


sub count_alex
{
  my($rdivisors,$rresiduals,$limit)=@_;

  my($count)=0;
  
  my($div_index)=($#$rdivisors >= 0) ? 0 : -1;
  my($d)=0;
  while( 1 )
  {

    if($div_index >=0) 
    {
      if( $div_index <= $#$rdivisors )
      {
        $d = $$rdivisors[$div_index++];
      }
      else
      {
        $div_index = -1;
        $d++;
      }
    }
    else
    {
      $d++;
    }

    my($mini_alex)=(4*$d + 2)*$d*$d;
    last unless($mini_alex < $limit);
    die "out of crible ($d)!" if ($d > $#crible);

    my($first_p) = crible_update($d);
    next if($first_p < 0);

    push(@$rdivisors,$d) if($div_index < 0);

    my($init)=2*$d + $first_p;
    my($alt)=($d==1)?0:($d - 2*$first_p);


    #new implem : 
    my($last)=find_limit_alex($d,$limit);
    my($count1)=floor(($last-$init)/$d) + 1;
    my($count2)=($alt > 0)?(floor(($last-$init - $alt)/$d) + 1):0;
    die "WTF " if( $count2 < 0);

    $$rresiduals{$d} = [$count1,$count2];
    
    print "[$d : $first_p] ($alt) : $count1 + $count2\n";
    # <STDIN>;
    
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
  return $count;
}

sub crible_update
{
  my($d)=@_;
  
  if($crible[$d] == 0 )
  {
    my($first_p)=fetch_residual($d);
    if( $first_p == -1 )
    {
      my($mult)=$d;
      while($mult <= $#crible)
      {
        $crible[$mult]=-1;
        $mult+=$d;
      }
    }
    else
    {
      $crible[$d]=$first_p;
    }
  }
  
  return $crible[$d];
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


