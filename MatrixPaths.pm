package MatrixPaths;
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );


my(@bigdata)=();
my(@bestdistance)=();
my($size)=-1;

my(%shortestpaths)=();
my(@shortestpaths_sorted_keys)=();

sub get_bestdistance
{
  my($x,$y)=@_;
  return $bestdistance[$x][$y];
}

sub compute_if_not_available
{
  my($x,$y,$dir)=@_;
  my($x2,$y2)=($x,$y);
  if( $dir eq 'up' )
  {
    if( $x <=0 )
    {
      return -1;
    }
    $x2--;
  }
  elsif( $dir eq 'down' )
  {
    if( $x >= ($size-1  ) )
    {
      return -1;
    }
    $x2++;
  }
  elsif( $dir eq 'left' )
  {
    if( $y <= 0 )
    {
      return -1;
    }
    $y2--;
  }
  elsif( $dir eq 'right' )
  {
    if( $y >= ($size-1) )
    {
      return -1;
    }
    $y2++;
  }
  else 
  {
    die "'$dir' not known\n";
  }
  
  if( $bestdistance[$x2][$y2] == -1 )
  {
    $bestdistance[$x2][$y2] = $bestdistance[$x][$y] + $bigdata[$x2][$y2];
    $shortestpaths{"$x2-$y2"} = $bestdistance[$x2][$y2];
    insert_sort("$x2-$y2");
    return $bestdistance[$x2][$y2];
  }
  else
  {
    return -1;
  }
}

sub compute_min_up_left
{
  my($x,$y)=@_;
  if( $x == 0 && $y == 0)
  {
    $bestdistance[0][0] = $bigdata[0][0];
  }
  elsif( $x == 0)
  {
    $bestdistance[0][$y] = $bigdata[0][$y] + $bestdistance[0][$y-1];
  }
  elsif( $y == 0)
  {
    $bestdistance[$x][0] = $bigdata[$x][0] + $bestdistance[$x-1][0];
  }
  else
  {
    $bestdistance[$x][$y] = $bigdata[$x][$y] + min($bestdistance[$x-1][$y],$bestdistance[$x][$y-1]);
  }
}

sub set_start
{
  my($x,$y)=@_;
  $bestdistance[$x][$y] = $bigdata[$x][$y];
  $shortestpaths{"$x-$y"}= $bigdata[$x][$y];
}

sub sort_shortest_keys
{
  @shortestpaths_sorted_keys= sort( {$shortestpaths{$a} <=> $shortestpaths{$b}} keys(%shortestpaths));
}

sub init
{
  my($file)=@_;
  
  open(FILE,$file);
  my(@tab)=<FILE>;
  close(FILE);
  
  for(my($i)=0;$i<=$#tab;$i++)
  {
    chomp($tab[$i]);
    my(@t)= split(",",$tab[$i]);
    $bigdata[$i]=\@t;
    $bestdistance[$i]=[];
    for(my($j)=0;$j<=$#t;$j++)
    {
      $bestdistance[$i][$j]=-1;
    }
  }
  $size=$#tab+1;
  return ($#tab+1);
}

sub get_best_distance
{
  if( $#shortestpaths_sorted_keys < 0 )
  {
    return;
  }
  
  my($k)=shift(@shortestpaths_sorted_keys);
  delete $shortestpaths{$k};
  return $k;
}

sub insert_sort
{
  my($key)=@_;
  
  my($value)=$shortestpaths{$key};
  if( $#shortestpaths_sorted_keys <0 )
  {
    @shortestpaths_sorted_keys=($key);
  }
  if($value <= $shortestpaths{$shortestpaths_sorted_keys[0]} )
  {
    unshift(@shortestpaths_sorted_keys,$key);
    return;
  }
  if($value >= $shortestpaths{$shortestpaths_sorted_keys[-1]} )
  {
    push(@shortestpaths_sorted_keys,$key);
    return;
  }
  
  my($low,$hi)=(0,$#shortestpaths_sorted_keys);
  while( 1 )
  {
    my($middle)= ($hi + $low)>>1;
    my($val_middle)=$shortestpaths{$shortestpaths_sorted_keys[$middle]};
    if( $value ==  $val_middle )
    {
      $hi = $middle+1;
      $low = $middle;
      last;
    }
    elsif( $value <  $val_middle )
    {
      $hi = $middle;
    }
    else
    {
      $low = $middle;
    }
    if ( $hi - $low <= 1)
    {
      last;
    }
  }
  @shortestpaths_sorted_keys= (@shortestpaths_sorted_keys[0..$low],$key,@shortestpaths_sorted_keys[$hi..$#shortestpaths_sorted_keys]);
}

1;
