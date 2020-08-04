use strict;
use warnings;
use Data::Dumper;
use Prime;
use List::Util qw( sum max min );

my($max)=50*10**6;
my($total)=0;


my($highest_prime)=int(sqrt($max - 2**3 - 2**4));
my(@prime_list)=();
my($p)=Prime::next_prime();
while( $p <= $highest_prime )
{
  push(@prime_list,$p);
  $p=Prime::next_prime();
}
push(@prime_list,$p);

my(%square_plus_cube_hash)=();
my($square_idx)=0;
my($square)=($prime_list[ $square_idx ]**2);

while( $square < $max )
{
  my($cube_idx)=0;
  my($cube_plus_square)=$square + $prime_list[ $cube_idx ]**3;
  while( $cube_plus_square < $max )
  {
    #print "$square $cube_plus_square\n";<STDIN>;
    $square_plus_cube_hash{$cube_plus_square} = 1;
    $cube_idx++;
    $cube_plus_square = $square + ($prime_list[ $cube_idx ]**3);
  }
  $square_idx++;
  $square=$prime_list[ $square_idx ]**2;
}
my(%sums)=();
my($k);
foreach $k  (keys(%square_plus_cube_hash))
{
  my($quad_idx)=0;
  my($quad_cube_square)=($k + $prime_list[ $quad_idx ]**4);
  while( $quad_cube_square  < $max )
  {
    $sums{ $quad_cube_square } =1;
    $quad_idx++;
    $quad_cube_square=($k + $prime_list[ $quad_idx ]**4);
  }
}

print scalar( keys(%sums));
