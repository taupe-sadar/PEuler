package PermutationsIterator;
use strict;
use warnings;
use Data::Dumper;

#PermutationsIterator object.
# Loop over object permutation, only swappinf two elements
# At each step

sub new
{
  my($class,$rarray)=@_;
  my($this)={};
  bless($this,$class);
  $$this{'size'}=$#$rarray;
  $$this{'ref'}=$rarray;
  $$this{'counter'}=[];
  for(my($i)=0;$i<=$#$rarray;$i++)
  {
    $$this{'counter'}[$i]=0;
  }
  return $this;
}

sub next
{
  my($this)=@_;
  my($idx)=1;
  for(my($idx)=1;$idx<= $$this{'size'};$idx++)
  {
    if( $$this{'counter'}[ $idx ] == $idx )
    {
      $$this{'counter'}[ $idx ] = 0;
    }
    else
    {
      my($switched)=($idx%2 == 0) ? 0 : ( $$this{'counter'}[ $idx ]  );
      my($tmp)=$$this{'ref'}[$idx];
      $$this{'ref'}[$idx] = $$this{'ref'}[$switched];
      $$this{'ref'}[$switched] = $tmp;

      $$this{'counter'}[ $idx ]++;
      return 1;
    }
  }
  return 0;#Means end of iteration
}
1;
