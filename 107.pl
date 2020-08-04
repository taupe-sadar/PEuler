use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum min max );

open( FILE, "107_network.txt" );
my($line)="";
my(@network)=();
while(defined($line=<FILE>))
{
  chomp($line);
  my(@array)=split(',',$line);
  push(@network,\@array);
}
close( FILE );

my($initial_sum)=0;
for(my($i)=0;$i<=$#network;$i++)
{
  for(my($j)=0;$j<=$#network;$j++)
  {
    if( $network[$i][$j] ne "-" )
    {
      $initial_sum += $network[$i][$j];
    }
  }
}
$initial_sum/=2;

my($rminimal_network) = find_minimal_network ( \@network );

my($sum_of_minimal)=0;
for(my($i)=0;$i<=$#$rminimal_network;$i++)
{
  $sum_of_minimal += sum(@{$$rminimal_network[$i]} );
}
$sum_of_minimal/=2;

print ($initial_sum - $sum_of_minimal);

sub find_minimal_network
{
  my( $rnetwork )=@_;
  my($size)=$#$rnetwork+1;
  my(@minimal_network)=();
  my(%edges_reached)=();
  my(%edges_unreached)=();
  for(my($i)=0;$i<$size;$i++)
  {
    $minimal_network[$i]=[];
    for(my($j)=0;$j<$size;$j++)
    {
      $minimal_network[$i][$j]=0;
    }
    $edges_unreached{$i} = 1; 
  }
  
  my($i,$j)= find_lowest_edge( $rnetwork );
  delete( $edges_unreached{$i} );
  delete( $edges_unreached{$j} );
  $edges_reached{$i} = 1;
  $edges_reached{$j} = 1;
  $minimal_network[$i][$j] = $$rnetwork[$i][$j];
  $minimal_network[$j][$i] = $$rnetwork[$j][$i];
  my(@keys)= (keys(%edges_unreached)); 
  while( $#keys >=0 )
  {
    my($k,$l)=find_lowest_node_connected_to_reached($rnetwork, \%edges_unreached, \%edges_reached);
    $minimal_network[$k][$l] = $$rnetwork[$k][$l];
    $minimal_network[$l][$k] = $$rnetwork[$l][$k];
    delete( $edges_unreached{$k} );
    $edges_reached{$k} = 1;
    @keys= (keys(%edges_unreached));
  }
  return \@minimal_network;
}

sub find_lowest_edge
{
  my($rnet)=@_;
  my(@argmin)=();
  my($min)="-";
  for(my($i)=0;$i<=$#$rnet;$i++)
  {
    for(my($j)=0;$j<$i;$j++)
    {
      if( $$rnet[$i][$j] ne '-' )
      {
        if( $min eq "-" || $$rnet[$i][$j] < $min )
        {
          $min = $$rnet[$i][$j];
          @argmin = ( $i ,$j) ;
        }
      }
    }
  }
  return @argmin;
}

sub find_lowest_node_connected_to_reached
{
  my($rnet,$runreached,$rreached)=@_;
  my(@argmin)=();
  my($min)="-";
  my($k,$l);
  foreach $k (keys(%$runreached))
  {
    foreach $l (keys(%$rreached))
    {
      if( $$rnet[$k][$l] ne '-' )
      {
        if( $min eq "-" || $$rnet[$k][$l] < $min )
        {
          $min = $$rnet[$k][$l];
          @argmin = ( $k ,$l) ;
        }
      }
    }
  }
  return @argmin;
}
