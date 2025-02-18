use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Solver;
use Prime;
use Bezout;
use Divisors;
use Math::BigInt;
use List::Util qw( sum max min );

my($target)=150000;
# my($target)=150;


Prime::init_crible(200000);

my(@all_divisors)=();
my(%residuals)=();

my($born)=10000;
my(@counts)=();
my($count)=0;
while($count < $target)
{
  calc_residuals(\@all_divisors,\%residuals,$born);

  $count = count_alex(\@all_divisors,\%residuals,$born);
  push(@counts,[$born,$count]);
  if(0)
  {
    print "$born, $count -> test(".test($born).")\n";
  }
  else
  {
    print "$born, $count \n";
  }
  # print Dumper \@all_divisors;
  
  # print Dumper \%residuals;

  $born *= 4;
}
my($last_residuals)=get_alex_range(\@all_divisors,\%residuals,$counts[-2][0],$counts[-1][0]);
my($offset)=$target - $counts[-2][1] - 1;
my($alexandrian_wanted)=$$last_residuals[$offset];
print $alexandrian_wanted;

sub test
{
  my($limit)=@_;
  my($count)=0;
  for(my($p)=2;;$p++)
  {
    # print "($p)\n";
    last if(($p**3/2 + $p) > $limit);
    
    my(%dec)=Prime::decompose($p*$p+1);
    my(@divs)=Prime::all_divisors_no_larger(\%dec,floor($p/2)+1);
    # print Dumper \@divs;
    foreach my $d (sort({$b<=>$a}@divs))
    {
      my($alex)=alexandrian($p,$d);
      if($alex <= $limit)
      {
        # print "$p $d -> $alex\n";
        $count++;
      }
      else
      {
        last;
      }
    }
    
  }
  return $count;
  
}


