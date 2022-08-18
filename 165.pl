use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor/;

use integer;

my($s)=290797;
my($num_segments)=5000;
my($size)=500;
my($size2)=$size**2;
my($true_intersects)=0;

my($div)=1;
my(@zones)=init_zones();
my(@borders)=init_borders();

my(@segments)=();
for(my($seg)=0;$seg<$num_segments;$seg++)
{
  my($rsegment)=new_segment();
  $$rsegment[4]=$seg;
  print "segment : $seg\n";
  my($rseg_zones)=calc_seg_zones($rsegment);

  for(my($z)=0;$z<=$#$rseg_zones;$z++)
  {
    my($zone_segments)=$zones[$$rseg_zones[$z]];
    my(%inter_points)=();
    for(my($j)=0;$j<=$#$zone_segments;$j++)
    {
      next if( $$rsegment[4]==$$zone_segments[$j][4]);
      $$zone_segments[$j][4] = $$rsegment[4];
      
      my($inter)=intersect($rsegment,$$zone_segments[$j]);
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
    push(@$zone_segments,$rsegment);
  }
  # <STDIN>;
}

my($total_size)=0;
for(my($i)=0;$i<=$#zones;$i++)
{
  $total_size += $#{$zones[$i]} + 1;
}
print "$total_size\n";
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

sub init_zones
{
  my(@zones)=();
  for(my($i)=0;$i<$div*$div;$i++)
  {
    push(@zones,[]);
  }
  return @zones;
}

sub init_borders
{
  my(@b)=();
  for(my($i)=0;$i<=$div;$i++)
  {
    push(@b,floor(($i*$size)/$div));
  }
  return @b;
}

sub calc_seg_zones
{
  my($segment)=@_;
  my($x1,$y1,$x2,$y2);
  if( $$segment[0] <= $$segment[2] )
  {
    ($x1,$y1,$x2,$y2) = @$segment;
  }
  else
  {
    ($x1,$y1,$x2,$y2) = (@$segment[2..3],@$segment[0..1]);
  }
  my($rx1,$ry1,$rx2,$ry2)=map({zone_location($_)} ($x1,$y1,$x2,$y2));
  my($dx,$dy)=($rx2-$rx1,$ry2-$ry1);
  
  
  my(@locations)=($rx1 + $ry1 * $div);
  
  my($rx,$ry)=($rx1,$ry1);
  my($sy)=($dy >=0)? 1: 0;
  my($ssy)=($dy >=0)? 1: -1;
  while( $rx != $rx2 || $ry != $ry2 )
  {
    if( $rx == $rx2 )
    {
      $ry += $ssy ;
    }
    elsif( $ry == $ry2 )
    {
      $rx++;
    }
    else
    {
      my($val) = $dy * ($borders[$rx+1] - $x1) - $dx * ($borders[$ry + $sy] - $y1);
      if( $val >= 0 )
      {
        $ry += $ssy ;
      }
      elsif( $val < 0 )
      {
        $rx++;
      }
    }
    push(@locations,$rx + $ry * $div);
  }
  return \@locations;
}

sub zone_location
{
  my($x)=@_;
  my($zone)=0;
  for( my( $b ) = 1; $b < $#borders; $b++)
  {
    last if($x < $borders[$b]);
    $zone++;
  }
  return $zone;
}

sub intersect
{
  my($s1,$s2)=@_;
  
  # return 0 if( $$s1[0] < $$s2[0] && $$s1[0] < $$s2[2] && $$s1[2] < $$s2[0] && $$s1[2] < $$s2[2] );
  # return 0 if( $$s1[0] > $$s2[0] && $$s1[0] > $$s2[2] && $$s1[2] > $$s2[0] && $$s1[2] > $$s2[2] );
  # return 0 if( $$s1[1] < $$s2[1] && $$s1[1] < $$s2[3] && $$s1[3] < $$s2[1] && $$s1[3] < $$s2[3] );
  # return 0 if( $$s1[1] > $$s2[1] && $$s1[1] > $$s2[3] && $$s1[3] > $$s2[1] && $$s1[3] > $$s2[3] );
  
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
  
  # return ($t1 *$size2) /$det;
  
}