use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Prime;

my($i);
my(@t);
for($i=0;$i<10;$i++)
{
    push(@t,Prime::next_prime());
}
print Dumper \@t;

# print Dumper \@tab;
sub insert_sorted_set
{
	my($reftab,$num)=@_;
	my($idx)=0;
	for($idx=0;$idx<=$#{$reftab};$idx++)
	{
		if($$reftab[$idx]==$num)
		{
			return;
		}
		elsif($$reftab[$idx]>$num)
		{
			last;
		}
	}
	splice(@{$reftab},$idx,0,$num);
	
}
# ---
