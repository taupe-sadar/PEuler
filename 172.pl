use strict;
use warnings;
use Data::Dumper;
use Permutations;
use List::Util qw( min max );
use POSIX qw/ceil/;

my($size)=18;
my($max_occurence)=3;

my(@seq)=();
my($count)=all_numbers(\@seq,0,$max_occurence);

print $count;

sub all_numbers
{
  my($rseq,$nb_occ_used,$max_occ)=@_;
  my($sum)=0;
  if( $nb_occ_used == $size )
  {
    print join(" ",@$rseq)."\n";
    #computade
  }
  elsif( $nb_occ_used < $size )
  {
    my($i_min) =  max( 1, ceil($size / (10 - ($#$rseq + 1))));
    for( my($i)=$max_occ; $i >= $i_min; $i-- )
    {
      push(@$rseq,$i);
      $sum += all_numbers( $rseq,$nb_occ_used + $i,$i );
      pop(@$rseq);
    }
  }
  else
  {
    print " $nb_occ_used, should not happen\n";
    print join(" ",@$rseq)."\n";
  }
  return $sum;
}
