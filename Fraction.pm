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
  my ($class,$numerator,$denominator) = @_;
  $denominator = 1 unless(defined($denominator));

  my($gcd)=Gcd::pgcd($numerator,$denominator);
  my $this = [$numerator/$gcd,$denominator/$gcd];
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

sub string_fraction
{
  my($this)=@_;
  return "".$this->[0]."/".$this->[1];
}

sub eval_fraction
{
  my($this)=@_;
  return $this->[0]/$this->[1];
}

sub plus
{
  my($a,$b)=@_;
  assertFracton(\$a);
  assertFracton(\$b);
  my($n)= $a->[0]*$b->[1] + $b->[0]*$a->[1];
  if($n==0)
  {
    return Fraction->new(0/1);
  }
  my($d)= $a->[1]*$b->[1];
  my($gcd)=Gcd::pgcd($n,$d);
  return Fraction->new($n/$gcd,$d/$gcd); 
}

sub multiply
{
  my($a,$b)=@_;
  assertFracton(\$a);
  assertFracton(\$b);
  if($a->[0]==0 || $b->[0]==0  )
  {
    return Fraction->new(0/1);
  }
  my($gcd1)= Gcd::pgcd($a->[0],$b->[1]);
  my($gcd2)= Gcd::pgcd($b->[0],$a->[1]);
  my($n)= $a->[0]/$gcd1*$b->[0]/$gcd2;
  
  my($d)= $a->[1]/$gcd2*$b->[1]/$gcd1;
  
  return Fraction->new($n,$d); 
}

sub minus
{
  my($a,$b,$swap)=@_;
  if(defined($swap) && $swap )
  {
    ($a,$b)=($b,$a);
  }
  assertFracton(\$b);
  return $a+ Fraction->new( - $b->[0], $b->[1]);
}

sub divide
{
  my($a,$b,$swap)=@_;
  assertFracton(\$b);
  my($f)= Fraction->new($b->[1], $b->[0]);
  return $a* $f;
}

sub egal
{
  my($a,$b)=@_;
  assertFracton(\$a);
  assertFracton(\$b);
  return ( $a->[0] == $b->[0] && $a->[1] == $b->[1] );
}

sub inegal
{
  my($a,$b)=@_;
  assertFracton(\$a);
  assertFracton(\$b);
  return ( $a->[0] != $b->[0] || $a->[1] != $b->[1] );
}

sub print_frac
{
  my($a)=@_;
  return $a->[0]."/".$a->[1];
}

sub assertFracton
{ 
  my($ref)=@_;
  if(ref($ref) eq "SCALAR")
  {
    $$ref = Fraction->new( $$ref);
  }
}

1;
