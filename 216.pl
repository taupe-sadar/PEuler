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
my(@crible_residuals)=(0)x($n+1);
my($count_seen_primes)=0;
for(my($i)=0;$i<=$#primes;$i++)
{
  my($pr)=$primes[$i];
  
  # print "prime : $pr\n";
  
  my($residual)=0;
  if($prime_infos{$pr}==0)
  {
    print "Search residuals for $pr ...\n";
    $residual = find_residual($pr,($pr+1)/2);
    die "Could not find root of ".(($pr+1)/2)." % $pr\n" if($residual == 0);
  }
  else
  {
    $residual = $prime_infos{$pr};
  }
  
  foreach my $resi ($residual,$pr - $residual)
  {
    $count_seen_primes += init_residuals(\@crible_residuals,$pr,$resi,\%prime_infos);
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
  my($rcrible,$p,$residual,$rprime_infos)=@_;
  
  # print "--- Cribling $residual % $p ---\n";
  
  
  my($is_prime)=0;
  for(my($nb)=$residual;$nb <= $#$rcrible;$nb+=$p )
  {
    next if($$rcrible[$nb] == 1);
    
    # if( $nb > sqrt((7* $prime_limit + 1)/2) )
    # {
      # $$rcrible[$nb] = 1;
      # next;
    # }
    
    if($$rcrible[$nb] > 0 )
    {
      $$rcrible[$nb] /= $p;
    }
    else
    {
      my($fnb)=f($nb);
      
      # if( $p > 5 )
      # {
      # print ("$fnb = ".pretty_dec($fnb)."\n");<STDIN>;
      # }
      
      if($fnb == $p)
      {
        $is_prime = 1;
        $$rcrible[$nb] = 1;
        next;
      }
      else
      {
        $$rcrible[$nb] = $fnb/$p;
      }
    }
    
    while( $$rcrible[$nb] %$p == 0)
    {
      $$rcrible[$nb] /=$p;
    }
    
    if(exists($$rprime_infos{$$rcrible[$nb]}))
    {
      my($high_p)=$$rcrible[$nb];
      my($high_res)=$nb%$high_p;
      $$rprime_infos{$high_p}=$high_res;
      
      # print ("   Found residual of $high_p (from f($nb) = ".f($nb)." -> $high_res)\n");
      # my($test)=$high_res * $high_res *2 - 1;
      # print ("   $high_res * $high_res *2 - 1 = $test = ".($test % $high_p)." % $high_p\n");
      # <STDIN>;
      
      $$rcrible[$nb] = 1;
    }
    
    
  }
  # <STDIN>;
  return ($is_prime);
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