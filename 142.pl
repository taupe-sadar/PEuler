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

my( @current_quad_quad_solution ) = ();
my( $current_a_square ) = 0;
my( $best_final_sum ) = 0;

my($stop) = 0;
my($first_pass ) = 1;

find_this_quad_sum( 3, 1 );

$first_pass = 0;

for( my($i) = 5; !$stop; $i+=2 )
{
  for( my($j) = 1; $j< $i; $j+=2 )
  {
    next if( Gcd::pgcd( $i, $j ) > 1 );
    
    # print "Start couple $i $j\n";
    find_this_quad_sum( $i,$j );
  }
}

print $best_final_sum;

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
      push(@{$square_components{$squ_component}} ,[$i,$j]);
      print "$i - $j -> $squ_component\n";
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

sub find_this_quad_sum
{
  my($i,$j)=@_;
  my($i4) = Math::BigInt->new($i)**4;
  my($j4) = Math::BigInt->new($j)**4;
  my($sum4) = ($i4+$j4)/2;
  my(%dec) = decompose_with_primes_1_mod_8( $sum4 );
  
  my($p)=1;
  foreach my $k (keys(%dec))
  {
    $p *= $k if( $dec{$k} %2 == 1 );
  }
  
  {
    my($x0)= $i%$p;
    my($y0)= $j%$p;      
    if( $x0 > $y0 )
    {
      $x0 = $j%$p;
      $y0 = $i%$p;
    }
    
    my( $z0 ) = $x0* Bezout::znz_inverse( $y0, $p );
    
    my($trivial_bound)= sum_quadring( $x0, $y0); 
    
    my($last_passes_val)=0;
    if( !$first_pass )
    {
      $last_passes_val = int( sqrt(sqrt($current_a_square/$trivial_bound))) + 1;
    }
    
    
    my(@couples)=();
    #Building valid couples
    my( @xsols ) = ( $z0, $z0**3, -$z0, -($z0**3) );
    for( my($y) = 1; $y < $p; $y++ )
    {
      last if( !$first_pass && $y > $last_passes_val );
      
      my(@sorted_sols ) = sort( map { ($_ * $y)%$p } @xsols );
      
      for( my($s)= 0;$s<=$#sorted_sols; $s++ )
      {
        my( $x ) = $sorted_sols[$s];
        push( @couples , [ $y, $x ] ) if $x >= $y;
      }
    }
    
    # print Dumper \@couples;    <STDIN>;
    
    if( $j == 1 && $#current_quad_quad_solution >= 0 && $trivial_bound**2 > $current_a_square)
    {
      $stop = 1;
      last;
    }
    
    for( my($bound) = 0; ($#current_quad_quad_solution < 0) || (sum_quadring( $bound*$p + 1, 1) * $trivial_bound <= $current_a_square); $bound++ )
    {
      # print "BOUND $bound\n";
      # print "Couples : ".($#couples+1)."\n";
      
      my(@sols)=();
      for( my( $h ) = 0 ; $h <= $bound; $h++)
      {
        my(@idxs) = find_sol_square( \@couples, $bound, $h, $p );
        for(my( $ix ) = 0 ; $ix <= $#idxs; $ix++ )
        {
          push( @sols, [$couples[$idxs[$ix]][0] + $bound*$p, $couples[$idxs[$ix]][1] + $h*$p]);
        }
      }
      for( my( $h ) = 0 ; $h < $bound; $h++)
      {
        my(@idxs) = find_sol_square( \@couples, $h, $bound, $p );
        for(my( $ix ) = 0 ; $ix <= $#idxs; $ix++ )
        {
          push( @sols, [$couples[$idxs[$ix]][0] + $h*$p, $couples[$idxs[$ix]][1] + $bound*$p]);
        }
      }
      
      for(my( $i ) = 0 ; $i <= $#sols; $i++ )
      {
        my($rsol) = $sols[$i];
        next if( $$rsol[0] == $x0 && $$rsol[1] == $y0 );
        
        my($new_square) = sum_quadring( $$rsol[0], $$rsol[1]);  
        
        # print "$x0,$y0, $$rsol[0], $$rsol[1]\n";
        
        my($newsum ) = final_sum($x0,$y0,@$rsol);
        if( $#current_quad_quad_solution < 0 || $newsum < $best_final_sum)
        {
          @current_quad_quad_solution = @$rsol;
          $current_a_square = $trivial_bound * $new_square;
          $best_final_sum = $newsum;
          print "Found $x0 $y0 $$rsol[0] $$rsol[1] $newsum\n";
        }
      }
    }
  }
}


sub final_sum
{
  my($t,$w,$u,$v)=@_;
  my($x,$y,$z) = final_numbers( $t,$w,$u,$v );
  return ($x+$y+$z);
}

sub final_numbers
{
  my($t,$w,$u,$v) = @_;
  if( $t < $w )
  {
    ($t,$w) = ($w,$t);
  }
  if( $u < $v )
  {
    ($u,$v) = ($v,$u);
  }
  if( $u * $w > $t * $v )
  {
    ($u,$v,$t,$w) = ($t,$w,$u,$v);
  }
  
  my($p,$q,$r,$s) = ( Math::BigInt->new($t*$u) , Math::BigInt->new($v*$w) , Math::BigInt->new($t*$v), Math::BigInt->new($w*$u) );
  my( $b ,$c , $d, $e ,$f ) = ( ($p**2 - $q**2)/2 , ($p**2 + $q**2)/2, ($r**2 + $s**2)/2 , ($r**2 - $s**2)/2, $p*$q );
  my( $a ) =  sqrt(($p**4 + $q**4 + $r**4 + $s**4)/4) ;
  
  my($x,$y,$z)=( ($a**2 + $c**2 - $b**2)/2,  ($a**2 + $b**2 - $c**2)/2, ($b**2 + $c**2 - $a**2)/2 );
   
  my($sum ) = $x+$y+$z;
  
  print "-------------\n";
  print "$t $w $u $v\n";
  print "$p $q $r $s\n";
  print "$a $b $c $d $e $f\n";
  print "$x $y $z -> $sum\n";
  
  print "-------------\n";
  
  
  
  return ($x,$y,$z);
}

sub sum_quadring
{
  my( $x, $y) = @_;
  return (Math::BigInt->new($x)**4 + Math::BigInt->new($y)**4)/2;
}

sub find_sol_square
{
  my($rcouples, $m, $n,$p ) = @_;
  my(@ret)=();
  for( my($a)=0;$a<=$#$rcouples;$a++)
  {
    my($x) = ($$rcouples[$a][0] + $m*$p);
    my($y) = ($$rcouples[$a][1] + $n*$p);
    
    next if(($x%2 == 0) ||( $y%2 == 0));
    next if( Gcd::pgcd( $x, $y ) > 1 );
    
    my($square)= sum_quadring($x,$y)/$p;
    my($root) = int(sqrt($square));
    
    push(@ret,$a) if( $root**2 == $square) ;
  }
  return @ret;
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
