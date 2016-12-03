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

sub sequence_blocksize_min_max
{
  my( $sizemin,$sizemax ) =@_;
  my(@coeffs)=(1);
  if( $sizemin == 1 )
  {
    @coeffs=(2);
  }
  for(my($i)=2;$i<$sizemin;$i++)
  {
    push(@coeffs,0);
  }
  my($first)=($sizemin==1)?2:$sizemin ;
  for(my($i)=$first;$i<=$sizemax;$i++)
  {
    push(@coeffs,1);
  }

  my(@inits)=();
  for(my($i)=0;$i<$sizemax-1;$i++)
  {
    push(@inits,0);
  }
  push(@inits,1);
  my($seq)=Sequence->new(\@coeffs,\@inits);
  
  for(my($i)=0;$i<$sizemax-1;$i++)
  {
    $seq->calc_shift();
   
  } 
  return  $seq;
}

1;
