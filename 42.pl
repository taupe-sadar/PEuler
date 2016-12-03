use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );
use Words;

my($file)="42_words.txt";
my(@WORDS)=();
Words::get_words(\@WORDS,$file);

my($i);
my(@scores);
for($i=0;$i<=$#WORDS;$i++)
{
	push(@scores,Words::score($WORDS[$i]));
}
my($max_score)=max(@scores);
my(%hash_triangle);
my($triangle)=0;
my($n)=1;
while($triangle<$max_score)
{
    $triangle+=$n;
    $n++;
    $hash_triangle{$triangle}=1;
}
my($count)=0;
for($i=0;$i<=$#scores;$i++)
{
	if(exists($hash_triangle{$scores[$i]}))
	{
	    $count++;
	}
}
print $count;
