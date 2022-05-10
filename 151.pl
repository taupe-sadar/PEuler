use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum );
use Gcd;
use Math::BigInt;
use Fraction;

my(%all_probas)=();


my(%states)=( "1-1-1-1" => Fraction->new(Math::BigInt->new(1),(1)) );

while(keys(%states))
{
  my(%new_states)=();
  
  foreach my $e (keys(%states))
  {
    my(%next_states)= nextPiecesState($e);
    foreach my $new_e (keys(%next_states))
    {
      my($f)= $next_states{$new_e} * $states{$e};
      
      if( !exists( $new_states{$new_e} ))
      {
        $new_states{$new_e} = $f;
      }
      else
      {
        $new_states{$new_e} = $new_states{$new_e} + $f;
      }
    }
  }
  %states = %new_states;
  %all_probas = (%all_probas,%states);
}

my($final_proba)= $all_probas{"0-0-1-0"} + $all_probas{"0-1-0-0"} + $all_probas{"1-0-0-0"};

print crapyround( $final_proba,6 );



sub crapyround
{
  my($f,$precision)=@_;
  my($exp)=1;
  for(my($i)=0;$i<$precision;$i++)
  {
    $exp*=10 ;
  }
  my($val)=$f->numerator()*10*$exp/$f->denominator();
  my($strval)=$val->bstr();
  my($last_digit)= $strval % 10;
  my($round)=( $last_digit >= 5 )?1:0;
  
  return (($strval - $last_digit)/10 + $round)/$exp;
}


sub addAndReduce
{
  my(@fractions)=@_;
  
  
  my($first_frac)=$fractions[0];
  if( $#fractions == 0 )
  {
    my($d)= Gcd::pgcd( $$first_frac[0], $$first_frac[1] );
    return [$$first_frac[0]/$d, $$first_frac[1]/$d];
  }
  else
  {
    my($rsub)=addAndReduce(@fractions[1..$#fractions]);
    
    my(@f)=($$first_frac[0]*$$rsub[1]+$$first_frac[1]*$$rsub[0], $$first_frac[1]*$$rsub[1]);
    
    my($d)= Gcd::pgcd( $f[0], $f[1] );
    return [$f[0]/$d, $f[1]/$d];
  }
}


sub nextPiecesState
{
  my($pieces_description)=@_;
  my(@pieces)=split("-",$pieces_description);
  my($all_sum)=sum(@pieces);
  my(%probas)=();
  
  for(my($i)=0;$i<=$#pieces;$i++)
  {
    next unless($pieces[$i] > 0);
    
    my(@new_pieces)=();
    for(my($j)=0;$j<$i;$j++)
    {
      $new_pieces[$j]=$pieces[$j];
    }
    $new_pieces[$i]=$pieces[$i]-1;
    for(my($j)=$i+1;$j<=$#pieces;$j++)
    {
      $new_pieces[$j]=$pieces[$j]+1;
    }
    $probas{join('-',@new_pieces)} = Fraction->new( $pieces[$i], $all_sum );
  }
  return %probas;
}