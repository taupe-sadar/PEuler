use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor ceil/;

my($max_nb)=10**6;
Prime::init_crible($max_nb);

my(%squares)=();

my($max_root) = sqrt($max_nb);

for(my($i)=1;$i<=$max_root;$i++)
{
  $squares{$i*$i}=$i;
}

my(@primes)=();
while($#primes < 0 || $primes[-1]<=$max_nb)
{
  my($p)=Prime::next_prime();
  if( $p %4 == 1 )
  {
    my($first)=floor(sqrt($p-1)/2);
    my($last)=ceil(sqrt($p-1));
    
    my($found)=0;
    
    for(my($j)=$first;$j<=$last;$j++)
    {
      my($maybe_square)= $p - $j*$j;
      if( exists($squares{$maybe_square}))
      {
        my($root)=$squares{$maybe_square};
        
        if( $root == $first )
        {
          print "First reach : $root^2 + $j^2 = $p\n";<STDIN>;
        }
        if( $root == $last )
        {
          print "Last reach : $root^2 + $j^2 = $p\n";<STDIN>;
        }
        
        $found=1;
        last;
      }
    }
    if(!$found)
    {
      print "ERROR : not found for $p\n"; <STDIN>;
    }
  }
  
  push(@primes,$p);
}