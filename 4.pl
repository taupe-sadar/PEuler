use strict;
use warnings;
use Data::Dumper;
use Prime;
use Hashtools;

Prime::init_crible(8000);
my($a,$b,$c);
my($go_on)=1;

for($a=9;($a>=1)&&$go_on;$a--){for($b=9;($b>=0)&&$go_on;$b--){for($c=9;($c>=0)&&$go_on;$c--){
		
	# palindrome always divisible by 11
	# my($palindrome)=($c*1100+$b*10010+$a*100001) /11;
	
	my($palindrome)=$c*100+$b*910+$a*9091;
	my(%hash)=Prime::decompose($palindrome);
	Hashtools::increment(\%hash,11);
	my(@divisors)=Prime::all_divisors_no_larger(\%hash,1000);
	my($i)=0;
	for($i=0;$i<=$#divisors;$i++)
	{
		if($palindrome*11/$divisors[$i] < 1000)
		{
			$go_on=0;
			print ($c*1100+$b*10010+$a*100001);
			exit();
		}
	}
}}}
