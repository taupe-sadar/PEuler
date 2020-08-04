use strict;
use warnings;
use Data::Dumper;
use Permutations;

my($i);
my($final_sum)=0;
my(@FACTS)=();
for($i=0;$i<=9;$i++)
{
  push(@FACTS,Permutations::factorielle($i));
}

my(@dec10k)=();
for($i=0;$i<=7;$i++)
{
  my(@dec)=Permutations::dec_base_fact(10**$i);
  push(@dec10k,\@dec);
}

for($i=2;$i<=7;$i++)
{
   my(@first)=trunk_up($i,$dec10k[$i-1]);
   my(@last)=trunk_down($i,$dec10k[$i]);
   #1 - first -> $high*1 
   my($high)=$#last;
   my($nhigh)=$last[$#last];
   my($count)=$i;
   my($lastnonzero)=$#first;
   my($j);
   for($j=$#first;$j>=0;$j--)
   {
     $count-=$first[$j];
     if($first[$j])
     {
       $lastnonzero=$j;
    }
  }
  for($j=$lastnonzero;$j<$high;$j++)
  {
    iterate_test(\@first,$j,$count);
    
    $count+=$first[$j]-1;
    $first[$j]=0;
    if(!defined($first[$j+1]))
    {
      $first[$j+1]=0;
    }
    $first[$j+1]++;
  }
  #2 - $high*1 -> $high*$nhigh
  for($j=$first[$high];$j<$nhigh;$j++)
  {
    iterate_test(\@first,$high-1,$count);
    $first[$high]++;
    $count--;
  }
  #3 - $high*$nhigh -> $last
  $lastnonzero = $high;
  for($j=$high;$j>=0;$j--)
  {
    if($last[$j]!=0)
    {
      $lastnonzero=$j;
    }
  }
  for($j=$first[$high]-1;$j>=$lastnonzero;$j--)
  {
    my($k);
    for($k=0;$k<=$last[$j];$k++)
    {
      $first[$j]++;
      $count++;
      iterate_test(\@first,$j-1,$count);
    }
  }
}

print $final_sum;

sub iterate_test
{
  my($reffact,$max_idx,$nfree)=@_;
  my($string)="";
  my($j);
  for($j=$#{$reffact};$j>=0;$j--)
  {
    my($k);
    for($k=0;$k<$$reffact[$j];$k++)
    {
      $string.=$j;
    }
  }
  iteration($string,1,$max_idx,$nfree);
}

sub iteration
{
  my($s,$min_idx,$max_idx,$nfree)=@_;
  my($j);
  if($nfree<=0)
  {
    test($s);
  }
  elsif($nfree==1)
  {
    for($j=$min_idx;$j<=$max_idx;$j++)
    {
      test("$s$j");
    }
  }
  else
  {
    for($j=$min_idx;$j<$max_idx;$j++)
    {
      iteration("$s$j",$j,$max_idx,$nfree-1);
    }
  }
}

sub test
{
  my($totest)=@_;
  my(@chiffres)=split(//,$totest);
  my($fact)=0;
  my($j);
  for($j=0;$j<=$#chiffres;$j++)
  {
    $fact+=$FACTS[$chiffres[$j]];
  }
  my(@chiffresfact)=split(//,$fact);
  @chiffres = reverse sort(@chiffres);
  my($chif)=join("",@chiffres);
  @chiffresfact = reverse sort(@chiffresfact);
  my($chifact)=join("",@chiffresfact);
  $chifact=~s/0/1/;
  $chifact=~s/11/2/;
  $chifact=~s/222/3/;
  $chifact=~s/3333/4/;
  $chifact=~s/44444/5/;
  $chifact=~s/555555/6/;
  $chifact=~s/6666666/7/;
      
  if($chifact eq $chif)
  {
    $final_sum+=$fact;
  }
}

sub trunk_down
{
  my($max,$rfact)=@_;
  my(@one)=(0,1);
  my(@limit)=Permutations::comb_facts($rfact,\@one,1,-1);
  my($count)=$max;
  my($a);
  my($full)=0;
  my(@fact);
  for($a=$#{$rfact};$a>=0;$a--)
  {
    if($full)
    {
      $fact[$a]=0;
    }
    else
    {
      $count-=$$rfact[$a];
      if($count<=0)
      {
        $fact[$a]=$$rfact[$a]+$count;
        $full=1;
      }
      else
      {
        $fact[$a]=$$rfact[$a];
      }
    }
  }
  return @fact;
}

sub trunk_up
{
  my($max,$rfact)=@_;
  
  my(@fact);
  my($count)=$max;
  my($a);
  my($afull)=0;
  my($full)=0;
  my($round)=0;
  for($a=$#{$rfact};$a>=0;$a--)
  {
    if(!$full)
    {
      $count-=$$rfact[$a];
      if($count<=0)
      {
        $fact[$a]=$$rfact[$a]+$count;
        if($count!=0)
        {
          $round=1;
        }
        $afull=$a;
        $full=1;
      }
      else
      {
        $fact[$a]=$$rfact[$a];
      }
    }
    else
    {
      if($$rfact[$a]!=0)
      {
        $round=1;
      }
      $fact[$a]=0;
    }
  }
  if($round)
  {
    my(@plus)=();
    for($a=0;$a<=$afull;$a++)
    {
      $plus[$a]=0;
    }
    $plus[$afull+1]=1;
    $fact[$afull]=0;
    return Permutations::comb_facts(\@fact,\@plus);
  }
  else
  {
    return @fact;
  }
}
