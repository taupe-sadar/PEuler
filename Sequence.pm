package Sequence;
use strict;
use warnings;

#Sequence object.
# Definition : 
# u(n+1) = u(n) * coeff(0) + ... + u(n-r) * coeff( r )
# with u(0) = init(0), ... u(r) = init(r)

sub new
{
  my($class,$rcoeffs,$rinit)=@_;
  my($this)={};
  bless($this,$class);
  $$this{'coeff'}=$rcoeffs;
  $#$rcoeffs == $#$rinit  or die " Cannot create sequence of order ".($#$rcoeffs + 1)." with ".($#$rinit+1)." initial values.";
  $$this{'cache'}=[];
  
  $this->init_cache( $rinit);
  return $this;
}

sub init_cache
{
  my($this,$rinit)=@_;
  for(my($i)=0;$i<=$#$rinit;$i++)
  {
    $$this{'cache'}[$i] = $$rinit[$i];
  }
}

sub calc
{
  my($this,$idx)=@_;
  for( my($i) = $#{$$this{'cache'}}+1; $i <= $idx; $i++ )
  {
    my($val)=0;
    for( my($j) = 0; $j <= $#{$$this{'coeff'}}; $j++ )
    {
      $val += $$this{'cache'}[$i - $j - 1 ] * $$this{'coeff'}[$j];
    }
    $$this{'cache'}[$i] = $val;
  }
  
  return $$this{'cache'}[$idx];
}

sub calc_shift
{
  my($this)=@_;
  $this->calc( $#{$$this{'cache'}} + 1 );
  shift( @{$$this{'cache'}} );
}
1;
