use strict;
use warnings;
use Data::Dumper;

my(@skip_longs)=(44,60);
my(%skip_hash)=();

for(my($i)=0;$i<=$#skip_longs;$i++)
{
    $skip_hash{$skip_longs[$i]}=1;
}

opendir MYDIR, ".";
my(@contents) = readdir MYDIR;
closedir MYDIR;

my(@prev_results)=();
read_results(\@prev_results);


@contents = sort{ordre($a) <=> ordre($b)} @contents;

my($prefix)="";
if($ENV{"SHELL"} eq '/bin/bash')
{
    $prefix='/usr/bin/';
}

my($i)=0;
for($i=0;$i<=$#contents;$i++)
{
    chomp($contents[$i]);
    if($contents[$i]=~m/^(\d+)\.pl$/)
    {
	print "".sprintf('%3s',$1)." : ";
	
	if(!exists($skip_hash{$1}))
	{
	    my($value)=`${prefix}perl $contents[$i]`;
	    if(!defined($value))
	    {
		$value="";
	    }
	    chomp($value);
	    my($assert)=check_results($1,$value);
	    print "$value$assert\n";
	}
	else
	{
	    print "Skipping\n";
	}
    }
}

sub ordre
{
	my($order)=@_;
	if($order=~m/^(\d+)\.pl$/)
	{
		return $1;
	}
	
	return -1;
}

sub read_results
{
	my($refresults)=@_;
	my(@lines)=();
	if(open RESULT, "results.txt")
	{
		@lines = <RESULT>;
		close RESULT;
	}
	my($i);
	for($i=0;$i<=$#lines;$i++)
	{
		if($lines[$i]=~m/^\s*(\d*)\s*:\s*((-|)\d*(\.\d*|))\s*$/)
		{
			$$refresults[$1]=$2;
		}
	}
}

sub check_results
{
	my($no,$output)=@_;
	my($number);
	if($output eq "")
	{
		return "";
	}
	if($output=~m/^\s*((-|)\d*(\.\d*|))\s*$/)
	{
		$number=$1;
	}
	else
	{
		return ""; #mauvaise valeur de retour de n.pl
	}
	
	if(defined($prev_results[$no]))
	{
		if($prev_results[$no]==$number)
		{
			return "";#OK meme valeur qu'avant
		}
		else
		{
			return " => Error : old value = $prev_results[$no]";#OK meme valeur qu'avant
		}
	}
	else
	{
		open RESULT, ">> results.txt";
		print RESULT "".sprintf('%3s',$no)." : $number\n";
		return " => New value. Archiving ...";
	}
}
