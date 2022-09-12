use strict;
use warnings;
use Data::Dumper;
use POSIX qw/ceil/;
use Permutations;

my($num_digits)=20;
my($modulo)=10**9;

my(@squares)=();

my($i)=1;
my($square)=1;
while($square < $num_digits*81 )
{
  push(@squares,$square);
  $i++;
  $square = $i * $i;
}

my(@tab_squares)=(map({$_*$_} (0..9)));

my($total)=0;
foreach my $s (@squares)
{
  my($t)=find_sol($num_digits, $s, 9, 1, 0);
  print " $s : $t\n";
  
  $total = ($total + $t)%$modulo;
}
print $total;

sub find_sol
{
  my($n_digits,$target,$max_digit,$current_perm,$prev_equals)=@_;
  
  # print "".(('-')x(20-$n_digits))."$max_digit, $current_perm\n";
  
  my($count)=0;
  
  if( $n_digits > 0 )
  {
    my($min_square)=ceil($target/$n_digits);
    
    for(my($i)=$max_digit;$i>=0;$i--)
    {
      last if($tab_squares[$i] < $min_square);
      if($target == $tab_squares[$i] )
      {
        my($perm) = $current_perm;
        if( $i == $max_digit )
        {
          $perm *= Permutations::cnk($prev_equals +  $n_digits ,$prev_equals + 1);
        }
        else
        {
          $perm *= Permutations::cnk($prev_equals + $n_digits, $prev_equals ) * ( $n_digits ) ;
        }
        $perm *= $num_digits - $n_digits + 1;
        # if( $perm % $num_digits != 0 )
        # {
          # print "Bug ! $perm \n";
          # print "$perm  \n";
          # <STDIN>;
        # }
        $count =  ($count + $perm/ $num_digits)%$modulo;
      }
      elsif($target > $tab_squares[$i] )
      {
        if($i == $max_digit)
        {
          $count += find_sol($n_digits-1, $target - $tab_squares[$i], $i, $current_perm, $prev_equals+1);
        }
        else
        {
          $count += find_sol($n_digits-1, $target - $tab_squares[$i], $i, $current_perm * Permutations::cnk($prev_equals + $n_digits,$prev_equals), 1);
        }
      } 
    }
  }
  return $count%$modulo;
}