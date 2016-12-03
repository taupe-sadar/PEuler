use strict;
use warnings;
use Data::Dumper;

open(FILE, "99_base_exp.txt" ) or die "Cannot open file";
my($line)="";
my($max_log)=(0);
my($argmax_line)="";
my($line_count)=1;
while(defined($line=<FILE>))
{
    chomp($line);
    my($base,$exp)=split(/,/,$line);
    my( $log_number)= $exp*log($base);
    if( $log_number > $max_log )
    {
	$max_log = $log_number;
	$argmax_line = $line_count;
    }
    $line_count++;
}
close(FILE);
print $argmax_line;


