package MsysChomp;
use strict;
use warnings;
use Data::Dumper;

sub chomp
{
  my( $rline ) = @_;
  while( $$rline =~ m/^(.*)(\r|\n)$/ )
  {
    $$rline = $1;
  }
}
1;
