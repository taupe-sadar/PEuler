package ContinueFraction;
use strict;
use warnings;
use Math::BigInt;
use Data::Dumper;
use POSIX qw/floor ceil/;
 
sub period_frac_cont
{
  my($n)=@_;
  my(@list)=integers_list($n);
  return ($#list +1);
}

# Give all coefficients of the period of the Continued Fraction of
# a non square integer. Main representation : ( a0, a1, a2, ... an)
# Beware ! for the all construction list , the following periods
# start with 2 a0 : ( a0 a1 .. an 2a0 a1 .. an 2a0 .. ) 
sub integers_list
{
  my($n)=@_;
  my($gen)=generator_from_integer($n);
  
  while(!$$gen[6])
  {
    gen_next($gen);
  }
  return @{$$gen[5]};
}

######## generator ##########

# The continued fraction of x is written :
# a_0 = floor(x) , x = x_0 = a_0 + x_1 
# a_1 = floor(1/x_1) , 1/x_1 = a_1 + x_2
# ...
# a_i = floor(1/xi) , 1/x_i = a_i + x_i+1
#
# when x is an integer, the x_i numbers can be written :
# x_i = (sqrt(x) + b_i)/c_i
# where b_i and c_i are integers
#
# The first index (i) where b_i = a_0 and c_i = 1 gives the period of the continued fraction

sub generator_from_integer
{
  my($n)=@_;
  my($integer)=int(sqrt($n));
  return [-1,$n,$integer,0,1,[],0];
}

sub gen_next
{
  my($generator)=@_;
  my($i,$n,$ni,$b,$c,$alist,$complete)=(@$generator);
  $$generator[0] = $i+1;
  if($complete)
  {
    my($nexti)=($$generator[0])%($#$alist+1);
    return 2*$ni if($nexti==0);
    return $$alist[$nexti];
  }
  else
  {
    my($nexta)=int(($ni+$b)/$c);
    my($nextb)=$nexta*$c-$b;
    my($nextc)=($n-$nextb*$nextb)/$c;
    $$generator[3] = $nextb;
    $$generator[4] = $nextc;
    
    push(@{$$generator[5]},$nexta);
    if( ($nextb==$ni)&&($nextc==1) )
    {
      $$generator[6] = 1;
    }
    return $nexta;
  }
}

sub gen_get
{
  my($generator,$idx)=@_;
  my($i,$n,$ni,$b,$c,$alist,$complete)=(@$generator);
  return $ni if($idx==0);
  
  while( $idx > $#$alist && !$complete )
  {
    gen_next($generator);
    ($alist,$complete)=(@$generator[5..6]);
  }
  
  my($val)=$idx%($#$alist+1);
  return 2*$ni if($val==0);
  return $$alist[$val];
}
############

sub fraction_cont
{
  my($a,@arg)=@_;
  return ($a*$arg[0]+$arg[1],$arg[0]);
}

sub get_reduites
{
  my(@integer_list)=@_;
  my(@pn)=(Math::BigInt->new(1),Math::BigInt->new(0));
  my(@qn)=(Math::BigInt->new(0),Math::BigInt->new(1));
  
  for(my($n)=0;$n<=$#integer_list;$n++)
  {
    @pn = fraction_cont( $integer_list[$n] ,@pn);
    @qn = fraction_cont( $integer_list[$n] ,@qn);
  }

  return ($pn[0],$qn[0]);
}

# Solves equation p^2 - d * q^2 = K
# p , q , d , K all integers,
# d not a square
sub solve_diophantine_equation
{
  my( $d, $K , $max_for_p, $additional_sols ) = @_;
  
  die "Cannot solve diophantine equation with a square number" if is_perfect_square( $d );
  
  my(@period_t)= integers_list( $d );
  
  my( $parity ) = ($#period_t+1) % 2;
  
  return [] if( $K== -1 && $parity == 0 );
  
  my($p_primitive,$q_primitive ) = ( 1 , 0 );
  if( $parity == 1 )
  {
    my($l)=$#period_t + 1;
    my(@ans) = (@period_t,@period_t);
    $ans[ $l ] *= 2;
    ($p_primitive,$q_primitive ) = diophantine_primitive_solution( @ans  );
  }
  else
  {
    ($p_primitive,$q_primitive ) = diophantine_primitive_solution( @period_t  );
  }
  
  my( @primitive_solutions ) =();
  if( $K == 1 )
  {
    push( @primitive_solutions , [$p_primitive,$q_primitive]) ;
  }
  elsif( $K == -1 ) #And $parity  == 1
  {
    my( $p_pr, $q_pr) = diophantine_primitive_solution( @period_t  );
    push( @primitive_solutions , [$p_pr,$q_pr]) ;
    
  }
  else
  {
    # Complex case : must seek for all primitive solutions
    my( $last_q ) = ( $K > 0 )  ?  floor(sqrt( ($K*($p_primitive-1))/(2*$d) ) ) :  floor(sqrt( (-$K*($p_primitive+1))/(2*$d) ) ); 
    my( $first_q ) = ( $K > 0 ) ? 0 : ceil( sqrt( -$K/$d ) );
    for( my($q)= $first_q; $q  <= $last_q; $q++ )
    {
      my($p2 ) = $K + $q**2 * $d;
      my($p)=sqrt($p2);
      if( is_perfect_square( $p2 ) )
      {
        push( @primitive_solutions, [ $p, $q ]);
      }
    }
    return [] if $#primitive_solutions < 0;
    #Pushing also negative solutions;
             

    my( $num_pos_sols ) = $#primitive_solutions + 1;
    for( my($i)=$num_pos_sols - 1; $i>=0 ; $i-- )
    {
      my($p,$q)= @{$primitive_solutions[$i]};
      if( $K > 0 )
      {
        next if( $q==0 );
        $q = -$q; 
      }
      else
      {
        next if( $p==0 );
        $p = -$p;
      }
      
      ( $p, $q ) = next_equivalent_nb( $p, $q , $d , $p_primitive, $q_primitive );
      
      
      #Avoid special case, when extremals solutions are equivalents
      next if( $i == $num_pos_sols - 1 && $p == $primitive_solutions[-1][0] && $q == $primitive_solutions[-1][1] );
      
      
      push( @primitive_solutions, [$p, $q] );

    }
 
  }

  return diophantine_solutions_from_primitives( \@primitive_solutions, [$p_primitive, $q_primitive  ], $d, $max_for_p, $additional_sols ); 
}


sub diophantine_primitive_solution
{
  my( @ans )=@_;

  my(@pn_t)=(Math::BigInt->new(1),Math::BigInt->new(0));
  my(@qn_t)=(Math::BigInt->new(0),Math::BigInt->new(1));

  for( my($i)= 0 ; $i <= $#ans; $i ++ )
  {
    (@pn_t)=fraction_cont( $ans[$i] , @pn_t) ;
    (@qn_t)=fraction_cont( $ans[$i] , @qn_t) ;
  }
  return ( $pn_t[0], $qn_t[0] );
}

sub diophantine_solutions_from_primitives
{
  my( $rprimitives_sols, $rfundamental_sol, $d , $max_for_p,$additional_sols ) = @_;
  $additional_sols = 0 if( !defined( $additional_sols));
  
  my( $p0, $q0 )= ( 1, 0 );
  my( @solutions ) = ();
  my($p,$q)=( 1, 0 );
  my($counting ) = 0;
  while( $p <= $max_for_p || $counting < $additional_sols  )
  {
    for( my($i)=0;$i<= $#$rprimitives_sols; $i++ )
    {
      ( $p, $q ) = @{$$rprimitives_sols[$i]};
      ( $p, $q ) = next_equivalent_nb( $p, $q, $d, $p0, $q0 );
      
      if(  $p > $max_for_p )
      {
        last if( $counting >= $additional_sols );
        
        $counting ++;
      };
      push ( @solutions, [$p,$q] );
    }
    ($p0, $q0 ) = next_equivalent_nb( $p0, $q0, $d, $$rfundamental_sol[0], $$rfundamental_sol[1] );


  }
  return \@solutions;
}

sub next_equivalent_nb
{
  my( $p, $q, $d, $p0, $q0 ) = @_;
  return ( $p*$p0 + $q*$q0*$d , $p*$q0 + $q*$p0);
}
 
sub is_perfect_square
{
  my( $x ) = @_;
  my($squ)= sqrt($x);
  return 0 if( $squ=~m/\./ );
  return ($squ**2 == $x);
}

1;
