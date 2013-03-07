use 1.0.0;
use strict;
use warnings;
use Data::Dumper;

{
my($statictruc)=3.14;


 my($reffunc)= sub { 
  my($parameter)=@_;
  print "lol : $parameter ($statictruc)\n";
  if( $parameter =~m/^\d+$/)
  {
    return ($parameter*1000);
  }
    return uc($parameter);
  };
 $statictruc = 2.76;
  my($ret)=do_something_with_ref( $reffunc );
  print "Return $ret\n";

}

sub do_something_with_ref
{
  my($reffunc)=@_;
  return &$reffunc("fkgnl");
}