use POSIX qw/floor ceil/;


my($n)= log(243  )/log(3);
my($nf)= floor("$n");

print "$n $nf\n";
