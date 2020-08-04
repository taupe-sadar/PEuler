use strict;
use warnings;
use Data::Dumper;

open(FILE,"54_poker.txt");
my($p1wins)=0;
my($line)="";
my(%values)=(
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'J' => 11,
    'T' => 10,
    'S' => 1000,
    'H' => 100,
    'D' => 10,
    'C' => 1
    );
while(defined($line=<FILE>))
{
  chomp($line);
  my(@cards)=split(/ /,$line);
  my(@strength_player1)=force(@cards[0..4]);
  my(@strength_player2)=force(@cards[5..9]);
  if( ($strength_player1[0] > $strength_player2[0])||(($strength_player1[0] == $strength_player2[0])&&($strength_player1[1] > $strength_player2[1])))
  {
    $p1wins++;
  }
}
close(FILE);

print $p1wins;

sub force
{
  my(@cards)=@_;
  my(@final_power)=(0,0);
  my(@vals)=();
  my($power_color)=0;
  my($color,$straight,$pair,$three,$square)=(0,0,0,0,0);
  for(my($i)=0;$i<=$#cards;$i++)
  {
    if($cards[$i]=~m/^(\D)(.)/)
    {
      push(@vals,$values{$1});
      $power_color+=$values{$2};
    }
    elsif($cards[$i]=~m/^(\d)(.)/)
    {
      push(@vals,$1);
      $power_color+=$values{$2};
    }
  }
  @vals = sort({$a<=>$b} @vals);
  if($power_color=~m/^5/)
  {
    $color=1;
  }
  if(!$color)
  {
    my(@diff);
    for(my($d)=0;$d<$#vals;$d++)
    {
      $diff[$d]=$vals[$d]-$vals[$d+1];
      if($diff[$d]!=0)
      {
        $diff[$d]=1;
      }
    }
    my($dd)=join("",@diff);
    my($ddcopy)=$dd;
    $square=($ddcopy=~s/000//g);
    $three=($ddcopy=~s/00//g);
    $pair=($ddcopy=~s/0//g);
    if($square)#carre
    {
      if($dd=~m/^0/)
      {
        @final_power=(7,$vals[0]*15+$vals[4]);
      }
      else
      {
        @final_power=(7,$vals[1]*15+$vals[0]);
      }
    }
    elsif($three&&$pair) #full
    {
      if($dd=~m/^001/)
      {
        @final_power=(6,$vals[0]*15+$vals[3]);
      }
      else
      {
        @final_power=(6,$vals[2]*15+$vals[0]);
      }
    }
    elsif($pair==2) #two pairs
    {
      if($dd=~m/^1/)
      {
        @final_power=(2,$vals[3]*225+$vals[1]*15+$vals[0]);
      }
      elsif($dd=~m/^011/)
      {
        @final_power=(2,$vals[3]*225+$vals[0]*15+$vals[2]);
      }
      else
      {
        @final_power=(2,$vals[2]*225+$vals[0]*15+$vals[4]);
      }
    }
    elsif($pair==1) #one pair
    {
      if($dd=~m/^0/)
      {
        @final_power=(1,$vals[0]*3375+$vals[4]*225+$vals[3]*15+$vals[2]);
      }
      elsif($dd=~m/^10/)
      {
        @final_power=(1,$vals[1]*3375+$vals[4]*225+$vals[3]*15+$vals[0]);
      }
      elsif($dd=~m/^110/)
      {
        @final_power=(1,$vals[2]*3375+$vals[4]*225+$vals[1]*15+$vals[0]);
      }
      else
      {
        @final_power=(1,$vals[3]*3375+$vals[2]*225+$vals[1]*15+$vals[0]);
      }
    }
    elsif($three) #brelan
    {
      if($dd=~m/^0/)
      {
        @final_power=(3,$vals[0]*225+$vals[4]*15+$vals[3]);
      }
      elsif($dd=~m/^10/)
      {
        @final_power=(3,$vals[1]*225+$vals[4]*15+$vals[0]);
      }
      else
      {
        @final_power=(3,$vals[2]*225+$vals[1]*15+$vals[0]);
      }
    }
  }
  if(!$pair&&!$three&&!$square)
  {
    if(($vals[4]-$vals[0])==4)
    {
      $straight=1;
      @final_power=($color?8:4,$vals[4]);
    }
    elsif(($vals[4]==14)&&($vals[3]==5))
    {
      $straight=1;
      @final_power=($color?8:4,$vals[3]);
    }
  }
  if($color&&!$straight)
  {
    @final_power=(5,$vals[3]);
  }
  if(!$pair&&!$three&&!$square&&!$color&&!$straight)
  {
    my($v)=0;
    for(my($a)=0;$a<=$#vals;$a++)
    {
      $v+=$vals[$a]*(15**$a);
    }
    @final_power=(0,$v);
  }
  return @final_power;
}
