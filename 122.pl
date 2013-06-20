use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor ceil/;
use List::Util qw(max min );

my( $largest_exp_needed ) = 200;

my($rexponent_chains)=[[1]];

my(%best_exponentiation)=( 1=> 0);
my(@suboptimal_exponentiation)=();
for(my($i)=0;$i<=$largest_exp_needed;$i++){ $suboptimal_exponentiation[$i]=0; }

optimal_binary( \@suboptimal_exponentiation, $largest_exp_needed );
recompute_suboptimal( \@suboptimal_exponentiation, $largest_exp_needed );

for(my($a)=0;$a<=$#suboptimal_exponentiation;$a++)
{
  print " $a : $suboptimal_exponentiation[$a]\n";
}<STDIN>;

my($mult_needed)=0;
my($min_not_found)=2;
my($smallest_useful)=1;
while( $min_not_found <= $largest_exp_needed  )
{
  $mult_needed++;
  $rexponent_chains = build_superior_chains( $rexponent_chains );
  select_new_best_exponents( $mult_needed, $rexponent_chains );
  
  update_min_not_found( );
  update_suboptimal_with_best_optimal( \@suboptimal_exponentiation,$largest_exp_needed  );
  update_smallest_useful( \@suboptimal_exponentiation, $mult_needed  );
  
  for(my($i)=0;$i<=$largest_exp_needed;$i++)
  {
    my($best)=exists($best_exponentiation{$i})?$best_exponentiation{$i}:"  -";
    print "  ".sprintf('%3s',$i)." ".sprintf('%3s',$suboptimal_exponentiation[$i])." ".sprintf('%3s',$best)."\n";
  }
  
  #########" Debug ###########
  if( $mult_needed == 6 )
  {
    for( my($i)=0; $i<=$#$rexponent_chains;$i++)
    {
      if($$rexponent_chains[$i][-1]==23)
      {
        print Dumper $$rexponent_chains[$i];<STDIN>;
      }
    }
  }
  ##############"
  
  print "$mult_needed : ".($#$rexponent_chains+1)." ( min_not_found = $min_not_found) (smallest useful = $smallest_useful) \n";<STDIN>;
}

sub optimal_binary
{
  my($rsuboptimal,$max)=@_;
  my(@best)=(0,0);
  
  my($high_exposant)=1;
  for(my($exp)=1;$exp <= floor(log($max)/log(2));$exp++)
  {
    $high_exposant*=2;
    for(my($nb)=$high_exposant;$nb<min($max+1,2*$high_exposant);$nb++)
    {
      $best[$nb]=$exp;
    }
  }
  
  $high_exposant=1;
  for(my($exp)=0;$exp < floor(log($max)/log(2));$exp++)
  {
    for(my($base)=3*$high_exposant;$base<=$max;$base+=2*$high_exposant)
    {
      for(my($nb)=$base;$nb<min($max+1,$base+$high_exposant);$nb++)
      {
        $best[$nb]++;
      }
    }
    $high_exposant*=2;
  }
  
  for(my($i)=0;$i<=$max;$i++)
  {
    $$rsuboptimal[$i] = max( $$rsuboptimal[$i], $best[$i] );
  }
}

sub optimal_factor
{
  my($rsuboptimal,$max)=@_;
  Prime::init_crible($max);
  Prime::next_prime();#flushing 2;
  my(@factor_suboptimal)=(0,0);
  for(my($i)=1;$i<=$max;$i++)
  {
    $factor_suboptimal[$i]=$$rsuboptimal[$i];
  }
  my($p)=Prime::next_prime(); 
  while( $p*$p <= $max )
  {
    for(my($i)=3;$i<=($max/$p);$i+=2)
    {
      $factor_suboptimal[$p*$i] = min( $factor_suboptimal[$p*$i], $factor_suboptimal[$p] + $factor_suboptimal[$i]);
    }
    $p=Prime::next_prime();
  }

  for(my($i)=2;$i<=($max/2);$i++)
  {
    $factor_suboptimal[2*$i] = min( $factor_suboptimal[2*$i], $factor_suboptimal[$i] + 1);
  }
  
  my($changes_done)=0;
  for(my($i)=1;$i<=$max;$i++)
  {
    next unless(defined($factor_suboptimal[$i]));
    if( $factor_suboptimal[$i] < $$rsuboptimal[$i])
    {
      print "$i : $$rsuboptimal[$i] <- $factor_suboptimal[$i]\n";
      $$rsuboptimal[$i] = $factor_suboptimal[$i];
      $changes_done = 1;
    }
  }
  return $changes_done;
  
}

sub close1and2
{
  my($rsuboptimal,$max)=@_;
  my($changes_done)=0;
  for(my($i)=4;$i<=$max;$i++)
  {
    my($old_exponentiation)=min( $$rsuboptimal[$i-1], $$rsuboptimal[$i-2] );
    if( $$rsuboptimal[$i] > ($old_exponentiation+1) )
    {
      print "$i : $$rsuboptimal[$i] <- ".($old_exponentiation+1)."\n";
      $$rsuboptimal[$i] = ($old_exponentiation+1);
      $changes_done = 1;
    }
  }
  return $changes_done;
}

sub recompute_suboptimal
{
  my($rsuboptimal,$max)=@_;
  my($changes)=1;
  while( $changes )
  {
    $changes=optimal_factor( $rsuboptimal, $max );
    $changes|=close1and2( $rsuboptimal, $max );
  }
}

sub build_superior_chains
{
  my($rchains)=@_;
  my(@new_chains)=();
  for(my($i)=0;$i<=$#$rchains;$i++)
  {
    push( @new_chains, superior_chain( $$rchains[$i] ) ); 
  }
  return \@new_chains;
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
    last if( $double <= $max || $double < $smallest_useful );
    if( !exists( $already_used_items{ $double} ) )
    {
      push( @new_chains, [ @$rchain, $double ] )  if( is_valid( $double));
      $already_used_items{ $double } = 1;
    }
    for(my($b)=$a-1;$b>=0;$b--)
    {
      my($new_item)= $$rchain[$a] + $$rchain[$b];
      last if( $new_item <= $max || $new_item < $smallest_useful);
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

sub update_suboptimal_with_best_optimal
{
  my( $rsuboptimal_calculated,$max ) = @_;
  my($i);
  my($changes_done)= 0;
  foreach $i (keys(%best_exponentiation))
  {
    if( $best_exponentiation{$i} < $$rsuboptimal_calculated[$i] )
    {
      print "Best for $i : $$rsuboptimal_calculated[$i] <- $best_exponentiation{$i}\n";
      $$rsuboptimal_calculated[$i] = $best_exponentiation{$i};
      $changes_done = 1;
    }
  }
  if( $changes_done )
  {
    recompute_suboptimal($rsuboptimal_calculated,$max);
  }
}

sub update_smallest_useful
{
  my( $rsuboptimal_calculated, $mult_current  ) = @_;
  my(@smallest_useful_from_suboptimal)=();
  for(my($i)=$min_not_found;$i<=$#$rsuboptimal_calculated;$i++)
  {
    if( !exists( $best_exponentiation{$i} ) )
    {
      my($step_needed)= $$rsuboptimal_calculated[$i] - $mult_current;
      if( !defined( $smallest_useful_from_suboptimal[$step_needed] ) )
      {
        $smallest_useful_from_suboptimal[$step_needed] = ceil($i/(2**($step_needed-1)));
      }
    }
  }
  shift(@smallest_useful_from_suboptimal);
  print Dumper \@smallest_useful_from_suboptimal;<STDIN>;
  $smallest_useful = min( @smallest_useful_from_suboptimal );
}


sub is_valid
{
  my($n)=@_;
  return ( $n <= $largest_exp_needed );
}


