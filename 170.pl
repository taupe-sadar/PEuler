use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max );
use POSIX qw/floor/;

# We have a factor "f", operands "n_i", and products "p_i" : 
#   f x n_1 = p_1
#   ...
#   f x n_i = p_i
#
# Two cases : 
#  1) the factor f < 10
#     there may be several oprands, and only one of them leads to a product with one more digit in its product
#     the other operands as the same number of digits than their products
#  2) the factor f >= 10
#     there are only 2 operands, and their product have both one more digits
#
#  The algorithm, is then a systematic search. 
#  The only optimisation is considering that the factor that is a multiple of 3
#  As a proof : if the factor is not multiple of 3, then the concatened operand are not either 
# (because they contain all the numbers 0 to 9). Biut the product is, which is a contradiction.

my($final)=0;
for(my($i)=3;$i<=96;$i+=3)
{
  next if($i%10 == 0 || $i%11 == 0);
  my($count,$top)=concatened_pandigital($i);
  # print "$i : $count, max = $top\n";
  $final = max($final,$top);
}
print $final;

sub concatened_pandigital
{
  my($factor)=@_;
  
  my(%used)=();
  my(%res_used)=();
  for(my($i)=0;$i<=9;$i++)
  {
    if( $factor < 10 )
    {
      $used{$i} = ($i == $factor) ? 1 : 0;
    }
    else
    {
      $used{$i} = ($i == $factor%10 || $i == floor($factor/10)) ? 1 : 0;
    }
    $res_used{$i} = 0;
  }
  return build_pandigital_recursive($factor,\%used,\%res_used,[],0,[],0);
}

sub build_pandigital_recursive
{
  my($factor,$rused,$rres_used,$rseq,$left_over,$rleftovers,$second_term)=@_;
  my($maximum)=0;
  my($count)=0;
  for(my($i)=0;$i<=9;$i++)
  {
    next if( $$rused{$i} );
    my($x)=$factor*$i + $left_over;
    my($left)= $x%10;
    next if($$rres_used{$left});
  
    my($div)= ($x - $x%10)/10;
    
    push(@$rseq,$i);
    push(@$rleftovers,(($div > 0) ? 1 : 0));
    $$rused{$i} = 1;
    $$rres_used{$left} = 1;
  
    if( $factor < 10 && $#$rseq == 8 && $i > 0 && $div != 0 && !($$rres_used{$div}) )
    {
      my(@numbers)=();
      my($last_used_idx)=-1;
      for(my($idx)=0;$idx<=8;$idx++)
      {
        if(!$$rleftovers[$idx])
        {
          push(@numbers,make_number($rseq,$last_used_idx+1,$idx));
          $last_used_idx=$idx;
        }
      }
      if($last_used_idx < 8 )
      {
        push(@numbers,make_number($rseq,$last_used_idx+1,8));
      }
      
      for(my($j)=0;$j<=$#numbers;$j++)
      {
        if( $numbers[$j] =~ m/^0/)
        {
          if( $j> 0 || $numbers[$j] > 0 )
          {
            $numbers[$j+1].=$numbers[$j];
            splice(@numbers,$j,1)
          }
        }
      }
      
      @numbers = sort_numbers(\@numbers,$factor);
      
      if( $#numbers >= 1)
      {      
        $maximum=max($maximum,join("",map({ $factor * $_} @numbers)));
        $count++;
      }   
    }
    elsif( $factor >= 10 && $#$rseq == 7 && $i > 0 && $second_term > 0 && $div != 0 && $div < 10 && !($$rres_used{$div}) )
    {
      my(@numbers)=(make_number($rseq,0,$second_term-1),make_number($rseq,$second_term,7));
      @numbers=sort_numbers(\@numbers,$factor);
      $maximum=max($maximum,join("",map({ $factor * $_} @numbers)));
      $count++;
    }
    else
    {
      my($c,$m)=build_pandigital_recursive($factor,$rused,$rres_used,$rseq,$div,$rleftovers,$second_term);
      $maximum=max($m,$maximum);
      $count+=$c;
    }
    
    $$rres_used{$left} = 0;
    $$rused{$i} = 0;
    pop(@$rleftovers);
    pop(@$rseq);
  }
  
  if( $factor >= 10 && !$second_term && $left_over < 10 && !$$rres_used{$left_over} && $#$rseq >=0 && $#$rseq <= 6 && $$rseq[-1] > 0)
  {
    push(@$rleftovers,$left_over);
    $$rres_used{$left_over} = 1;
    my($c,$m) = build_pandigital_recursive($factor,$rused,$rres_used,$rseq,0,$rleftovers,$#$rseq+1);
    $maximum=max($m,$maximum);
    $count+=$c;
    $$rres_used{$left_over} = 0;
    pop(@$rleftovers);
  }
  return ($count,$maximum);
}

sub make_number
{
  my($rt,$first_idx,$last_idx)=@_;
  return join("",reverse(@$rt[$first_idx..$last_idx]));
}

sub sort_numbers
{
  my($rnb,$factor)=@_;
  return sort({substr($factor * $b,0,1) <=>  substr($factor * $a,0,1)} @$rnb);
}
