use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum max min );
use POSIX qw/floor/;

# For 2 differents spheres, of radius r_i and r_j, stacked in a horizontal pipe of radius R
# The vertical and horizontal distance between circle radius verify :
#     h^2 + v^2 = (r_i + r_j)^2
#     r_i + v + r_j = 2*R
# So 
#     v^2 = (r_i + r_j)^2 - (2*R - r_i -r_j)^2
#     v = 2 * sqrt(R*(R - r_i -r_j))
#
# Let us consider the sequence of stacked spheres, r_1 , ... , r_n
# The distance between two sphers centers is d_ij = 2 * sqrt(R*(R - r_i -r_j))
# For a subsquence of spheres : r_i , r_i+1 , ... , r_j-1, r_j, let us suppose that r_i < r_j and r_i+1 > r_j-1
# 
# There exists s in [0,1] such that r_i+r_i+1 =   s  *(r_i+r_j-1) + (1-s)*(r_i+1 + r_j)
# And then                          r_j-1+r_j = (1-s)*(r_i+r_j-1) +   s * (r_i+1 + r_j)
# Using sqrt concavity:
#   sqrt( R - r_i-r_i+1 ) > s * sqrt( R - r_i - r_j-1 ) + (1-s)*sqrt(R - r_i+1 - r_j)
#   sqrt( R - r_j-1-r_j ) > (1-s) * sqrt( R - r_i - r_j-1 ) + s*sqrt(R - r_i+1 - r_j)
# So:
#   sqrt( R - r_i-r_i+1 ) + sqrt( R - r_j-1-r_j ) > sqrt( R - r_i - r_j-1 ) + sqrt(R - r_i+1 - r_j)
#
# That means that a better arrangement of spheres can be found, by reversing the sequence of spheres between 
# spheres i and j : r_i , r_j-1 , r_j-2, ... , r_i+2, r_i+1, r_j
# 
# So if any subsequence (i,...,j) verify (r_i < r_j AND and r_i+1 > r_j-1) OR (r_i > r_j AND and r_i+1 < r_j-1)
# then, a sequence with a shorter horizontal distance can be found.
# If no such subsequence can be found, we call that sequence a minimal solution
# 
# The algorithm finds all minimal solutions for a given sequence size
# Finally, it compares size of all minimal solutions


my($main_radius)=50;

my(@radius)=(30..50);
my($best)=10**12;
my($best_idx)=-1;
my($best_list)=[];
my($arrs)=minimal_arrangements($#radius+1);

for(my($i)=0;$i<=$#$arrs;$i++)
{
  my(@arranged_radius)=();
  for(my($j)=0;$j<=$#{$$arrs[$i]};$j++)
  {
    push(@arranged_radius,$radius[$$arrs[$i][$j]]);
  }
  my($length)=list_length(\@arranged_radius,$main_radius);
  if($length<$best)
  {
    $best = $length;
    $best_idx = $i;
    $best_list = \@arranged_radius;
  }
}
# print "Best : $best_idx ($best)\n";
# print "[".join(",",@$best_list)."]\n";
print floor($best*1000 + 0.5);


sub minimal_arrangements
{
  my($n)=@_;
  if( $n == 3 )
  {
    return [[0,1,2],[0,2,1],[1,0,2],[1,2,0],[2,0,1],[2,1,0]];
  }
  else
  {
    my($arrangements)=minimal_arrangements($n-1);
    my(@valids)=();
    for my $arr (@$arrangements)
    {
      my($lower_than)=$n-1;
      my($higher_than)=0;
      
      for(my($i)=0;$i<=$#$arr-2;$i++)
      {
        if($$arr[$i+1]>$$arr[-1])
        {
          $lower_than = min($lower_than,$$arr[$i]);
        }
        else
        {
          $higher_than = max($higher_than,$$arr[$i]+1);
        }
      }
      
      # print (join("",@$arr)." : $lower_than -> $higher_than\n");<STDIN>;
      
      for(my($v)=$higher_than;$v<=$lower_than;$v++)
      {
        my(@valid)=(@$arr,$v);
        for(my($j)=0;$j<$#valid;$j++)
        {
          $valid[$j]++ if($valid[$j]>=$v);
        }
        push(@valids,\@valid);
      }
    }
    return \@valids;
  }
}

sub list_length
{
  my($rlist,$r)=@_;
  my($s)=$$rlist[0];
  for(my($i)=0;$i<$#$rlist;$i++)
  {
    $s+=dist($$rlist[$i],$$rlist[$i+1],$r);
  }
  $s+=$$rlist[-1];
  return $s;
}


sub dist
{
  my($r1,$r2,$r)=@_;
  return 2*sqrt($r*($r1+$r2 - $r));
}

