use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum max min );
use POSIX qw/floor/;

my($main_radius)=50;

my(@radius)=(30..50);
my($best)=10**12;
my($best_idx)=-1;
my($best_list)=[];
my($arrs)=minimal_arrangements($#radius+1);

for(my($i)=0;$i<=$#$arrs;$i++)
{
  my(@arranged_radius)=();
  for(my($j)=0;$j<=$#{$$arrs[$i]};$j++)
  {
    push(@arranged_radius,$radius[$$arrs[$i][$j]]);
  }
  my($length)=list_length(\@arranged_radius,$main_radius);
  if($length<$best)
  {
    $best = $length;
    $best_idx = $i;
    $best_list = \@arranged_radius;
  }
}
# print "Best : $best_idx ($best)\n";
# print "[".join(",",@$best_list)."]\n";
print floor($best*1000 + 0.5);


sub minimal_arrangements
{
  my($n)=@_;
  if( $n == 3 )
  {
    return [[0,1,2],[0,2,1],[1,0,2],[1,2,0],[2,0,1],[2,1,0]];
  }
  else
  {
    my($arrangements)=minimal_arrangements($n-1);
    my(@valids)=();
    for my $arr (@$arrangements)
    {
      my($lower_than)=$n-1;
      my($higher_than)=0;
      
      for(my($i)=0;$i<=$#$arr-2;$i++)
      {
        if($$arr[$i+1]>$$arr[-1])
        {
          $lower_than = min($lower_than,$$arr[$i]);
        }
        else
        {
          $higher_than = max($higher_than,$$arr[$i]+1);
        }
      }
      
      # print (join("",@$arr)." : $lower_than -> $higher_than\n");<STDIN>;
      
      for(my($v)=$higher_than;$v<=$lower_than;$v++)
      {
        my(@valid)=(@$arr,$v);
        for(my($j)=0;$j<$#valid;$j++)
        {
          $valid[$j]++ if($valid[$j]>=$v);
        }
        push(@valids,\@valid);
      }
    }
    return \@valids;
  }
}

sub list_length
{
  my($rlist,$r)=@_;
  my($s)=$$rlist[0];
  for(my($i)=0;$i<$#$rlist;$i++)
  {
    $s+=dist($$rlist[$i],$$rlist[$i+1],$r);
  }
  $s+=$$rlist[-1];
  return $s;
}


sub dist
{
  my($r1,$r2,$r)=@_;
  return 2*sqrt($r*($r1+$r2 - $r));
}

