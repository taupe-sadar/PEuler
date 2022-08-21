use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor/;

use GD;

my($scale)=5;
sub scale
{
  return (map( {$_*$scale;} @_));
}

use integer;

my($s)=290797;
my($num_segments)=3000;
my($size)=500;

my($div)=32;
my(@zones)=init_zones();
my(@borders)=init_borders();

#######################
my($im) = new GD::Image(scale(500,500));
my($white) = $im->colorAllocate(255,255,255);
my($black) = $im->colorAllocate(0,0,0);
my($blue) = $im->colorAllocate(0,0,255);       
my($red) = $im->colorAllocate(255,0,0);
my($green) = $im->colorAllocate(0,255,0);
# $im->line(scale(12,303,246,140),$blue);
# $im->line(scale(228,270,252,85),$red);

for my $b (@borders)
{
  $im->line(scale($b,0,$b,500),$black);
  $im->line(scale(0,$b,500,$b),$black);
}

open FILE, "> test.png";
binmode FILE;
print FILE $im->png;
close FILE;
#######################


my(%inter_points)=();
my($true_intersects)=0;
my(@segments)=();
for(my($seg)=0;$seg<$num_segments;$seg++)
{
  my($rsegment)=new_segment();
  $$rsegment[4]=$seg;
  #Debug purpose
  $$rsegment[5]=$seg;
  my($rseg_zones)=calc_seg_zones($rsegment);
  
  my($coord)=join(" ",@$rsegment[0..3]);
  my($str)=join(" ",@$rseg_zones);
  
  # print "segment : $seg \n" ;
  # print "segment : $seg [$coord] ($str)\n" ;
  
  if( $seg == 2888 )
  {
     print "2888 : [$coord]";
  }
  
  
  for(my($z)=0;$z<=$#$rseg_zones;$z++)
  {
    my($zone_segments)=$zones[$$rseg_zones[$z]];
    
    for(my($j)=0;$j<=$#$zone_segments;$j++)
    {
      next if( $$rsegment[4]==$$zone_segments[$j][4]);
      $$zone_segments[$j][4] = $$rsegment[4];
      
      my($inter)=intersect($rsegment,$$zone_segments[$j]);
      if($inter ne 0)
      {
        if(!exists($inter_points{$inter}))
        {
          $inter_points{$inter}=["$seg $$zone_segments[$j][5]"];
          # $inter_points{$inter}=1;
          $true_intersects++;
          if( $seg == 1263 )
          {
            $im->line(scale(@$rsegment[0..3]),$green);
          }
        
        
        }
        else
        {
          print "$seg - $$zone_segments[$j][5] --- $inter \n";
          push( @{$inter_points{$inter}},"$seg $$zone_segments[$j][5]"); 
          if( $seg == 2888 )
          {
            print Dumper $inter_points{$inter}; 
            $im->line(scale(@$rsegment[0..3]),$blue);
            $im->line(scale(@{$$zone_segments[$j]}[0..3]),$red);
            
            open FILE, "> test.png";
            binmode FILE;
            print FILE $im->png;
            close FILE;
            
            <STDIN>;
          }
          
          # $inter_points{$inter}++;
        }
        # elsif($inter_points{$inter} == 1)
        # {
          # $true_intersects--;
          # $inter_points{$inter}=0;
        # }
      }
      
    }
    
    
    push(@$zone_segments,$rsegment);
  }
  
  if( $seg == 2888 )
  {
    
  }
  
  # print "$seg : $true_intersects\n";
}

my($total_size)=0;
for(my($i)=0;$i<=$#zones;$i++)
{
  $total_size += $#{$zones[$i]} + 1;
}
print "Array size : $total_size\n";
print "Intersections : ".$true_intersects;

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
  
  # if($x1 == 228)
  # {
    # print "----- $rx1,$ry1,$rx2,$ry2\n";
    # print Dumper \@borders;
  # }
  
  my($dx,$dy)=($x2-$x1,$y2-$y1);
  
  
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
      my(@target_point)=($borders[$rx+1],$borders[$ry + $sy]);
      
      # if($x1 == 228)
      # {
        # print "Sol : ".((-3 * (247.24 - 228) - 1 * (139.13 - 270)))."\n";
        
        
        # print "target : ($target_point[0] $target_point[1])\n";
        # print "val : $val\n";
        # print "Full : ($dy * ($borders[$rx+1] - $x1) - $dx * ($borders[$ry + $sy] - $y1))\n";
      # }
      if( $val * $ssy >= 0 )
      {
        $ry += $ssy ;
      }
      else
      {
        $rx++;
      }
    }
    # if($x1 == 228)
    # {
      # print "-> loc  $rx , $ry \n";
    # }
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
  
  my($adet)=($det >= 0) ? $det : -$det;
  if( $det < 0 )
  {
    $t1 = -$t1;
    $t2 = -$t2;
  }
  return 0 if( $t1 <= 0 || $t2 <= 0 || $t1 >= $adet || $t2 >= $adet);
  
  # my($x)=$$s1[0] + $a*($d * ($$s2[0]-$$s1[0]) - $c * ($$s2[1]-$$s1[1]))/$det;
  # my($y)=$$s1[1] + $b*($d * ($$s2[0]-$$s1[0]) - $c * ($$s2[1]-$$s1[1]))/$det;
  
  
  # my($t1)=($x - $$s1[0])/$a;
  # my($t2)=($x - $$s2[0])/$c;
  # print "-----------------------\n";
  # print "det : $det\n";
  # print "$x $y\n";
  
  # my($pgcd) = Gcd::pgcd($t1,$det);
  
  # return ($t1/$pgcd).'/'.($det/$pgcd);
  
  
  my($xd)= $$s1[0]*$det + $a*($d * ($$s2[0]-$$s1[0]) - $c * ($$s2[1]-$$s1[1]));
  my($yd)= $$s1[1]*$det + $b*($d * ($$s2[0]-$$s1[0]) - $c * ($$s2[1]-$$s1[1]));
  my($pgcdx) = Gcd::pgcd($xd,$adet);
  my($pgcdy) = Gcd::pgcd($yd,$adet);
  my($pdetx)= $adet/$pgcdx;
  my($pdety)= $adet/$pgcdy;
  
  if( $det > 0 )
  {
    return ($xd/$pgcdx."/$pdetx ".$yd/$pgcdy."/$pdety");
  }
  else
  {
    return (-$xd/$pgcdx."/$pdetx ".-$yd/$pgcdy."/$pdety");
  }
  
}