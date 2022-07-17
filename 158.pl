use strict;
use warnings;
use Data::Dumper;
use Permutations;

# There are 2 adjacent chars involved in the parametrisation the char 'left' and 'right', the right follow the left lexicographically
# and only those are in this case.
#
# With an alphabet of size S (max 26) 
# We consider 3 parameters : 
# - Position of the character left (p) (0-n)
# - Value of left (0 .. S-1)
# - Value of right (0 .. S-1)
#
# ( p chars)  | left | right | ( n - p - 2 chars )
#
# We must also take into account that chars must all be different
# So we will have instead : 
#    Cnk( available choices , p )
#
# And we need two other parameters : 
# - j, which is the quantity of p chars, which value is between left and right char :
# - k, which is the quantity of n - p - 2 chars, which value is between left and right char :
# 
# ( p - j chars)    |       ( j chars)          | left | right |          ( k chars)           | ( n - p - 2 -k chars )
# 
#  S - right_val -1 |  right_val - left_val - 1 |              |  right_val - left_val - 1 - j |       left_val
#    choices        |       choices             |              |           choices             |       choices

my($alpha_size)=26;

# print Permutations::cnk(0,0)."\n";

for(my($size)=1;$size<=26;$size++)
{
  print "$size : ".count_lexileft($size,$alpha_size)."\n";
}



sub count_lexileft
{
  my($n,$S)=@_;
  my($count)=0;
  for(my($p)=0;$p<($n-1);$p++)
  {
    for(my($left)=0;$left<$S;$left++)
    {
      for(my($right)=$left+1;$right<$S;$right++)
      {
        for(my($j)=0;$j<=$p;$j++)
        {
          my($count_left) = count_subset($p - $j, $S - 1 - $right) ;
          my($count_j) = count_subset($j, $right - $left - 1);
          
          for(my($k)=0;$k<=($n - $p - 2);$k++)
          {
            my($count_right)= count_subset($k, $right - $left - 1 - $j);
            my($count_k)    = count_subset($n - $p - 2 - $k, $left );
            $count += $count_left * $count_j * $count_right * $count_k;
            # print "(".($p-$j).") ($j) [$left] [$right] ($k) (".($n-$p-2-$k).") : $count_left * $count_j * $count_right * $count_k = ".($count_left * $count_right * $count_j *$count_k)."\n";
          }
        }
        # <STDIN>;
      }
    }
  }
  return $count;
}

sub count_subset
{
  my($quantity,$choices)=@_;
  return Permutations::cnk($choices, $quantity);
}
