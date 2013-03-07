use strict;
use warnings;
use Data::Dumper;

my($saved_chars)=0;

open( FILE, "89_roman.txt" );
my($line)="";
while( defined($line=<FILE>))
{
    chomp($line);
    $saved_chars+=calc_saved( $line );
}

close(FILE);

print $saved_chars;

sub calc_saved
{
    my($string)=@_;
    my($number)=0;
    my($s)=$string;
    while($s ne "")
    {
	my($token)="";
	if( $s =~ m/^(CD|CM|XL|XC|IV|IX)(.*)/)
	{
	    $token = $1;
	    $s = $2;
	}
	elsif( $s =~ m/^(I|V|X|L|C|D|M)(.*)/)
	{
	    $token = $1;
	    $s= $2;
	}
	else
	{
	    die "Unrecognizable string $string\n";
	}
	
        my(%hash)= ( 'CD' => 400, 'CM' => 900, 'XL' => 40, 'XC' => 90, 'IV' => 4, 'IX' => 9, 'I' => 1, 'V' => 5, 'X' => 10, 'L' => 50, 'C' => 100, 'D' => 500, 'M' => 1000 );
	
	$number+= $hash{$token};
    }
    my($best)= best_roman( $number );
    
    #print "$best $string\n";<STDIN>;
    
    return (length($string) - length($best));
}

sub best_roman
{
    my($n)=@_;
    my($units,$tens,$hundreds,@thousands) = reverse(split(//,$n));
    my($mils)=join("",reverse(@thousands));
    if( !defined($tens))
    {
	$tens = 0;
    }
    if( !defined($hundreds))
    {
	$hundreds = 0;
    }
    if( $mils eq "")
    {
	$mils = 0;
    }
    
    my(@tabunit)=( "", 'I', 'II', 'III', 'IV', 'V', 'VI' , 'VII', 'VIII', 'IX' );
    my(@tabtens)= ( "", 'X', 'XX', 'XXX', 'XL', 'L', 'LX' , 'LXX', 'LXXX', 'XC' );
    my(@tabhundreds)= ( "", 'C', 'CC', 'CCC', 'CD', 'D', 'DC' , 'DCC', 'DCCC', 'CM' );
    
    my($ret)="";
    
    for(my($a)=0;$a<$mils;$a++)
    {
	$ret .= 'M';
    }
    $ret.= "$tabhundreds[$hundreds]$tabtens[$tens]$tabunit[$units]";
}
