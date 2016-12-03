use strict;
use warnings;
use Data::Dumper;

open( FILE, "102_triangles.txt" );
my($line)="";
my($trinagle_count)=0;
while(defined($line=<FILE>))
{
    chomp($line);
    my(@triangle) = split(/,/,$line);
    if( contain_origin(@triangle))
    {
	$trinagle_count++;
    }
}
close( FILE );

print $trinagle_count;

sub contain_origin
{
    my($xa,$ya,$xb,$yb,$xc,$yc)=@_;
    my($angle_ab)=mixte_prod($xa,$ya,$xb,$yb);
    my($angle_bc)=mixte_prod($xb,$yb,$xc,$yc);
    my($angle_ca)=mixte_prod($xc,$yc,$xa,$ya);
    if( ($angle_ab > 0 && $angle_bc > 0 && $angle_ca > 0 ) ||
        ($angle_ab < 0 && $angle_bc < 0 && $angle_ca < 0 ) )
    {
	return 1;
    }
    else
    {
	return 0;
    }
}

sub mixte_prod
{
    my($x1,$y1,$x2,$y2)=@_;
    return ($x1*$y2 - $x2*$y1); 
}
