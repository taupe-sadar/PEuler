use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);

# State vector of size 6, the value of the state is :  
# 3 * (num_late) + (num_consecutive absences)
# with num_late is in [0,1] and num_consecutive absences in [0,2]
# Here is the transition matrix
# 
# [new char]  0   L   A  
# 0 ()    :   0   3   1
# 1 (A)   :   0   3   2
# 2 (AA)  :   0   3   X
# 3 (L)   :   3   X   4
# 4 (LA)  :   3   X   5
# 5 (LAA) :   3   X   X


my($st)=[1,0,0,0,0,0];

my($prize_lengh)=0;
my($max)=30;

while($prize_lengh++<$max)
{
  my(@new_state)=(0)x6;
  $new_state[0] = $$st[0] + $$st[1] + $$st[2];
  $new_state[1] = $$st[0];
  $new_state[2] = $$st[1];
  $new_state[3] = $$st[0] + $$st[1] + $$st[2] + $$st[3] + $$st[4] + $$st[5];
  $new_state[4] = $$st[3];
  $new_state[5] = $$st[4];
  $st = \@new_state;
}

print sum(@$st);

