use strict;
use warnings;
use Data::Dumper;

my($modulo)=2**20;
my($modulo_div2)=$modulo/2;

my($size)=1000;
my($triangle_size)=$size*($size+1)/2;

my(@array)=(0)x $triangle_size;

my($current)=0;
for(my($i)=0;$i<$triangle_size;$i++)
{
  $current = next_val( $current );
  $array[$i]=$current;
}

my(@sums)=();
my($max)=-$modulo;
my($first_idx)=mapping($size-1,0);
for(my($i)=0;$i<$size;$i++)
{
  my($val)=$array[$first_idx+$i];
  $sums[$i] = [[$val,0]];
  $max = $val if( $val > $max);
}

for(my($row)=$size-2;$row>=0;$row--)
{
  print "$row\n";
  my($idx_first)=mapping($row,0);
  for(my($idx)=0;$idx<=$row;$idx++)
  {
    # print Dumper \@sums;
    
    my($array_idx)= $idx_first + $idx;
    my($val)=$array[$array_idx];
    my($rsums)=$sums[$idx];
    my($rsums_1)=$sums[$idx+1];
    my(@newtab)=([$val,0]);
    $max = $val if( $val > $max);
    for(my($larger)=0;$larger<=$#$rsums;$larger++)
    {
      my($newval)= $val + $$rsums[$larger][0] + $$rsums_1[$larger][0] - $$rsums_1[$larger][1];
      # print "($row,$idx) : $newval\n";
      # if( $idx ==0 && $row == 0)
      # {
        # print "$val $$rsums[$larger][0] $$rsums_1[$larger][0] $$rsums_1[$larger][1]\n";<STDIN>;
      # }
      
      
      push(@newtab,[$newval,$$rsums[$larger][0]]);
      $max = $newval if( $newval > $max);
    }
    
    $sums[$idx]=\@newtab;
  }
  pop(@sums);
}

print Dumper \@array;
print $max;


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