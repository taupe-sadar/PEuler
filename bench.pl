use strict;
use warnings;
use Time::HiRes qw(time);
use Data::Dumper;

my($time)=time();
print "--- START ---\n";
system("perl ".join(" ",@ARGV));
print "\n---  END  ---\n";
my($t2)=int((time()-$time)*1000000)/1000000;
print "Duration : $t2 s\n";
