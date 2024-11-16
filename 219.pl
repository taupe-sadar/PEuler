#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( min max );

# A prefix-free code of size n may be represented as a binary tree, with n leaves
# The code with lowest cost can be computed by at all subtrees recursively.
# Suppose that a code as i elements starting by 0, n-i starting by 1, the cost 
# will be : cost_of_1 * i + cost_of_subtree_starting_by_1
#           + cost_of_0 * (n - i)+ cost_of_subtree_starting_by_0
#
# As we can compute the mininimal cost s(n) recursively, we have
#   s(1) = 0
#   s(n) = min( s(i) + s(n-i) + 4*i + (n-i) ) ( for i in [1;n-1])
#
# We reformulate, using the difference of costs d(n) = s(n) - s(n-1) 
#   d(2) = s(2) - s(1) = 5
#   d(n) = -s(n-1) + n + min( s(1) + s(n-1) + 3 , s(2) + s(n-2) + 3* 2, ...)
#   d(n) = n+3 + min( 0 , s(2) - s(1) - (s(n-1) - s(n-2)) + 3, ... )
#   d(n) = n+3 - max ( 0, d(n-1) - d(2) - 3, d(n-1) - d(2) - 3 + d(n-2) - d(3) - 3, ... )
# Here we identify r(k,j) = d(k) - d(j) - 3, which makes things clearer
#   d(n) = n+3 - max_i( sum_j( r(n+1 - j,j) ) ) ( for i in [1;n-1]) ( for j in [2;i] )
#
# Here starts a painful recursive proof.
# It consists in :
#  (1) d(n) is increasing
#  Thanks to this, we see that there is an idx IDX(n), such that 
#    r(n,x)>=0 for x < IDX(n) , and r(n,x) < 0 if x >= IDX(n)
#  Introducing now m_k the 'milestones', such that for all x in [m_k,m_k+1[ d(x) = k.
#    for each x in [m_k,m_k+1[
#    r(x,y)=0 <=> d(x) - d(y) - 3 = 0 <=> d(y)= k-3 
#    then y is in [m_k-3,m_k-2[, and IDX(m_k) = IDX(m_k-1) + m_k-2 - m_k-3


my($num_codes)=10**9;

my($skew)=0;
my($d)=5;
my(@lm)=();
for(my($i)=0;$i<4;$i++)
{
  push(@lm,1);
  $skew+=$d;
  $d++;
}

my($mm)=6;
while(1)
{
  my($new_l)=$lm[3]+$lm[0];
  my($limit)=$new_l + $mm;
  if( $limit <= $num_codes )
  {
    $skew += $d * $new_l;
  }
  else
  {
    $skew += $d * ($num_codes+1 - $mm);
    last;
  }
  # print "d=$d : $new_l -> [$mm;".($mm+$new_l - 1)."] [skew : $skew]\n";
  
  
  shift(@lm);
  push(@lm,$new_l);
  $mm+=$new_l;
  
  
  $d++;
  
  # print Dumper \@lm;<STDIN>;
}

print $skew;









