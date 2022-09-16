use strict;
use warnings;
use Data::Dumper;
use POSIX qw/ceil/;
use Permutations;
use Math::BigInt;

my($num_digits)=20;
my($base_modulo)=10**9;
my($modulo)=$num_digits * $base_modulo;

my(@squares)=();
my(%square_hash)=();

my($i)=1;
my($square)=1;
while($square < $num_digits*81 )
{
  push(@squares,$square);
  $square_hash{$square}=$i;
  $i++;
  $square = $i * $i;
}

my(@tab_squares)=(map({$_*$_} (0..9)));

my($ones)=pre_calculations($num_digits);

my(%test)=();
find_sol_brute_force($num_digits,\%test);

# print Dumper \%test;<STDIN>;

my(%alt) = find_sol_alt($num_digits);

my($total)=0;
foreach my $s (@squares)
{
  $alt{$s} = [0,0] if(!exists($alt{$s}));
  my($t)=find_sol($num_digits, $s, 9, 0, 1, 0, [] );
  $t = ((new Math::BigInt($ones) * $t) % $modulo)->bint();
  
  if($t % $num_digits != 0 )
  {
    print "Error !\n";
  }
  
  # $t = $p % $modulo ;
  print " $s : ".($t/$num_digits)." ($test{$s}/$alt{$s}[0])\n";
  
  $total = ($total + $t)%$base_modulo;
}
print $total;

sub find_sol_brute_force
{
  my($n_digits,$rres)=@_;
  foreach my $s (@squares)
  {
    $$rres{$s}=0;
  }
  return if($n_digits > 9);
  
  for(my($i)=1;$i<10**$n_digits;$i++)
  {
    my(@ds)=split("",$i);
    my($s)=0;
    for my $d (@ds)
    {
      $s+=$tab_squares[$d];
    }
    if(exists($square_hash{$s}))
    {
      $$rres{$s} = ($$rres{$s} + $i)%$base_modulo;
    }
  }
}

sub pre_calculations
{
  my($n_digits)=@_;
  my($val)=0;
  for(my($i)=1;$i<=$num_digits;$i++)
  {
    $val = ($val * 10 + 1)%$modulo;
  }
  
  return $val;
}

sub find_sol
{
  my($n_digits,$target,$max_digit,$current_count,$current_perm,$prev_equals,$rseq)=@_;
  
  # print "".(('-')x(20-$n_digits))."$max_digit, $current_count\n";
  
  my($sum)=0;
  
  if( $n_digits > 0 )
  {
    my($min_square)=ceil($target/$n_digits);
    
    for(my($i)=$max_digit;$i>=0;$i--)
    {
      last if($tab_squares[$i] < $min_square);
      push(@$rseq,$i);
      
      my($new_prev)=$prev_equals;
      my($new_count)=$current_count;
      my($new_perm)=$current_perm;
      if($i < $max_digit)
      {
        $new_prev = 0;
        $new_count = $current_count + $prev_equals * $max_digit;
        $new_perm = ($current_perm * Permutations::cnk($n_digits + $prev_equals, $prev_equals))%$modulo;
        # if($current_perm > $modulo*10000 )
        # {
          # print "".(1<<62)."\n"; 
          # print "$current_perm\n"; <STDIN>;
        # }
      }

      if($target == $tab_squares[$i] )
      {
        $new_prev+=1;
        $new_perm = ($new_perm * Permutations::cnk($n_digits-1 + $new_prev, $new_prev))%$modulo;
        $new_count += $new_prev * $i;
        $sum = ($sum + $new_perm * $new_count);
        # if($new_perm > $modulo )
        # {
          
          # print "".join("",@$rseq)."\n"; <STDIN>;
        # }
        
        
        # print ("********* ".join("",@$rseq)." ($new_perm)\n");
      }
      elsif($target > $tab_squares[$i] )
      {
        $sum = ($sum + find_sol($n_digits-1, $target - $tab_squares[$i], $i, $new_count, $new_perm, $new_prev+1,$rseq))%$modulo;
      }
      pop(@$rseq);
    }
  }
  return $sum;
}

sub find_sol_alt
{
  my($n_digits)=@_;
  
  my($rvalues)={};
  
  for(my($i)=0;$i<=9;$i++)
  {
    $$rvalues{$tab_squares[$i]} = [$i,1];
  }
  
  # foreach my $s (sort({$a<=>$b}keys(%$rvalues)))
  # {
    # print "$s : $$rvalues{$s}\n";
  # }
  # <STDIN>;
  
  my($exp)=10;
  for(my($d)=2;$d<=$n_digits;$d++)
  {
    my(%new_values)=();
    
    for(my($j)=0;$j<=9;$j++)
    {
      my($val)=($d<=9)?($j*$exp):0;
      foreach my $s (keys(%$rvalues))
      {
        my($new_key) = $s + $tab_squares[$j];
        $new_values{$new_key} = [0,0] if(!exists($new_values{$new_key}));
        
        # if( $new_key == 4 )
        # {
          # print "($new_key) $d : $s + $tab_squares[$j] -> $new_values{$new_key} + $$rvalues{$s} + $val\n";
          # <STDIN>;
        # }
        my($base)=$$rvalues{$s}[0];
        my($count)=$$rvalues{$s}[1];
        $new_values{$new_key}[0] = ($new_values{$new_key}[0] + $val*$count + $base) % $base_modulo;
        $new_values{$new_key}[1] = ($new_values{$new_key}[1] + $count) % $base_modulo;
      }
    }
    
    $rvalues=\%new_values;
    $exp*=10 if($d<=9);
    
    # print "------ $d ---------\n"; 
    # foreach my $s (sort({$a<=>$b}keys(%$rvalues)))
    # {
      # print "$s : $$rvalues{$s}\n";
    # }
    # print Dumper $rvalues; 
    # <STDIN>;
  }
  return %$rvalues;
}