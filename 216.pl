#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;
use Bezout;
# use SmartMult;

# for debug, activate gains 25%
use integer;

#5437849
#629698

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

# for(my($i)=0;$i<=$n;$i++)
# {
  # push(@crible_residuals,f($i));
# }

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
      $prime = 2*($i*$i) - 1;
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
      
      if( $prime < $n/100 )
      {
        init_residuals_2(\@crible_residuals,$prime,$residual);
        # debug_crible(\@crible_residuals);
        init_residuals_2(\@crible_residuals,$prime,$other_res);
        # debug_crible(\@crible_residuals);
        # <STDIN>;
      }
      else
      {
        init_residuals(\@crible_residuals,$prime,$i + $prime);
        init_residuals(\@crible_residuals,$prime,$other_res);
      }
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

sub debug_crible
{
  my($cr)=@_;
  print "[";
  for(my($i)=0;$i<30;$i++)
  {
    print "$$cr[$i] ";
  }
  print "]\n";
}

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
  
  
  
  
  for(my($nb)=$residual;$nb <= $#$rcrible;$nb+=$p )
  {
    $$rcrible[$nb] = (2*$nb*$nb - 1) if( $$rcrible[$nb] == 0 );
    $$rcrible[$nb]/=$p;
    
    while( $$rcrible[$nb] %$p == 0)
    {
      $$rcrible[$nb] /=$p;
    }
  }
  # <STDIN>;
}

sub init_residuals_2
{
  my($rcrible,$p,$residual)=@_;
   
  # print "  --- Cribling $residual % $p ---\n";
  
  for(my($nb)=$residual;$nb <= $#$rcrible;$nb+=$p )
  {
    $$rcrible[$nb] = (2*$nb*$nb - 1) if( $$rcrible[$nb] == 0 );
    $$rcrible[$nb]/=$p;
  }
  
  my($p2)=$p*$p;
  my($factor)=(2*($residual*$residual) - 1)/$p;
  my($residual_steps)= $factor * Bezout::znz_inverse(4*$residual,$p)%$p;
  $residual_steps = ($residual_steps==0)?0:($p - $residual_steps);

   # print "[$p] $residual , $factor, $residual_steps\n";
  
  for(my($nb)=$residual + $residual_steps*$p;$nb <= $#$rcrible;$nb+=$p2 )
  {
    # if($p==23)
    # {
      # print "crible[$n] : $$crible[$n]\n";
      # <STDIN>;
    # }
    
    
    # my($n21)=$nb*$nb*2-1;
    # print "[$p] $nb : $n21 -> ".($n21/($p2))."\n";
    # <STDIN>;
    $$rcrible[$nb] /=$p;
    
    while( $$rcrible[$nb] %$p == 0)
    {
      $$rcrible[$nb] /=$p;
    }
    
# 7 : 2
# 17 : 3
# 31 : 4
# 71 : 6
# 97 : 7
# 127 : 8
# 23 : 9
# 199 : 10
# 241 : 11
# 41 : 12
# 337 : 13
# 449 : 15

    
    
  }
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