package IrregularBase;
use strict;
use warnings;

sub new
{
  my ($class,@base) = @_;
  my $this = {};
  bless($this, $class);
  $this->{"base"} = @base;
  return $this;
}

1;
