package Set;
use strict;

sub cartesian_product
{
  my($rsets)=@_;
  my(@idxs)=(0)x($#$rsets+1);
  
  my(@nuplets)=();
  my($stop)=0;
  while(!$stop)
  {
    my(@nuplet)=(0)x($#$rsets+1);
    for(my($i)=0;$i<=$#$rsets;$i++)
    {
      $nuplet[$i]=$$rsets[$i][$idxs[$i]];
    }
    
    for(my($idx)=$#idxs;$idx>=0;$idx--)
    {
      if($idxs[$idx]>=$#{$$rsets[$idx]})
      {
        $idxs[$idx] = 0;
      }
      else
      {
        $idxs[$idx]++;
        last;
      }
      $stop = 1 if($idx == 0);
    }
    push(@nuplets,\@nuplet);
  }
  return \@nuplets;
}

1;

