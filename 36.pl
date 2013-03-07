use strict;
use warnings;
use Data::Dumper;
use Palindrome;

my($max_digits)=3;

my($i,$j);
my($sum)=0;
for($i=1;$i<10**$max_digits;$i+=2)
{
    my($a);
    my($l)=length($i);
    for($a=$l;$a<=$max_digits;$a++)
    {

	my($s)=sprintf('%0'.$a.'s',$i);
	my($palindrome_type1,$palindrome_type2)=($s,$s);
	my(@t)=split(//,$s);
	for($j=0;$j<$a;$j++)
	{
	    if($j!=0)
	    {
		$palindrome_type1=$t[$j].$palindrome_type1;
	    }
	    $palindrome_type2=$t[$j].$palindrome_type2;
	    
	}
	if(Palindrome::binary_palindromic($palindrome_type1))
	{
	    $sum+=$palindrome_type1;
	}
	if(Palindrome::binary_palindromic($palindrome_type2))
	{
	    $sum+=$palindrome_type2;
	    
	}
    }
    
}

print $sum;

