use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor ceil/;


my($crible_size)=1000;
my($c_size)=int($crible_size/2);
my(@crible)=(0..int($c_size/2)-1); #crible des impairs jusqua crible_size 0=parcouru, autre = non-parcouru
my($crible_start)=0; #2*0+1 -> 1(impair)
my($crible_end)=$crible_start+$c_size-1;
my(%hash_primes_last_inc)=();
my(%hash_primes_last_idx)=();
my($last_primed)=0;
my($primed)=Prime::next_prime();
my($num_checked)=0;
while(1) #s'arretera, si si ...
{
    $primed=(Prime::next_prime()-1)/2;
    
    if($primed>$crible_end)
    {
	check_crible($crible_end) or last;
	$last_primed=$primed;
	reinit_crible();
	Prime::reset_prime_index();
	Prime::next_prime(); 
	$primed=(Prime::next_prime()-1)/2; #pour passer a 3 direct
    }
    
    del_in_crible($primed);
    if($primed>=$last_primed)
    {
	check_crible($primed) or last;
    }
    
}

sub del_in_crible
{
    my($p)=@_;
    
    my($idx);    
    my($start);
    if(exists($hash_primes_last_idx{$p}))
    {
	$start=$hash_primes_last_inc{$p}+1;
	$idx=$hash_primes_last_idx{$p}-$crible_start;
    }
    else
    {
       $start=1;
       $idx=$p-$crible_start;
       $crible[$idx]=0;
    }
    
    my($end)=floor(sqrt($crible_end-$p));
    for(my($i)=$start;$i<=$end;$i++)
    {
	$idx+=2*$i-1;
	$crible[$idx]=0;
    }
    $hash_primes_last_inc{$p}=$end;
    $hash_primes_last_idx{$p}=$idx+$crible_start;
}

sub check_crible
{
    my($stop)=@_;
    my($end)=$stop-$crible_start;
    my($num)=$num_checked+1-$crible_start;
    my($ok)=1;
    while($num<=$end)
    {
	if($crible[$num]!=0)
	{
	    $ok=0;
	    last;
	}
	$num++;
    }
    
    $num_checked=($ok?$end:$num) + $crible_start;
    return $ok;
}

sub reinit_crible
{
    $crible_start=1+$crible_end;
    $crible_end=$crible_start+int($crible_size/2);
    @crible=(1..int($crible_size/2));
}


print (2*$num_checked +1);
