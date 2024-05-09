#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;
# use SmartMult;

my($n)=50000000;

my($sq2)=sqrt(2);
my($prime_limit)=$n*$sq2;

if(0) #old prime search
{
  Prime::init_crible($prime_limit+1000);

  Prime::next_prime();
  my($p)=Prime::next_prime();
  my(@primes)=();
  my(%prime_infos)=();
  while($p < $prime_limit)
  {
    my($sm)= smart_mult_modulo(2,($p-1)/2,$p);
    
    if( $sm == 1 )
    {
      push(@primes,$p);
      $prime_infos{$p}=0;
    }
    $p=Prime::next_prime();
  }
  print "Primes : $#primes\n";
  print ("[".join(" ", @primes[0..20])."]\n");
  # exit(0);
}

my(@crible_residuals)=(0)x($n+1);
my($count_seen_primes)=0;
for(my($i)=2;$i<=$n;$i++)
{
  
  # print "prime : $pr\n";
  
  if($crible_residuals[$i]!=1)
  {
    my($prime)=0;
    if($crible_residuals[$i]==0)
    {
      $count_seen_primes++;
      $crible_residuals[$i] = 1;
      $prime = f($i);
      # print "($prime)\n";<STDIN>;
    }
    else
    {
      $prime = $crible_residuals[$i];
    }
    
    my($residual)=$i;
    print "$prime : $i\n" if($i < 100);
    my($other_res)=$prime - $i;
    if( $other_res < $n )
    {
      init_residuals(\@crible_residuals,$prime,$i);
      init_residuals(\@crible_residuals,$prime,$other_res);
    }
  }
}
print "$count_seen_primes\n";
# print Dumper \@potentials2;<STDIN>;


# for(my($i)=1;$i<=$n;$i++)
# {
  # my($fx)=f($i);
  # print "$i : $fx\n";
# }

sub f
{
  my($x)=@_;
  return 2*$x*$x-1;
}

sub pretty_dec
{
  my($n)=@_;
  my(%dec)=Prime::decompose($n);
  my($s)="";
  foreach my $pr (sort({$a<=>$b}(keys(%dec))))
  {
    $s.=($pr."($dec{$pr}) ");
  }
  return $s;
}

sub init_residuals
{
  my($rcrible,$p,$residual)=@_;
  
  # print "--- Cribling $residual % $p ---\n";
  
  
  for(my($nb)=$residual;$nb <= $#$rcrible;$nb+=$p )
  {
    if( $$rcrible[$nb] == 0 )
    {
      $$rcrible[$nb] = f($nb)/$p;
    }
    
    while( $$rcrible[$nb] %$p == 0)
    {
      $$rcrible[$nb] /=$p;
    }
  }
  # <STDIN>;
}

sub find_residual
{
  my($p,$residual)=@_;
  for(my($i)=2;$i<=floor($p/2);$i++)
  {
    if( ($i*$i)%$p == $residual )
    {
      # if( $p> 50000000 )
      # {
        # print "$p : $i (".($i*$i*2)." == $residual)\n";
        # <STDIN>;
      # }
      
      return $i;
    }
  }
  return 0;
}


sub smart_mult_modulo
{
  my($n,$pow,$modulo)=@_;
  my($powwow)=1;
  my($bound)=1<<32;
  do
  {
    if($pow& 0x1)
    {
      $powwow=($powwow*$n)%$modulo;
      $pow--;
    }
    $pow>>=1;
    if($pow>0)
    {
      $n=($n*$n)%$modulo;
      # $n=($n*$n);
      # $n = $n%$modulo if($n > $bound);
    }
    
  }while($pow>0);
  return $powwow;
}