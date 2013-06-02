use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum );
use POSIX qw/floor ceil/;

my($max_round)=15;
my(@probas)=(1,1);
my($proba_denominator)=2;

for(my($round)=2;$round<=$max_round;$round++)
{
  $proba_denominator*=($round+1);
  calc_proba( $round,\@probas );
}

my($need_for_win)=floor(($max_round+2)/2);
my($proba_win)=sum( @probas[$need_for_win..$#probas] );

my($best_reward_before_lost)=floor(($proba_denominator-1)/$proba_win);
print $best_reward_before_lost;

sub calc_proba
{
  my($round,$rprobas)=@_;
  
  $$rprobas[$round] = $$rprobas[$round-1];
  for(my($a)=$round-1;$a>0;$a--)
  {
    $$rprobas[$a] = $$rprobas[$a]*($round) + $$rprobas[$a - 1];
  }
  $$rprobas[0] = $$rprobas[0]*($round);
}
