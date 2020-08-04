use strict;
use warnings;
use Data::Dumper;
use Words;

my($file)="22_names.txt";
my(@NAMES);
Words::get_words(\@NAMES,$file);
my($i);
@NAMES= sort(@NAMES);
my($final_score);
for($i=0;$i<=$#NAMES;$i++)
{
  $final_score+=Words::score($NAMES[$i])*($i+1);
}
print $final_score;




