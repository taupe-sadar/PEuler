use strict;
use warnings;
use Data::Dumper;

my($sizekey)=3;
open(FILE,"59_cipher1.txt");
my($line)=<FILE>;
close(FILE);
chomp($line);
my(@numbers)=split(/,/,$line);

my(@cles_possibles)=();

for(my($i)=0;$i<$sizekey;$i++)
{
    my(@char_possible)=();
    for(my($a)=97;$a<=122;$a++)
    {
	my($invalid)=0;
	for(my($ch)=$i;$ch<=$#numbers;$ch+=$sizekey)
	{
	    my($decoded)=$numbers[$ch]^$a;
	    if(!((($decoded>=65)&&($decoded<=90)) ||
	        (($decoded>=97)&&($decoded<=122))||
	        (($decoded>=32)&&($decoded<=34)) ||
	        (($decoded>=39)&&($decoded<=41)) ||
	        (($decoded>=44)&&($decoded<=46)) ||
		(($decoded>=48)&&($decoded<=57)) ||
	        (($decoded>=58)&&($decoded<=59)) ||
	        ($decoded==63)))
	    {
		$invalid=1;
		last;
	    }
	    
	}
	if(!$invalid)
	{
	    push(@char_possible,$a);
	}
	    
    }
    push(@cles_possibles,\@char_possible);
}

#Intervention humaine : verification qu' il n'y a q'une cle possible correcte

#print Dumper \@cles_possibles;

######

my($string)="";
my($sum)=0;
for(my($i)=0;$i<=$#numbers;$i++)
{
    my($dec)=$numbers[$i]^($cles_possibles[$i%3][0]);
    $string.=chr($dec);
    $sum+=$dec;
}
#This line prints the full text. Uncomment to read it !
#print "$string\n";
print $sum;

