use strict;
use warnings;
use Data::Dumper;
use Permutations;

my($max_digits)=7; #For 10**7

my($count_1)=0;
my($count_89)=0;

my(%squares_sums)=();

my(%cnk_identicals)=();


for(my($a)=0;$a<=9;$a++)
{
  loop_on_ascending_numbers($a,$a**2,$a,1,1);
}

print $count_89;

sub loop_on_ascending_numbers
{
  my($number,$number_squared,$min_value,$depth,@identical_numbers)=@_;
  if( $depth < $max_digits )
  {
    my( @new_identical)=@identical_numbers;
    $new_identical[-1]++;
    loop_on_ascending_numbers("$number$min_value",$number_squared + $min_value**2, $min_value, $depth +1 , @new_identical);
    for(my($a)=$min_value+1;$a<=9;$a++)
    {
      loop_on_ascending_numbers("$number$a", $number_squared + $a**2  , $a, $depth +1 , @identical_numbers, 1 );
    }
  }
  else
  {
    my($end_of_chain)= process_square_chain( $number_squared );
    my($str_identical)=join("",sort(@identical_numbers));
    if( !exists($cnk_identicals{$str_identical}) )
    {
	    $cnk_identicals{$str_identical} = Permutations::permutations_with_identical( @identical_numbers );
    }
    if( $end_of_chain == 89 )
    {
	    $count_89 += $cnk_identicals{$str_identical};
    }
    elsif( $end_of_chain == 1)
    {
	    $count_1 += $cnk_identicals{$str_identical};
    }
    elsif( $end_of_chain != 0 ) # 0 will be reach the first time
    {
	    die "Not forseen end of chain $end_of_chain\n";
    }
  }
}

sub process_square_chain
{
  my($number)=@_;
  
  if( exists( $squares_sums{$number} ))
  {
    return $squares_sums{ $number };
  }
  elsif( $number == 0 || $number == 89 || $number == 1)
  {
    $squares_sums{ $number } = $number;
    return $number;
  }
  #else
    
  my($sq) = sum_square_digits( $number );
  my($end)= process_square_chain( $sq );
  $squares_sums{ $number } = $end;
  return $end;
}


sub sum_square_digits
{
  my($n)=@_;
  my(@t)=split(//,$n);
  my($sumsquare)=0;
  for(my($i)=0;$i<=$#t;$i++)
  {
    $sumsquare += $t[$i]**2;
  }
  return $sumsquare;
}
