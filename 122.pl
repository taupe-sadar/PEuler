use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

my( $largest_exp_needed ) = 200;

my($rexponent_chains)=[[1]];
my($mult_needed)=0;

my(%best_exponentiation)=( 1=> 0);
my($min_not_found)=2;

my($smallest_useful)=1;
my($max_ever_possible_mult)= floor( log( $largest_exp_needed + 1)/log(2) - 1 ) * 2;
$max_ever_possible_mult --; #because 128 may be reach in 11 mults;
while( $min_not_found <= $largest_exp_needed  )
{
  $mult_needed++;
  $rexponent_chains = build_superior_chains( $rexponent_chains );
  #print_chains( $rexponent_chains );<STDIN>;
  select_new_best_exponents( $mult_needed, $rexponent_chains );
  update_min_not_found( );
  update_smallest_useful($max_ever_possible_mult - $mult_needed  );
  my(@s)=sort({$a<=>$b} keys(%best_exponentiation));
  print Dumper \@s;

  print "$mult_needed : ".($#$rexponent_chains+1)." ( min_not_found = $min_not_found) (smallest useful = $smallest_useful) \n";<STDIN>;
}

sub build_superior_chains
{
  my($rchains)=@_;
  my(@new_chains)=();
  for(my($i)=0;$i<=$#$rchains;$i++)
  {
    push( @new_chains, superior_chain( $$rchains[$i] ) ); 
  }
  return \@new_chains
}

sub superior_chain
{
  my( $rchain )=@_;
  my( @new_chains ) = ();
  my($max)=$$rchain[-1];
  my(%already_used_items)=();
  for(my($a)=$#$rchain;$a>=0;$a--)
  {
    my($double)=2*$$rchain[$a];
    last if( $double <= $max );
    if( !exists( $already_used_items{ $double} ) )
    {
      push( @new_chains, [ @$rchain, $double ] )  if( is_valid( $double));
      $already_used_items{ $double } = 1;
    }
    for(my($b)=$a-1;$b>=0;$b--)
    {
      my($new_item)= $$rchain[$a] + $$rchain[$b];
      last if( $new_item <= $max );
      next if( exists( $already_used_items{ $new_item } ));
      push( @new_chains, [ @$rchain, $new_item ] )  if( is_valid( $new_item));
      $already_used_items{ $new_item } = 1;
    }
          
  }
  return @new_chains;
}
 
sub select_new_best_exponents
{
  my($multplications,$rchains)=@_;
  for(my($i)=0;$i<=$#$rchains;$i++)
  {
    my($number)= $$rchains[$i][-1];
    if( !exists($best_exponentiation{ $number } ) )
    {
      $best_exponentiation{ $number } = $multplications;
    }
  }
}

sub print_chains
{
  my($rchains)=@_;
  for(my($a)=0;$a<=$#$rchains;$a++)
  {
    for(my($b)=0;$b<=$#{$$rchains[$a]};$b++)
    {
      print $$rchains[$a][$b];
      print " ";
    }
    print "\n";
  }
}

sub update_min_not_found
{
  while( exists( $best_exponentiation{$min_not_found} ) )
  {
    $min_not_found++;
  }
}

sub update_smallest_useful
{
  my( $mult_left  ) = @_;
  $smallest_useful = ceil( $min_not_found/(2**($mult_left-1)) );
}


sub is_valid
{
  my($n)=@_;
  return ( $n <= $largest_exp_needed && $n >= $smallest_useful );
}


