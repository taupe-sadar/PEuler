package Hashtools;
use List::Util qw( max min );

sub increment
{
  my($hash_ref,$key,$quantity)=@_;
  if((!defined($quantity))||(!($quantity=~m/^((-|)\d+)$/)))
  {
    $quantity=1;
  }
      
  if(!exists($$hash_ref{$key}))
  {
    if($quantity>0)
    {
      $$hash_ref{$key}=$quantity;
    }
  }
  else
  {
    if($$hash_ref{$key}+$quantity>0)
    {
      $$hash_ref{$key}+=$quantity;
    }
    else
    {
      delete $$hash_ref{$key};
    }
  }
}
1;
