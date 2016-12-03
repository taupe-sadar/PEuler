use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor ceil/;

my($consecutive)=4;
my($n_cons)=4;

my($crible_size)=10000;
my(@crible)=();
for(my($i)=0;$i<$crible_size;$i++){$crible[$i]=0;}
my($crible_start)=0; 
my($crible_end)=$crible_start+$crible_size-1;
my($last_prime)=0;
my($last_checked)=0;
my($consecutive_found)=0;
my($final)=0;

while(1) #Si si ca va le faire
{
    my($p)=Prime::next_prime();
    if($p>$crible_end)
    {
	check_crible($crible_end) or last;
	$last_prime=$p;
	reinit_crible();
	Prime::reset_prime_index();
	$p=Prime::next_prime(); 
    }
    
    del_in_crible($p);
    if($p>=$last_prime)
    {
	check_crible($p) or last;
    }
}

print $final;

sub reinit_crible
{
    $crible_start=1+$crible_end;
    $crible_end=$crible_start+$crible_size;
    for(my($i)=0;$i<$crible_size;$i++){$crible[$i]=0;}
    
}

sub del_in_crible
{
    my($prime)=@_;
    my($pkstart)=ceil($crible_start/$prime)*$prime-$crible_start;
    my($pkend)=ceil($crible_end/$prime)*$prime-$crible_start;
    for(my($pk)=$pkstart;$pk<=$pkend;$pk+=$prime)
    {
	$crible[$pk]++;
    }
    
}

sub check_crible
{
    my($num)=@_;
    for(my($i)=$last_checked+1;$i<=$num;$i++)
    {
	if($crible[$i-$crible_start]==$consecutive)
	{
	    $consecutive_found++;
	}
	else
	{
	    $consecutive_found=0;
	}
	if($consecutive_found==$n_cons)
	{
	    $final=$i-$n_cons+1;
	    return 0;
	}
    }
    $last_checked = $num;
    return 1;
}