sub calc_residuals
{
  my($rrdivisors,$rresiduals,$limit)=@_;

  Prime::reset_prime_index();
  my($p)=Prime::next_prime();
  my($pcount)=0;
  
  my($highest_div)=($limit/4)**(1/3);
  while($p < $highest_div)
  {
    if( $p%4 != 3 )
    {
      $all_divisors[$pcount] = [] if($#all_divisors < $pcount);
      my($rdivisors)= $$rrdivisors[$pcount];
      my($current_max_div) = ($#$rdivisors < 0)?0:$$rdivisors[-1];
      
      my($prev_residual)=fetch_residual($p);
      my(@new_divs)=();
      if($p > $current_max_div )
      {
        $$rresiduals{$p} = ($p == 2)?[$prev_residual]:[$prev_residual,$p - $prev_residual];
        push(@new_divs,$p);
      }

      my($prev_pow)=$p;
      my(@pows)=($p);
      for(my($pow)=$p*$p;$pow < $highest_div;$pow*=$p)
      {
        $prev_residual = fetch_pow_residual($prev_pow,$pow,$prev_residual);
        last if( $prev_residual == -1);

        if($pow > $current_max_div )
        {
          $$rresiduals{$pow} = [$prev_residual,$pow - $prev_residual];
          push(@new_divs,$pow);
        }
        
        $prev_pow = $pow;
        push(@pows,$pow);
      }

      for(my($k)=0;$k<=$#pows;$k++)
      {
        my($highest_prime)=floor(($highest_div-1)/$pows[$k]);
        for(my($i)=0;$i<$pcount;$i++)
        {
          my($pmult)=$all_divisors[$i];
          last if($$pmult[0] > $highest_prime);
          
          for(my($j)=0;$j<=$#$pmult;$j++)
          {
            #To test :
            # my($first_new_div)=ceil(($current_max_div+1)/$$pmult[$j]);
            my($div)=$pows[$k]*$$pmult[$j];
            # next if($pows[$k] <= $first_new_div);
            next if($div <= $current_max_div);
            last if($div >= $highest_div);
            push(@new_divs,$div);
            
            my($pm,$q)=($$pmult[$j],$pows[$k]);
            # print "m residuals : $pows[$k]*$$pmult[$j] = $div | $p,$q\n";
            # print Dumper $$rresiduals{$pm};
            # print Dumper $$rresiduals{$q};
            $$rresiduals{$div} = fetch_multiple_residual($pm,$$rresiduals{$pm},$q,$$rresiduals{$q});
          }
        }
      }
      @new_divs = sort({$a <=> $b} @new_divs);

      # print "($p) : New mult array : ".join(" ",@new_divs)."\n";
      @$rdivisors = (@$rdivisors,@new_divs);
      $pcount++;
    }

    $p=Prime::next_prime();
  }
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
  my($p,$resp,$q,$resq)=@_;
  
  my($prod)=$p*$q;
  
  my(@residuals)=();
  for my $rp (@$resp)
  {
    for my $rq (@$resq)
    {
      # my($test)=Math::BigInt->new(Bezout::congruence_solve(($p=>$rp,$q=>$rq)));
      # if($test*$test % $prod != $prod-1 )
      # {
         # print "Issue : $test*$test % $p*$q != -1 \n";
         # my($test2)=$test*$test;
         # print "$test2\n";<STDIN>;
      # }
      
      push(@residuals,Bezout::congruence_solve(($p=>$rp,$q=>$rq)));
    }
  }

  @residuals=sort({$a<=>$b} @residuals);
  # print (" --> $p : ".join(" ",@$resp)."\n");
  # print (" --> $q : ".join(" ",@$resq)."\n");
  # print (" <-- ".join(" ",@residuals)."\n");
  # <STDIN>;
  return \@residuals;
}

sub count_alex
{
  my($rdivisors,$rresiduals,$limit)=@_;

  my($count_total)=0;
  
  # Manage divisor 1
  {
    my($last)=find_limit_alex(1,$limit);
    my($count) = max($last - 1,0);
    $count_total += $count;

    if( 0 )
    {
      my($p)=2;
      
      while(1)
      {
        my($alex)=alexandrian($p,1);
        last unless($alex < $limit );
        alex_trace($p,1);
        
        $p++;
      }
    }


    # print "[1 : 0] : $count\n";
  }
  
  
  for(my($i)=0;$i<=$#$rdivisors;$i++)
  {
    my($r_sub_divisors)=$$rdivisors[$i];

    # print (join(",",@$r_sub_divisors)."\n");
    # <STDIN>;
    
    for(my($j)=0;$j<=$#$r_sub_divisors;$j++)
    {
      my($d)=$$r_sub_divisors[$j];

      # TODO : move into residual fetching(DONE). Keep it there ?
      # my($mini_alex)=(4*$d + 2)*$d*$d;
      # last unless($mini_alex < $limit);

      my($rres)=$$rresiduals{$d};
      
      #new implem : 
      my($last)=find_limit_alex($d,$limit);

      foreach my $r (@$rres)
      {
        my($init)=2*$d + $r;
        my($count)=max(floor(($last-$init)/$d) + 1,0);
        
        # print "[$d : $r] : $count\n";

        $count_total+= $count;
        
        if( 0 )
        {
          my($p)=$init;
          my($dcount)=0;
          
          while(1)
          {
            my($alex)=alexandrian($p,$d);
            last unless($alex < $limit );
            alex_trace($p,$d);
            $dcount ++;

            $p+=$d;
          }

          if($count!=$dcount)
          {
          print "-------------\n";
          print "$count $dcount\n";
          print "-------------\n";
          <STDIN>;
          }
        }
      }
    }
  }
  return $count_total;
}

sub get_alex_range
{
  my($rdivisors,$rresiduals,$limit_low,$limit_high)=@_;
  my(@alexs)=();
  
  my($one_last_low)=max(find_limit_alex(1,$limit_low),2);
  my($one_last_high)=find_limit_alex(1,$limit_high);
  for(my($p)=$one_last_low+1;$p<=$one_last_high;$p++)
  {
    push(@alexs,alexandrian($p,1));
  }

  for(my($i)=0;$i<=$#$rdivisors;$i++)
  {
    my($r_sub_divisors)=$$rdivisors[$i];
    for(my($j)=0;$j<=$#$r_sub_divisors;$j++)
    {
      my($d)=$$r_sub_divisors[$j];
      my($rres)=$$rresiduals{$d};
      
      my($last_low)=find_limit_alex($d,$limit_low);
      my($last_high)=find_limit_alex($d,$limit_high);

      foreach my $r (@$rres)
      {
        my($begin)= max(floor(($last_low+$d - $r)/$d),2)*$d + $r;
        my($end)= floor(($last_high - $r)/$d)*$d + $r;
        for(my($p)=$begin;$p<=$end;$p+=$d)
        {
          push(@alexs,alexandrian($p,$d));
        }
      }
    }
  }
  @alexs = sort({$a<=>$b} @alexs);
  print "Final size : ".($#alexs+1)."\n";
  return \@alexs;
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


