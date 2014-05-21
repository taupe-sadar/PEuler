use strict;
use warnings;
use Data::Dumper;
use Prime;
use Bezout;
use Permutations;
use Math::BigInt;
use Gcd;



my( @primes_1_mod_8) =();

my( %square_components ) = ();

for( my($i) = 3; $i< 1000; $i+=2 )
{
  my($i4) = Math::BigInt->new($i)**4;
  for( my($j) = 1; $j< $i; $j+=2 )
  {
    next if( Gcd::pgcd( $i, $j ) > 1 );
    my($j4) = Math::BigInt->new($j)**4;
    my($sum4) = ($i4+$j4)/2;
    my(%dec) = decompose_with_primes_1_mod_8( $sum4 );
    
    my($p)=1;
    foreach my $k (keys(%dec))
    {
      $p *= $k if( $dec{$k} %2 == 1 );
    }
    if( $p == 1 )
    {
      print "interesting : p = 1\n";
      <STDIN>;
    }
    else
    {
      my($x0)= $i%$p;
      my($y0)= $j%$p;      
      
      my( $z0 ) = $x0* Bezout::znz_inverse( $y0, $p );
      
      my(@couples)=();
      #Building valid couples
      my( @xsols ) = ( $z0, $z0**3, -$z0, -($z0**3) );
      for( my($y) = 1; $y < $p; $y++ )
      {
        for( my($s)= 0;$s<=$#xsols; $s++ )
        {
          my( $x ) = ($y*$xsols[$s])%$p;
          push( @couples , [ $x, $y ] ) if $x <= $y;
        }
      }
      # print $#couples; <STDIN>;
      # print Dumper \@couples; <STDIN>;
      
      my( $virtual_bound ) = ($p*4)**4;
      
    }
  }
}


exit(0);

for( my($i)=1;$i<1000;$i+=2 )
{
  my($i4) = Math::BigInt->new($i)**4;
  
  for( my($j)=1;$j<$i;$j+=2 )
  {
    next if( Gcd::pgcd( $i, $j ) > 1 );
    
    my($n) = ( $i4 + Math::BigInt->new($j)**4)/2;
    # my(%dec2) = Prime::decompose( $n );
    my(%dec) = decompose_with_primes_1_mod_8( $n );
    
    
    my($squ_component)=1;
    
    foreach my $k (keys(%dec))
    {
      $squ_component *= $k if( $dec{$k} %2 == 1 );
    }

    # print( "$i - $j -> $squ_component\n" );
    # print "  ".(join(" ",keys(%dec)))." => ".(join(" ",values(%dec)))."\n";<STDIN>;
    # print "  ".(join(" ",keys(%dec2)))." => ".(join(" ",values(%dec2)))."\n";<STDIN>;
    
    if( !exists( $square_components{ $squ_component } ) )
    {
      $square_components{ $squ_component } = [ [$i,$j] ];
    }
    else
    {
      push( @{$square_components{ $squ_component }} ,  [$i,$j] ) ;
      print "$squ_component\n";
      print Dumper $square_components{ $squ_component };
      
      
      my($t,$w,$u,$v) = ( @{$square_components{ $squ_component }[0]} , @{$square_components{ $squ_component }[1]} );
      my($p,$q,$r,$s) = ( $t*$u , $v*$w , $t*$v, $w*$u );
      my( $b ,$c , $d, $e ,$f ) = ( ($p**2 + $q**2)/2 , ($p**2 - $q**2)/2, $p*$q, ($r**2 + $s**2)/2 , ($s**2 - $r**2)/2 );
      my( $a ) =  sqrt( Math::BigInt->new($b)**2 + Math::BigInt->new($f)**2) ;
      
      my($x,$y,$z)=( ($a**2 + $b**2 - $c**2)/2,  ($a**2 + $c**2 - $b**2)/2, ($b**2 + $c**2 - $a**2)/2 );
      my($sum ) = $x+$y+$z;
      
      print "$p $q $r $s\n";
      print "$a $b $c $d $e $f\n";
      print "$x $y $z -> $sum\n";
      
          
    }    
  }
}

sub decompose_with_primes_1_mod_8
{
  my( $n )= @_;
  
  my(%dec)=();
  
  my($limit) = sqrt( $n );
  my( $idx_prime ) = 0;
  my( $p ) = get_prime_1_mod_8( $idx_prime );
  while( $p <= $limit )
  {
    if( $n % $p == 0 )
    {
      $dec{ $p } = 1;
      $n/=$p;
      while( $n % $p == 0 )
      {
        $dec{ $p }++;
        $n/=$p;
      }
      $limit = sqrt( $n );
    }
    
    $idx_prime++;
    $p = get_prime_1_mod_8( $idx_prime );
  }
  $dec{$n} = 1 if( $n> 1 );
  
  return %dec;
}

sub get_prime_1_mod_8
{
  my($idx)=@_;
  while( $#primes_1_mod_8 < $idx )
  {
    my($p)=Prime::next_prime(1);
    push( @primes_1_mod_8 , $p ) if( $p %8 == 1 );
  }
  return $primes_1_mod_8[ $idx ];
}
