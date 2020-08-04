use strict;
use warnings;
use Data::Dumper;
use Pythagoriciens;
use POSIX qw/floor ceil/;

my($target)= 10**6;
my($first_side_to_reach_target)=-1;


my(@list_of_equilibrated_primitifs)=();
my(@list_of_unequilibrated_primitifs)=();

my(@shortest_paths)=();

my($last_accumulated)=0;


my($min,$max)=(1,32);
my($stop)=0;
while( !$stop )
{
  my($rpythas) = Pythagoriciens::primitive_triplets_from_min_value( $min,$max );
  
  # Filling list with new primitifs 
  for(my($i)=0;$i<=$#$rpythas; $i++)
  {
    my(@kl_tab)=@{$$rpythas[$i]};
    my(@abc_tab)= Pythagoriciens::value_triplet( @kl_tab );
    my(@sorted_ab_tab)=sort( {$a <=> $b} (@abc_tab[0..1]) );
    #We will always have a<b
    my(%infos)=( "a" => $sorted_ab_tab[0], "b" => $sorted_ab_tab[1], "factor" => 0 );
    if($sorted_ab_tab[0]< ( $sorted_ab_tab[1]/2 ) )
    {
      push( @list_of_unequilibrated_primitifs, \%infos );
    }
    else
    {
       push( @list_of_equilibrated_primitifs, \%infos ); 
    }
  }

  #For all minimum values ( ie a ), consider primitive triplet * factor and score in the main tab
  #Unequilibrated triplets
  for(my($j)=0;$j<=$#list_of_unequilibrated_primitifs; $j++)
  {
    my($initial_factor)= $list_of_unequilibrated_primitifs[$j]{"factor"}+1;
    my($low)=$list_of_unequilibrated_primitifs[$j]{"a"};
    my($high)=$list_of_unequilibrated_primitifs[$j]{"b"};
    my($max_factor_to_compute)= floor( $max/$high);
    for(my($factor)=$initial_factor; $factor <= $max_factor_to_compute ; $factor++)
    {
      #Scoring for the case high = side1, low = side2 + side3
      score( $factor * $high, int( $factor*$low /2 ) );
    }  
    $list_of_unequilibrated_primitifs[$j]{"factor"} = $max_factor_to_compute;

  }

  #Equilibrated triplets
  for(my($j)=0;$j<=$#list_of_equilibrated_primitifs; $j++)
  {
    my($initial_factor)= $list_of_equilibrated_primitifs[$j]{"factor"}+1;
    my($low)=$list_of_equilibrated_primitifs[$j]{"a"};
    my($high)=$list_of_equilibrated_primitifs[$j]{"b"};

    my($max_factor_to_compute)= floor( $max/$low );
    for(my($factor)=$initial_factor; $factor <= $max_factor_to_compute ; $factor++)
    {
      #Scoring for the case high = side1, low = side2 + side3
      score( $factor * $high, int( $factor*$low /2 ) );
      #Scoring for the case low = side1, high = side2 + side3
      score( $factor * $low, int( (2*$factor*$low -$factor*$high + 2 )/2 ) );
    }
    $list_of_equilibrated_primitifs[$j]{"factor"} = $max_factor_to_compute;
  }
    
  #Check if cumulative reach the target
  for(my($m)=$min; $m<=$max; $m++)
  {
    if(defined( $shortest_paths[ $m ] ))
    {
      $last_accumulated += $shortest_paths[ $m ];
    }
    if( $last_accumulated > $target )
    {
      $first_side_to_reach_target = $m;
      $stop = 1;
      last;
    }
  }
  ($min,$max)=($max+1,$max*2); 
}

print $first_side_to_reach_target;

sub score
{
  my( $max_side, $quantity)=@_;
  if(!defined( $shortest_paths[ $max_side ] ))
  {
    $shortest_paths[ $max_side ] = $quantity;
  }
  else
  {
    $shortest_paths[ $max_side ] += $quantity;
  }
}


