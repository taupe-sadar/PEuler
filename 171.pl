use strict;
use warnings;
use Data::Dumper;

my($num_digits)=20;
my($base_modulo)=10**9;

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
my(%square_sums) = calc_square_sums($num_digits);

my($total)=0;
foreach my $s (@squares)
{
  $square_sums{$s} = [0,0] if(!exists($square_sums{$s}));
  # print " $s : $sols{$s}[0]\n";
  $total = ($total + $square_sums{$s}[0])%$base_modulo;
}
print $total;

sub calc_square_sums
{
  my($n_digits)=@_;
  
  my($rvalues)={};
  for(my($i)=0;$i<=9;$i++)
  {
    $$rvalues{$tab_squares[$i]} = [$i,1];
  }
  
  my($exp)=10;
  for(my($d)=2;$d<=$n_digits;$d++)
  {
    my(%new_values)=();
    
    for(my($j)=0;$j<=9;$j++)
    {
      my($val)=$j*$exp;
      foreach my $s (keys(%$rvalues))
      {
        my($new_key) = $s + $tab_squares[$j];
        $new_values{$new_key} = [0,0] if(!exists($new_values{$new_key}));
        
        my($base)=$$rvalues{$s}[0];
        my($count)=$$rvalues{$s}[1];
        $new_values{$new_key}[0] = ($new_values{$new_key}[0] + $val*$count + $base) % $base_modulo;
        $new_values{$new_key}[1] = ($new_values{$new_key}[1] + $count) % $base_modulo;
      }
    }
    
    $rvalues=\%new_values;
    $exp= ($exp * 10) % $base_modulo;
  }
  return %$rvalues;
}