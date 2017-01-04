use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Prime;
use Bezout;
use Fraction;

my($max_integer)=45;


my(@cool_additions)=(
{
  "numbers" => {},
  "value" => (Fraction->new(0,1))
});

my($rworking_divisors)=build_working_divisors();

for( my($i)=0;$i<=$#$rworking_divisors;$i++ )
{
  analyze_with_p_factors( $$rworking_divisors[$i] );
}


sub build_working_divisors
{
  my(@primes)=(Prime::next_prime());
  while($primes[-1]<=$max_integer)
  {
    push(@primes,Prime::next_prime());
  }
  pop(@primes);
  
  my(@working_divisors)=();
  
  
  my(%used)=();
  
  my($is_higher_than_sqrt_prime)=1;
  
  for( my($i)=$#primes;$i>=1;$i--)
  {
    my($p)=$primes[$i];
    my($p2)=$p*$p;
    
    if( $is_higher_than_sqrt_prime && $p*$p <= $max_integer )
    {
      $is_higher_than_sqrt_prime = 0;
    }
    
    my(@exps)=();
    {
      my($prod)=$p;
      while( $prod  <= $max_integer )
      {
        unshift( @exps, $prod );
        $prod*=$p;
      }
    }
    
    for( my($j)=0;$j <= $#exps; $j++ )
    {
      my($pexp)=$exps[$j];
      my($nb)=$pexp;
      my(@factors)=();
      for( my($k)=1;$k<= floor( $max_integer/$pexp); $k++ )
      {
        if( !exists($used{$nb}))
        {
          $used{$nb}=1;
          push(@factors,$k);
        }
        $nb+=$pexp;
      }
      
      my($dopush)=1;
      if( $is_higher_than_sqrt_prime )
      {
        my(@inverses)=map({Bezout::znz_inverse($_*$_,$p2)} @factors);
        my(@sols)=packsack_solutions( \@inverses, $p2, { 0 => 1 } );
        
        $dopush = 0 if( $#sols < 0 );
      }
      if( $dopush )
      {
        my($entry)={ "modulo" => $pexp, "prime" => $p, "factors" => \@factors };
        push( @working_divisors, $entry );
      }
    }
  }
  return \@working_divisors;
}

sub analyze_with_p_factors
{
  my($rworking_numbers)=@_;
  
  my($p) = $$rworking_numbers{"prime"};
  my($pexp) = $$rworking_numbers{"modulo"};
  my($rfactors)= $$rworking_numbers{"factors"};
  
  my($pexp2)=$pexp*$pexp;
  my($p2)=$p*$p;
  
  my(%hypo_vals)=browse_hypothesis(\@cool_additions,$pexp,$p);
  
 
  
  my(@inverses)=map({Bezout::znz_inverse($_*$_,$p2)} @$rfactors);
  my(@sols)=packsack_solutions( \@inverses, $p2, \%hypo_vals );
  
  if( $#sols >= 0 )
  {
    if( $pexp == 5 )
    {
      print "--- $pexp ---\n"; 
      print "Factors : ".join(" ",@$rfactors)."\n";
      for( my($i)=0;$i<=$#sols;$i++)
      {
        print " $i : ".join(" ",@{$sols[$i]{"idxs"}})."\n";
      }
      
      # print Dumper \@sols;
      <STDIN>;
    }
    
    @cool_additions = ();
    for( my($i)=0;$i<=$#sols;$i++)
    {
      my(%sol_numbers)=();
      
      
      for(my($j)=0;$j<=$#{$sols[$i]{"idxs"}};$j++)
      {
        $sol_numbers{$$rfactors[$sols[$i]{"idxs"}[$j]]*$pexp}=1;
      }
      
      my($frac)= build_hypo_frac( $pexp/$p, \%sol_numbers);
      
      my($hypo_val)= $sols[$i]{"hypo_val"};
      my($previous_hypos_vals)=$hypo_vals{$hypo_val};
      for(my($i)=0;$i<=$#$previous_hypos_vals;$i++)
      {
        my($new_frac)=$$previous_hypos_vals[$i]{"value"};
        # print "*** $x ***\n";
        # print "***  ".($x+$frac)." ***\n";
        my(%new_sol_numbers)=();
        foreach my $k1 (keys(%sol_numbers))
        {
          $new_sol_numbers{$k1}=1;
        }
        foreach my $k2 (keys(%{$$previous_hypos_vals[$i]{"numbers"}}))
        {
          $new_sol_numbers{$k2}=1;
        }
        
        # if( $pexp <= 7 )
        # {
          # print "".join(" ",(keys(%new_sol_numbers)) )." ".($frac + $new_frac)."\n";<STDIN>;
        # }
        
        
        push( @cool_additions, 
        {
          "numbers" => \%new_sol_numbers,
          "value" => ($frac + $new_frac)
        });
      }
    }
  }
  
  if( $pexp <= 27 )
  {
    print "--- $pexp ---\n";
    for( my($i)=0;$i<= $#cool_additions;$i++)
    {
        # print sprintf("%-12s",$cool_id."-$i");
        print sprintf("%-10s","$pexp-$i");
        print sprintf("%-16s","".$cool_additions[$i]{"value"});
        my($id_add)=$cool_additions[$i]{"numbers"};
        foreach my $nb (sort({$a<=>$b}keys(%$id_add)))
        {
          print "$nb ";
        }
        print "\n";
    }
    <STDIN>;
  }
}

sub browse_hypothesis
{
  my($rallhypos,$pexp,$p)=@_;
  
  my(%values_hypos)=();
  my($p2)=$p*$p;
  my($pexp2)=$pexp*$pexp;
  for(my($i)=0;$i<=$#$rallhypos;$i++)
  {
    my($frac)=$$rallhypos[$i]{"value"};
    
    my($denom)=$frac->{"denominator"};
    my($boost)=1;
    while( $denom %$pexp2 != 0 )
    {
      $boost *= $p;
      $denom *= $p;
    }
    
    my($val) = $frac->{"numerator"}*$boost* Bezout::znz_inverse($denom/$pexp2,$p2);
    $val = $val%$p2;
    
    if( !exists($values_hypos{$val}) )
    {
      $values_hypos{$val} = [];
    }
    push( @{$values_hypos{$val}}, $$rallhypos[$i] );
  }
  return %values_hypos;
}

sub build_hypo_frac
{
  my( $modulo, $rfactors ) =@_;
  my( $f )=Fraction->new(0,1);
  foreach  my $k (keys(%$rfactors))
  {
    my($factor)=$k;
    $f = $f + Fraction->new(1,$factor*$factor);
  }
  return $f;
}

sub packsack_solutions
{
  my($rarray,$modulo,$rhypos)=@_;
  
  my(@allsums)=(0);
  my(@sols)=();
  
  for(my($i)=0;$i<=$#$rarray;$i++)
  {
    my($allsums_size)=$#allsums+1;
    for(my($j)=0;$j<$allsums_size;$j++)
    {
      my($x)=($allsums[$j]+$$rarray[$i])%$modulo;
      my($opposite_in_hypo)=(-$x)%$modulo;

      if( exists($$rhypos{$opposite_in_hypo}) )
      {
        push(@sols,{"idxs"=>dec_2($allsums_size+$j),"hypo_val"=>$opposite_in_hypo});
      }
      
      push(@allsums,$x);
    }
  }
  
  return @sols;
}


sub dec_2
{
  my($x)=@_;
  my(@dec)=();
  my($i)=0;
  while($x>0)
  {
    push(@dec,$i) if($x%2 == 1);
    $i++;
    $x>>=1;
  }
  return \@dec;
  
}