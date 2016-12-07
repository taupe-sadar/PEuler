use strict;
use warnings;
use Data::Dumper;


my($modulo)=2**20;
my($modulo_div2)=$modulo/2;

my($size)=1000;
my($triangle_size)=$size*($size+1)/2;

my(@array)=(0)x $triangle_size;
my(@array_cumul)=(0)x $triangle_size;
my(@sum_current)=(0)x $triangle_size;


my($min)=$modulo;
my($reached)=$modulo;

my($current)=0;
my($cumul)=0;
my($idx)=0;
for(my($row)=0;$row<$size;$row++)
{
  for(my($i)=0;$i<=$row;$i++)
  {
    $current = next_val( $current );
    $array[$idx]=$current;
    $sum_current[$idx]=$current;
    
    $cumul+= $current;
    $array_cumul[$idx]=$cumul;
    
    $min = $current if( $current > $min );
    
    $idx++;
  }
  $cumul = 0;
}

# print_triangle(\@array);
# print_triangle(\@array_cumul);

for(my($trisize)=1;$trisize<$size;$trisize++)
{
  print "-- $trisize\n";
  
  my($counter)=0;
  for(my($row)=0;$row<($size-$trisize);$row++)
  {
    my($row_base)=mapping($row+$trisize,0);
    my($idx1,$idx2)=($row_base-1,$row_base+$trisize);
    for(my($idx)=0;$idx<=$row;$idx++)
    {
      my($bigsum)=$sum_current[$counter];
      $bigsum+= $array_cumul[$idx2];
      $bigsum-= $array_cumul[$idx1] if($idx>0);
      
      # print " $row - $idx : $bigsum\n";
      
      $sum_current[$counter] = $bigsum;
      $reached = "".($trisize+1)." - $row - $idx" if( $bigsum < $min );
      $min = $bigsum if( $bigsum < $min );
      
      $idx1++;
      $idx2++;
      $counter++;
    }
  }
  
  # print_triangle(\@sum_current);<STDIN>;
}

print "$min - reached : $reached\n";

sub next_val
{
  my($x)=@_;
  return ((615949*$x+797807)%$modulo-$modulo_div2);
}

sub mapping
{
  my($row,$idx)=@_;
  return ($row+1)*$row/2 + $idx;
}

sub print_triangle
{
  my($rarray)=@_;
  my($ml)=0;
  for(my($i)=0; $i < $triangle_size; $i++ )
  {
    $ml = length($$rarray[$i]) if( length($$rarray[$i]) > $ml );
  }
  
  my($counter)=0;
  for(my($row)=0; $row < $size; $row++ )
  {
    for(my($idx)=0; $idx <= $row; $idx++ )
    {
      print sprintf("%".($ml+1)."s",$$rarray[$counter]);
      $counter++;
    }
    print "\n";
  }
  
}
