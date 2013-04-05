package BlockCounting;
use strict;
use warnings;
use Sequence;

# Let F(m,n) be the number of ways to place red bars
# no less than 3 long with a black square delimiting the bars
# this is the same thing to solve G(m+1,n+1), where G(m,n)
# is the problem : solving the same thing without the black square constraint
#
# Then we may compute that G(m,n) = 2*G(m,n-1) - G(m,n - 2) + G( n - m )

sub sequence_blocksize_min
{
  my( $size ) =@_;
  my(@coeffs)=(2,-1);
  my(@inits) =(1, 1);
  if( $size == 1 )
  {
    @coeffs=(3,-1);
    @inits =(1, 2);
  }
  elsif( $size == 2 )
  {
    @coeffs=(2);
    @inits =(1);
  }
  else
  {
    for( my($i)=2; $i< $size; $i++)
    {
      push(@coeffs,0);
      push(@inits,1);
    }
    $coeffs[-1] = 1;
  }
  return Sequence->new(\@coeffs,\@inits);
}


1;
