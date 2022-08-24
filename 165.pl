use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor/;
use Hashtools;
use integer;

# We calculate the index of an intersection of segment on the current segment.
# This index must be between 0 and 1, for being a true intersection point
#
# Warnings :
# - we use regions for 33% optimisation
# - Some points are found more than once ( example 3 segments than share the same point)
# - There is an evil corner case for confused/colinear segments. There is a special treat 
#   for this one. Thats why the code is that complicated 

my($s)=290797;
my($num_segments)=5000;
my($size)=500;

my($div)=32;
my(@zones)=init_zones();
my(@borders)=init_borders();

my(%confused_segments)=();
my($true_intersects)=0;
my(@segments)=();

for(my($seg)=0;$seg<$num_segments;$seg++)
{
  my($rsegment)=new_segment();
  $$rsegment[4]=$seg;
  $$rsegment[5]=$seg;
  my($rseg_zones)=calc_seg_zones($rsegment);
  
  my($coord)=join(" ",@$rsegment[0..3]);
  my($str)=join(" ",@$rseg_zones);
  
  my(%inter_points)=();
  my(@confused_bounds)=();
  my(%confused_hits)=();
  for(my($z)=0;$z<=$#$rseg_zones;$z++)
  {
    my($zone_segments)=$zones[$$rseg_zones[$z]];
    
    for(my($j)=0;$j<=$#$zone_segments;$j++)
    {
      next if( $$rsegment[4]==$$zone_segments[$j][4]);
      $$zone_segments[$j][4] = $$rsegment[4];
      
      my($inter,@bounds)=intersect($rsegment,$$zone_segments[$j]);
      if($inter eq 1)
      {
        my($other)=$$zone_segments[$j];
        
        $confused_segments{$$other[5]} = $$other[5] if(!exists($confused_segments{$$other[5]}));
        $confused_segments{$seg} = $confused_segments{$$other[5]};
        
        push(@confused_bounds,\@bounds);
      }
      elsif($inter ne 0)
      {
        my($skip)=0;
        my($other)=$$zone_segments[$j];
        if( exists($confused_segments{$$other[5]}) )
        {
          my($equivalent)=$confused_segments{$$other[5]};
          if(!exists($confused_hits{$equivalent}))
          {
            $confused_hits{$equivalent} = 1;
          }
          else
          {
            $skip = 1;
          }
        }
        Hashtools::increment(\%inter_points,$inter) if(!$skip);
      }
    }
    
    push(@$zone_segments,$rsegment);
  }
  
  foreach my $bound (@confused_bounds)
  {
    my($nmin,$dmin,$nmax,$dmax)=@$bound;
    foreach my $p (keys(%inter_points))
    {
      my($num,$denom) =split('/',$p);
      if( ($num * $dmin > $nmin * $denom) && ($num * $dmax < $nmax * $denom))
      {
        delete $inter_points{$p};
      }
    }
  }
  
  foreach my $p (keys(%inter_points))
  {
    $true_intersects ++ if($inter_points{$p}==1);
  }

  # print "$seg : $true_intersects\n";
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
      
      if( $val * $ssy >= 0 )
      {
        $ry += $ssy ;
      }
      else
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
  
  my($a,$b)=($$s1[2] - $$s1[0], $$s1[3] - $$s1[1]);
  my($c,$d)=($$s2[2] - $$s2[0], $$s2[3] - $$s2[1]);
  my($det)=$a*$d - $b*$c;
  
  if($det==0)
  {
    if( $a * ($$s2[1] - $$s1[1] ) == $b * ($$s2[0] - $$s1[0] ) )
    {
      my($ta)=($$s2[0] - $$s1[0]);
      my($tb)=($$s2[2] - $$s1[0]);
      
      my($aa)=($a >= 0) ? $a : -$a;
      if( $a < 0 )
      {
        $ta = -$ta;
        $tb = -$tb;
      }
      my($tmin,$tmax) = ($ta > $tb) ? ($tb,$ta) : ($ta,$tb);
      $tmin = 0 if $tmin < 0;
      $tmax = $aa if $tmax > $aa;
      
      my($pmin)=Gcd::pgcd($tmin,$aa);
      my($pmax)=Gcd::pgcd($tmax,$aa);
      
      return (1,$tmin/$pmin,$aa/$pmin,$tmax/$pmax,$aa/$pmax);
    }
    else
    {
      return 0 ;
    }
  }
  
  my($t1)=$d * ($$s2[0]-$$s1[0]) - $c * ($$s2[1]-$$s1[1]);
  my($t2)=$b * ($$s2[0]-$$s1[0]) - $a * ($$s2[1]-$$s1[1]);
  
  my($adet)=($det >= 0) ? $det : -$det;
  if( $det < 0 )
  {
    $t1 = -$t1;
    $t2 = -$t2;
  }
  return 0 if( $t1 <= 0 || $t2 <= 0 || $t1 >= $adet || $t2 >= $adet);
  
  my($pgcd) = Gcd::pgcd($t1,$adet);
  return ($t1/$pgcd).'/'.($adet/$pgcd);
}