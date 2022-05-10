package Fraction;
use strict;
use warnings;
use Data::Dumper;
use Gcd;

use overload
  '+' => \&plus,
  '-' => \&minus,
  '*' => \&multiply,
  '/' => \&divide,
  '=='=> \&egal,
  '!='=> \&inegal,
  '""'=> \&print_frac;


sub new
{
  my ($class,$numerator,$denominator, $reduce ) = @_;
  $denominator = 1 unless(defined($denominator));
  $reduce = 1 unless(defined($reduce));

  my($this);
  if($reduce)
  {
    my($gcd)=Gcd::pgcd($numerator,$denominator);
    $this = [$numerator/$gcd,$denominator/$gcd];
  }
  else
  {
    $this = [$numerator,$denominator];
  }
  bless($this, $class);

  return $this;
}

sub numerator
{
  my($this)=@_;
  return $this->[0];
}

sub denominator
{
  my($this)=@_;
  return $this->[1];
}

sub eval_fraction
{
  my($this)=@_;
  return $this->[0]/$this->[1];
}

sub plus
{
  my($a,$b)=@_;
  my($n)= $a->[0]*$b->[1] + $b->[0]*$a->[1];
  if($n==0)
  {
    return Fraction->new(0/1);
  }
  my($d)= $a->[1]*$b->[1];
  return Fraction->new($n,$d); 
}

sub multiply
{
  my($a,$b)=@_;
  if($a->[0]==0 || $b->[0]==0  )
  {
    return Fraction->new(0/1);
  }
  my($n)= $a->[0]*$b->[0];
  
  my($d)= $a->[1]*$b->[1];
  
  return Fraction->new($n,$d); 
}

sub minus
{
  my($a,$b,$swap)=@_;
  if(defined($swap) && $swap )
  {
    ($a,$b)=($b,$a);
  }
  return $a+ Fraction->new( - $b->[0], $b->[1]);
}

sub divide
{
  my($a,$b,$swap)=@_;
  my($f)= Fraction->new($b->[1], $b->[0]);
  return $a* $f;
}

sub inverse
{
  my($a)=@_;
  return Fraction->new($a->[1], $a->[0], 0 )
}

sub egal
{
  my($a,$b)=@_;
  return ( $a->[0] == $b->[0] && $a->[1] == $b->[1] );
}

sub inegal
{
  my($a,$b)=@_;
  return ( $a->[0] != $b->[0] || $a->[1] != $b->[1] );
}

sub print_frac
{
  my($a)=@_;
  return $a->[0]."/".$a->[1];
}
1;
