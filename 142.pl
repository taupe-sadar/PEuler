use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

use Pythagoriciens;

# on utilise 
#   x + y = a**2
#   x + z = b**2
#   y + z = c**2
#   x - y = d**2
#   x - z = e**2
#   y - z = f**2
#  on a les equations pythagoriciennes : 
#   a**2 = b**2 + d**2
#   a**2 = c**2 + e**2
#   c**2 = b**2 + f**2
#   d**2 = e**2 + f**2
#  Parite : on a forcement a,d,f impairs et b,c,e pairs. 


my($bound ) = 100000;
my(@pythas) = Pythagoriciens::primitive_triplets_values( $bound );

my(%fstore)=();
foreach my $pytha (@pythas)
{
  my( $big ) = $$pytha[2];
  my( $kmax ) = floor( $bound/$big );
  for( my($k)= 1; $k<= $kmax; $k +=2 )
  {
    my(@pytha_mult) = map {$_*$k} @$pytha;
    
    my($f) = $pytha_mult[1];
    if( !exists( $fstore{$f}) )
    {
      $fstore{$f} = [\@pytha_mult];
    }
    else
    {
      push( @{$fstore{$f}}, \@pytha_mult );
    }
  }
}

my( @abcdef ) =();

foreach my $f (sort({$a<=>$b}(keys(%fstore))))
{
  last if( $#abcdef >=0 && $f > $abcdef[0] );
  
  foreach my $triplet (@{$fstore{$f}})
  {
    my($d) = $$triplet[2];
    
    next if( $#abcdef >=0 && $d > $abcdef[0] );
    
    foreach my $triplet_d (@{$fstore{$d}})
    {
      my($b) = $$triplet_d[0];
      next if( $#abcdef >=0 && $b > $abcdef[0] );
      
      foreach my $triplet_f_again (@{$fstore{$f}})
      {
        if( $b == $$triplet_f_again[0] )
        {
          my(@abcdef_test) = ($$triplet_d[2],$b,$$triplet_f_again[2],$d,$$triplet[0],$f);
          
          if( $abcdef_test[0]**2 < ($abcdef_test[1]**2 + $abcdef_test[2]**2) )
          {
            @abcdef = @abcdef_test;
          }
        }
      }
    }
  }

}

print "".(($abcdef[0]**2 + $abcdef[1]**2 + $abcdef[2]**2)/2);
