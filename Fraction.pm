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
  if(!defined($denominator))
  {
    $denominator = 1;
  }
  my $this = {};
  bless($this, $class);
  $this->{"numerator"} = $numerator;
  $this->{"denominator"} = $denominator;
  my($gcd)=Gcd::pgcd($numerator,$denominator);
  $this->{"numerator"} = $numerator/$gcd;
  $this->{"denominator"} = $denominator/$gcd;

  return $this;
}

sub string_fraction
{
  my($this)=@_;
  return "".$this->{"numerator"}."/".$this->{"denominator"};
}

sub eval_fraction
{
  my($this)=@_;
  return $this->{"numerator"}/$this->{"denominator"};
}

sub plus
{
  my($a,$b)=@_;
  assertFracton(\$a);
  assertFracton(\$b);
  my($n)= $a->{"numerator"}*$b->{"denominator"} + $b->{"numerator"}*$a->{"denominator"};
  if($n==0)
  {
    return Fraction->new(0/1);
  }
  my($d)= $a->{"denominator"}*$b->{"denominator"};
  my($gcd)=Gcd::pgcd($n,$d);
  return Fraction->new($n/$gcd,$d/$gcd); 
}

sub multiply
{
  my($a,$b)=@_;
  assertFracton(\$a);
  assertFracton(\$b);
  if($a->{"numerator"}==0 || $b->{"numerator"}==0  )
  {
    return Fraction->new(0/1);
  }
  my($gcd1)= Gcd::pgcd($a->{"numerator"},$b->{"denominator"});
  my($gcd2)= Gcd::pgcd($b->{"numerator"},$a->{"denominator"});
  my($n)= $a->{"numerator"}/$gcd1*$b->{"numerator"}/$gcd2;
  
  my($d)= $a->{"denominator"}/$gcd2*$b->{"denominator"}/$gcd1;
  
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
  return $a+ Fraction->new( - $b->{"numerator"}, $b->{"denominator"});
}

sub divide
{
  my($a,$b,$swap)=@_;
  assertFracton(\$b);
  my($f)= Fraction->new($b->{"denominator"}, $b->{"numerator"});
  return $a* $f;
}

sub egal
{
  my($a,$b)=@_;
  assertFracton(\$a);
  assertFracton(\$b);
  return ( $a->{"numerator"} == $b->{"numerator"} && $a->{"denominator"} == $b->{"denominator"} );
}

sub inegal
{
  my($a,$b)=@_;
  assertFracton(\$a);
  assertFracton(\$b);
  return ( $a->{"numerator"} != $b->{"numerator"} || $a->{"denominator"} != $b->{"denominator"} );
}

sub print_frac
{
  my($a)=@_;
  return "$a->{numerator}/$a->{denominator}";
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
