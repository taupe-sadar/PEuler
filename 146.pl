use strict;
use warnings;
use Data::Dumper;
use Bezout;

my($lol) = Bezout::congruence_solve((7=>4,5=>2,11=>1));
my(%possible_congruences) =  (
  2 => [ 0 ],
  3 => [ 1, 2 ],
  5 => [ 0 ],
  7 => [ 3, 4 ],
  13 => [ 1, 3, 4, 9, 10, 12 ]
);

my(@set_of_congruence) = build_set(%possible_congruences);

sub build_set
{
  my(%possibles)=@_;
  
}

print "$lol\n";

