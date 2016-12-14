use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Prime;
use Bezout;

my($max_integer)=80;

my(@primes)=(Prime::next_prime());
while($primes[-1]<$max_integer)
{
  push(@primes,Prime::next_prime());
}
pop(@primes);

my(%cool_additions)=();

my(%known_restrictions)=();


for( my($i)=$#primes;$i>=1;$i--)
{
  look_for_valid_solutions($primes[$i]);
}

sub look_for_valid_solutions
{
  my($p)=@_;
  
  my($p2)=$p*$p;
  
  die "Not implemented 'p' square" if( $p2 <= $max_integer );
  
  my($highest_factor)= floor( $max_integer/$p );
  my(@squares)=();
  my($nb)=$p;
  for( my($k)=1;$k<=$highest_factor;$k++)
  {
    if( exists( $known_restrictions{ $nb } ))
    {
      die "Not impl restrictions ($nb)\n";
    }
    else
    {
      push(@squares,$k*$k);
    }
    $nb+=$p;
  }
  
  my(@inverses)=map({Bezout::znz_inverse($_,$p2)} @squares);
  my(@sols)=packsack_solutions( \@inverses, $p2 );
  
  $nb=$p;
  my($cool_id)=($#sols < 0)?"NONE":"Hypo-$p";
  
  for( my($k)=1;$k<=$highest_factor;$k++)
  {
    $known_restrictions{ $nb } = "NONE";
    $nb+=$p;
  }
  
  if( $#sols >= 0 )
  {
    $cool_additions{$cool_id} = build_hypo( $p, \@sols);
    print "$p : ";
    print Dumper \@inverses;
    print Dumper \@sols;
  }
}

sub build_hypo
{
  my( $modulo, $rfactors ) =@_;
  
  return {};
  
}

sub packsack_solutions
{
  my($rarray,$modulo)=@_;
  
  my(@allsums)=(0);
  my(@sols)=();
  
  for(my($i)=0;$i<=$#$rarray;$i++)
  {
    my($allsums_size)=$#allsums+1;
    for(my($j)=0;$j<$allsums_size;$j++)
    {
      my($x)=($allsums[$j]+$$rarray[$i])%$modulo;
      if( $x == 0 )
      {
        push(@sols,dec_2($allsums_size+$j));
      }
      
      push(@allsums,$x);
    }
  }
  return @sols;
}

sub dec_2
{
  my($x)=@_;
  my(@dec)=();
  my($i)=0;
  while($x>0)
  {
    push(@dec,$i) if($x%2 == 1);
    $i++;
    $x>>=1;
  }
  return \@dec;
  
}