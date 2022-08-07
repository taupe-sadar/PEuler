use strict;
use warnings;
use Data::Dumper;
use Gcd;

my($s)=290797;
my($num_segments)=5000;
my($size)=500;
my($true_intersects)=0;

my(@segments)=();
for(my($seg)=0;$seg<$num_segments;$seg++)
{
  my($rsegment)=new_segment();
  print "segment : $seg\n";

  my(%inter_points)=();
  for(my($j)=0;$j<=$#segments;$j++)
  {
    my($inter)=intersect($rsegment,$segments[$j]);
    if($inter ne 0)
    {
      if(!exists($inter_points{$inter}))
      {
        $inter_points{$inter}=1;
        $true_intersects++;
        
      }
      else
      {
        print "found confluence ! \n";
      }
    }
    
  }
  push(@segments,$rsegment);
}

print $true_intersects;

sub new_segment
{
  my(@points)=();
  for(my($i)=0;$i<4;$i++)
  {
    $s = ($s*$s)%50515093;
    push(@points,$s%$size);
  }
  return \@points;
}

sub intersect
{
  my($s1,$s2)=@_;
  
  return 0 if( $$s1[0] < $$s2[0] && $$s1[0] < $$s2[2] && $$s1[2] < $$s2[0] && $$s1[2] < $$s2[2] );
  return 0 if( $$s1[0] > $$s2[0] && $$s1[0] > $$s2[2] && $$s1[2] > $$s2[0] && $$s1[2] > $$s2[2] );
  return 0 if( $$s1[1] < $$s2[1] && $$s1[1] < $$s2[3] && $$s1[3] < $$s2[1] && $$s1[3] < $$s2[3] );
  return 0 if( $$s1[1] > $$s2[1] && $$s1[1] > $$s2[3] && $$s1[3] > $$s2[1] && $$s1[3] > $$s2[3] );
  
  my($a,$b)=($$s1[2] - $$s1[0], $$s1[3] - $$s1[1]);
  my($c,$d)=($$s2[2] - $$s2[0], $$s2[3] - $$s2[1]);
  my($det)=$a*$d - $b*$c;
  
  return 0 if($det==0);
  
  my($t1)=$d * ($$s2[0]-$$s1[0]) - $c * ($$s2[1]-$$s1[1]);
  my($t2)=$b * ($$s2[0]-$$s1[0]) - $a * ($$s2[1]-$$s1[1]);
  if( $det < 0 )
  {
    $t1 = -$t1;
    $t2 = -$t2;
    $det = -$det;
  }
  return 0 if( $t1 <= 0 || $t2 <= 0 || $t1 >= $det || $t2 >= $det);
  
  # my($x)=$$s1[0] + $a/$det*($d * ($$s2[0]-$$s1[0]) - $c * ($$s2[1]-$$s1[1]));
  # my($y)=$$s1[1] + $b/$det*($d * ($$s2[0]-$$s1[0]) - $c * ($$s2[1]-$$s1[1]));
  
  # my($t1)=($x - $$s1[0])/$a;
  # my($t2)=($x - $$s2[0])/$c;
  # print "-----------------------\n";
  # print "det : $det\n";
  # print "$x $y\n";
  # print "$t1 $t2\n";
  
  my($pgcd) = Gcd::pgcd($t1,$det);
  
  return ($t1/$pgcd).'/'.($det/$pgcd);
}