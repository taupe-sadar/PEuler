use strict;
use warnings;
use Data::Dumper;
use GD;

my($write_png)=1;
my(@gdDim)=(1500,2400,750,1200,90);

my($a,$b)= (5,10);

my($im);
my($white); 
my($black); 
my($red);   
if( $write_png )
{
  $im = new GD::Image(@gdDim[0,1]);
  $white = $im->colorAllocate(255,255,255);
  $black = $im->colorAllocate(0,0,0);       
  $red = $im->colorAllocate(255,0,0);
  # make the background transparent and interlaced
  $im->transparent($white); 
  $im->interlaced('true');

  my($precision) = 100;
  my(@p0) = ( 0, $b );
  for( my($k) = 1 ; $k <= $precision; $k++ )
  {
    my($p)= $k/$precision*$a;
    my(@p1) = ( $p, $b*sqrt(1-$p*$p/($a*$a)) );
    
    
    $im->line(GDPoint(@p0),GDPoint(@p1),$black);
    $im->line(GDPoint(-$p0[0],$p0[1]),GDPoint(-$p1[0],$p1[1]),$black);
    $im->line(GDPoint(-$p0[0],-$p0[1]),GDPoint(-$p1[0],-$p1[1]),$black);
    $im->line(GDPoint($p0[0],-$p0[1]),GDPoint($p1[0],-$p1[1]),$black);
    
    @p0 = @p1;
  }
  $im->line(GDPoint(0,10.1),GDPoint(1.4,-9.6),$red);
}

my( $x, $y, $u, $v ) = ( 1.4, -9.6, 1.4, -19.7 );

my($count)= 0;
while(1)
{
  $count++;
  my( @tang ) = (-$a/$b*$y, $b/$a*$x);
  my( $norm2_tang) = $tang[0]*$tang[0] + $tang[1]*$tang[1];
  my($scal) = $tang[0]*$u + $tang[1]*$v;
  
  my( $u2, $v2 ) = ( -$u + (2* $tang[0] * $scal)/$norm2_tang, -$v + (2* $tang[1] * $scal)/$norm2_tang );
  
  my( $t ) = -2*($x*$u2/($a*$a) + $y*$v2/($b*$b))/(($u2*$u2)/($a*$a) + ($v2*$v2)/($b*$b));
  
  my($x2,$y2) = ($x + $t*$u2, $y + $t*$v2);

  $im->line(GDPoint($x,$y),GDPoint($x2,$y2),$red) if( $write_png );
  
  ( $x, $y, $u, $v ) = ( $x2, $y2, $u2, $v2 );
  if( $x < 0.01 && $x > -0.01 && $y > 0)
  {
    last;
  }
}
if( $write_png )
{
  printPNG(); 
}
print $count;

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