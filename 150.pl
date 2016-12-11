use strict;
use warnings;
use Data::Dumper;


my($modulo)=2**20;
my($modulo_div2)=$modulo/2;

my($size)=1000;
my($triangle_size)=$size*($size+1)/2;

my(@array)=(0)x $triangle_size;
my(@cumul_down)=(0)x $triangle_size;
my(@cumul_diag_left)=(0)x $triangle_size;
my(@cumul_diag_right)=(0)x $triangle_size;

my(@sum_current)=(0)x $triangle_size;

my($min)=$modulo;
my($reached)=$modulo;

my($t_current)=0;


my($cumul)=0;
my($idx)=0;
for(my($row)=0;$row<$size;$row++)
{
  for(my($i)=0;$i<=$row;$i++)
  {
    $t_current = next_val( $t_current );
    my($current)=$t_current-$modulo_div2;
    $array[$idx]=$current;
    $sum_current[$idx]=$current;
    
    $cumul+= $current;
    $cumul_down[$idx]=$cumul;
    
    $min = $current if( $current < $min );
    
    if( $i < $row )
    {
      $cumul_diag_left[$idx] += $cumul_diag_left[$idx - $row];
    }
    $cumul_diag_left[$idx] += $array[$idx];

    if( $i > 0 )
    {
      $cumul_diag_right[$idx] += $cumul_diag_right[$idx - $row - 1];
    }
    $cumul_diag_right[$idx] += $array[$idx];
    
    $idx++;
  }
  $cumul = 0;
}

# print_triangle(\@array);
# print_triangle(\@cumul_diag_right);
# print_triangle(\@cumul_diag_left);
# print_triangle(\@cumul_down);

my($whole_sum)=0;
my($last_line_idx) = mapping($size-1,0);
for(my($i)=0;$i<$size;$i++)
{
  $whole_sum += $cumul_diag_left[$last_line_idx++];
}
$min = $whole_sum if( $whole_sum < $min );
$sum_current[0] = $whole_sum;

for(my($trisize)=$size-1;$trisize>=1;$trisize--)
{
  last if( -$min*2 > $trisize*($trisize+1)*$modulo_div2 );
  
  my($last_row)=$size-$trisize;
  my($counter_0)= mapping($last_row,0);
  my($map_idx1)=mapping($size-1,0);
  my($map_idx2)=mapping($size-1-($trisize+1),0);
  
  for(my($idx)=0;$idx<=$last_row;$idx++)
  {
    my($bigsum) =  ($idx == 0)? $sum_current[$counter_0 - $last_row] : $sum_current[$counter_0 - $last_row -1];
    if( $idx == 0 )
    {
      $bigsum -= $cumul_diag_right[$map_idx1 + $trisize];
    }
    else
    {
      $bigsum -= $cumul_diag_left[$map_idx1];
      $bigsum += $cumul_diag_left[$map_idx2] if($idx < $last_row);
      $map_idx1++;
      $map_idx2++;
    }
    $min = $bigsum if( $bigsum < $min );
    $sum_current[$counter_0] = $bigsum;
    $counter_0++;
  }
  
  my($counter)=0;
  for(my($row)=0;$row<($size-$trisize);$row++)
  {
    my($row_base)=mapping($row+$trisize,0);
    my($idx1,$idx2)=($row_base-1,$row_base+$trisize);
    for(my($idx)=0;$idx<=$row;$idx++)
    {
      my($bigsum)=$sum_current[$counter];
      
      $bigsum-= $cumul_down[$idx2];
      $bigsum+= $cumul_down[$idx1] if($idx>0);
      
      $sum_current[$counter] = $bigsum;
      $min = $bigsum if( $bigsum < $min );
      
      $idx1++;
      $idx2++;
      $counter++;
    }
  }
}

print $min;

sub next_val
{
  my($x)=@_;
  return (615949*$x+797807)%$modulo;
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
