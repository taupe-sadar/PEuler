use strict;
use warnings;
use Data::Dumper;

my($main_radius)=50;


my(@radius)=(30,35,40,45,50);
my($best)=10**12;
my($best_idx)=-1;
for(my($i)=0;$i<120;$i++)
{
  my(@shuff)=suffle_list($i,120,@radius);
  print "($i) - [ ".join(" , ",@shuff)." ]";
  my($length)=list_length(\@shuff,$main_radius);
  print " : $length\n";
  if($length<$best)
  {
    $best = $length;
    $best_idx = $i;
  }
}
print "Best : $best_idx ($best)\n";
print "".list_length([45 , 35 , 30 , 40 , 50],$main_radius)."\n";
print "".list_length([45 , 30 , 35 , 40 , 50],$main_radius)."\n";

sub minimal_arrangements
{
  my($n)=@_;
  if( $n == 3 )
  {
    return [[0,1,2],[0,2,1],[1,0,2],[1,2,0],[2,0,1],[2,1,0]];
  }
}



sub suffle_list
{
  my($idx,$fact,@list)=@_;
  my($n)=$#list+1;
  if( $n == 1 )
  {
    return @list;
  }
  else
  {
    my(@shuffled)=@list;
    
    my($swap_idx)=$idx%$n;
    # print "--- $idx $fact $n\n";
    if($swap_idx!=0)
    {
      my($tmp)=$shuffled[0];
      $shuffled[0]=$shuffled[$swap_idx];
      $shuffled[$swap_idx]=$tmp;
    }
    return ($shuffled[0],suffle_list(($idx-$swap_idx)/$n,$fact/$n,@shuffled[1..$#list]));
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

