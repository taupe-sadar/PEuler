use strict;
use warnings;
use Data::Dumper;
use GD;


my(@gdDim)=(500,800,250,400,30);

my($im) = new GD::Image(@gdDim[0,1]);

my($white) = $im->colorAllocate(255,255,255);
my($black) = $im->colorAllocate(0,0,0);       
my($red)= $im->colorAllocate(255,0,0);

# make the background transparent and interlaced
$im->transparent($white);
$im->interlaced('true');

my($a,$b)= (5,10);

my($precision) = 100;
my(@p0) = ( 0, $b );
for( my($k) = 1 ; $k <= $precision; $k++ )
{
  my($p)= $k/$precision*$a;
  my(@p1) = ( $p, $b*sqrt(1-$p*$p/($a*$a)) );
  
  # print "(".join(",",@p1).")\n";
  
  $im->line(GDPoint(@p0),GDPoint(@p1),$black);
  $im->line(GDPoint(-$p0[0],$p0[1]),GDPoint(-$p1[0],$p1[1]),$black);
  $im->line(GDPoint(-$p0[0],-$p0[1]),GDPoint(-$p1[0],-$p1[1]),$black);
  $im->line(GDPoint($p0[0],-$p0[1]),GDPoint($p1[0],-$p1[1]),$black);
  
  @p0 = @p1;
}
# printPNG();
$im->line(GDPoint(0,10.1),GDPoint(1.4,-9.6),$red);
printPNG(); 


my( $x, $y, $u, $v ) = ( 1.4, -9.6, 1.4, -19.7 );

my($count)= 0;
while($count < 100)
{
  print "$x, $y\n";
  my( @tang ) = (-$a/$b*$y, $b/$a*$x);
  my( $norm2_tang) = $tang[0]*$tang[0] + $tang[1]*$tang[1];
  my($scal) = $tang[0]*$u + $tang[1]*$v;
  
  my( $u2, $v2 ) = ( -$u + (2* $tang[0] * $scal)/$norm2_tang, -$v + (2* $tang[1] * $scal)/$norm2_tang );
  
  my( $t ) = -2*($x*$u2/($a*$a) + $y*$v2/($b*$b))/(($u2*$u2)/($a*$a) + ($v2*$v2)/($b*$b));
  
  my($x2,$y2) = ($x + $t*$u2, $y + $t*$v2);

  $im->line(GDPoint($x,$y),GDPoint($x2,$y2),$red);
  printPNG(); <STDIN>;
  
  ( $x, $y, $u, $v ) = ( $x2, $y2, $u2, $v2 );
  $count++;
}

sub printPNG
{
  open FILE, "> autre.png";
  binmode FILE;
  # Convert the image to PNG and print it on standard output
  print FILE $im->png;
  close FILE;

}


sub GDPoint
{
  my($x,$y)=@_;
  return ($x*$gdDim[4] + $gdDim[2] , $gdDim[1] - ($y*$gdDim[4] + $gdDim[3]));
}