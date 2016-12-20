use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Prime;
use Bezout;
use Fraction;

my($max_integer)=45;

my(@primes)=(Prime::next_prime());
while($primes[-1]<$max_integer)
{
  push(@primes,Prime::next_prime());
}
pop(@primes);

my(%cool_additions)=();

my(%known_restrictions)=();


for( my($i)=$#primes;$i>=1;$i--)
{
  look_for_valid_solutions($primes[$i]);
}

sub look_for_valid_solutions
{
  my($p)=@_;
  my($pf)=$p;
  
  my(@values)=();
  while( $pf <= $max_integer )
  {
    push(@values,$pf);
    $pf*=$p;
  }
  for(my($i)=$#values;$i>=0;$i--)
  {
    analyze_with_p_factors($p,$i+1,$values[$i]);
  }
}

sub analyze_with_p_factors
{
  my($p,$exp,$pexp)=@_;
  
  my($pexp2)=$pexp*$pexp;
  my($p2)=$p*$p;
  
  my($highest_factor)= floor( $max_integer/$pexp );
  my(@factors)=();
  my(@squares)=();
  my($nb)=$pexp;
  
  my(%previous_hypothesis)=();
  
  for( my($k)=1;$k<=$highest_factor;$k++)
  {
    if( exists( $known_restrictions{ $nb } ))
    {
      if( $known_restrictions{ $nb }{"type"} ne "NONE" )
      {
        retrieve_concern_hypothesis( $nb, \%previous_hypothesis);
      }
    }
    else
    {
      push(@factors,$k);
      push(@squares,$k*$k);
    }
    $nb+=$pexp;
  }
  
  my(%hypo_vals)=browse_hypothesis(\%previous_hypothesis,$pexp,$p);
  
  my(@inverses)=map({Bezout::znz_inverse($_,$p2)} @squares);
  my(@sols)=packsack_solutions( \@inverses, $p2, \%hypo_vals );
  
  $nb=$pexp;
  for( my($k)=1;$k<=$highest_factor;$k++)
  {
    $known_restrictions{ $nb } = {"type" => "NONE"};
    $nb+=$pexp;
  }
  
  if( $#sols >= 0 )
  {
    if( $pexp == 5 )
    {
      print "--- $pexp ---\n"; 
      print "Factors : ".join(" ",@factors)."\n";
      for( my($i)=0;$i<=$#sols;$i++)
      {
        print " $i : ".join(" ",@{$sols[$i]{"idxs"}})."\n";
      }
      
      # print Dumper \@sols;
      <STDIN>;
    }
    
    my($cool_id)="Hypo-$pexp";
    $cool_additions{$cool_id} = [];
    for( my($i)=0;$i<=$#sols;$i++)
    {
      my(%sol_numbers)=();
      for(my($j)=0;$j<=$#{$sols[$i]{"idxs"}};$j++)
      {
        $sol_numbers{$factors[$sols[$i]{"idxs"}[$j]]*$pexp}=1;
      }
      
      my($frac)= build_hypo_frac( $pexp/$p, \%sol_numbers);
      
      my($hypo_val)= $sols[$i]{"hypo_val"};
      my($previous_hypos_vals)=$hypo_vals{$hypo_val};
      for(my($i)=0;$i<=$#$previous_hypos_vals;$i++)
      {
        my($new_frac)=retrieve_hypo_frac($$previous_hypos_vals[$i]{"hypos"});
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
        
        
        push( @{$cool_additions{$cool_id}}, 
        {
          "numbers" => \%new_sol_numbers,
          "value" => ($frac + $new_frac)
        });
      }
    }
    
    rebuild_restrictions();
  }
  
  foreach my $cool_id2 (keys(%cool_additions))
  {
    my($class)=$cool_additions{$cool_id2};
    my(@new_hypos)=();
    my(@concerned)=();
    for( my($i)=0;$i<=$#$class;$i++ )
    {
      if( !exists($previous_hypothesis{$cool_id2."_$i"}) )
      {
        push(@new_hypos,$$class[$i]);
      }
    }
    $cool_additions{$cool_id2} = \@new_hypos;
  }
  
  if( $pexp <= 9 )
  {
    print "--- $pexp ---\n";
    foreach my $cool_id (keys(%cool_additions))
    {
      my($id_additions)=$cool_additions{$cool_id};
      for(my($i)=0;$i<=$#$id_additions;$i++)
      {
        print sprintf("%-12s",$cool_id."-$i");
        print sprintf("%-16s","".$$id_additions[$i]{"value"});
        my($id_add)=$$id_additions[$i]{"numbers"};
        foreach my $nb (sort({$a<=>$b}keys(%$id_add)))
        {
          print "$nb ";
        }
        print "\n";
      }
    }
    <STDIN>;
  }
}

sub rebuild_restrictions
{
  foreach my $k (keys(%known_restrictions))
  {
    $known_restrictions{$k}{"type"}="NONE";
  }
  
  foreach my $cool_id (keys(%cool_additions))
  {
    my($id_additions)=$cool_additions{$cool_id};
    my(@restrictions)=();
    for(my($i)=0;$i<=$#$id_additions;$i++)
    {
      my($id_add)=$$id_additions[$i]{"numbers"};
      
      foreach my $nb (keys(%$id_add))
      {
        my($super_cool_id)=$cool_id."_$i";
        if( !exists($known_restrictions{$nb}) || $known_restrictions{$nb}{"type"} eq "NONE" )
        {
          $known_restrictions{$nb}{"type"} = "available";
          $known_restrictions{$nb}{"hypos"} = [];
        }
        push( @{$known_restrictions{$nb}{"hypos"}}, $super_cool_id );
      }
    }
  }
}

sub retrieve_hypo_frac
{
  my($rhypos)=@_;
  my($frac)=Fraction->new(0,1);
    
  for(my($j)=0;$j<=$#$rhypos;$j++)
  {
    my($cool_addition)=getIdxHypo($$rhypos[$j]);
    $frac = $frac + $$cool_addition{"value"};
  }
  return $frac;
}

sub retrieve_concern_hypothesis
{
  my($nb,$rhash)=@_;
  
  my($rarray_cool_ids)=$known_restrictions{ $nb }{"hypos"};
  for(my($j)=0;$j<=$#$rarray_cool_ids;$j++)
  {
    $$rhash{$$rarray_cool_ids[$j]}=1;
  }
}

sub browse_hypothesis
{
  my($rhypos,$pexp,$p)=@_;
  
  my(@hypos)=(keys(%$rhypos));
  my(@combined)=loop_hypos(@hypos);
  
  if( $pexp == 3 )
  {
    print $#combined + 1; <STDIN>;
  }
  
  my(%values_hypos)=();
  my($p2)=$p*$p;
  my($pexp2)=$pexp*$pexp;
  for(my($i)=0;$i<=$#combined;$i++)
  {
    my($rhypos)=$combined[$i]{"hypos"};
    
    my($frac)=retrieve_hypo_frac($rhypos);
    
    my($denom)=$frac->{"denominator"};
    my($boost)=1;
    while( $denom %$pexp2 != 0 )
    {
      $boost *= $p;
      $denom *= $p;
    }
    
    my($val) = $frac->{"numerator"}*$boost* Bezout::znz_inverse($denom/($pexp*$pexp),$p2);
    $val = $val%$p2;
    
    if( !exists($values_hypos{$val}) )
    {
      $values_hypos{$val} = [];
    }
    push( @{$values_hypos{$val}}, $combined[$i] );
  }
  return %values_hypos;
}


sub loop_hypos
{
  my(@hypos)=@_;
  
  if( $#hypos < 0)
  {
    return ({"numbers" => {},"hypos"=> []});
  }
  else
  {
    my($hypothesis)=getIdxHypo($hypos[0]);
    
    my(@others)=@hypos[1..$#hypos];
    my(@sols_others)=loop_hypos(@others);
    
    my(@new_sols)=();
    for( my($a)=0;$a<=$#sols_others;$a++)
    {
      my($rused)=$sols_others[$a]{"numbers"};
      my($valid)=1;
      foreach my $n (keys( %{$$hypothesis{"numbers"}} ))
      {
        if( exists($$rused{$n}))
        {
          $valid = 0;
          last;
        }
      }
      if( $valid )
      {
        my(%new_numbers)=();
        my(@new_hypos)=($hypos[0], @{$sols_others[$a]{"hypos"}});
        foreach my $n (keys( %{$$hypothesis{"numbers"}} ))
        {
          $new_numbers{$n}=1;
        }
        foreach my $n (keys( %$rused ))
        {
          $new_numbers{$n}=1;
        }
        my($nsol)={"numbers" => \%new_numbers,"hypos"=> \@new_hypos};
        if(!does_hypo_already_exists( $nsol , \@sols_others ))
        {
          push(@new_sols,$nsol);
        }
      }
    }
    
    return (@sols_others,@new_sols);
  }
}

sub getIdxHypo
{
  my($key_idx_hypo)=@_;
  my($hypop,$num)=split("_",$key_idx_hypo);
  return $cool_additions{$hypop}[$num];
}

sub does_hypo_already_exists
{
  my($rsol,$rall_sols)=@_;
  my($rcandidate_numbers)=$$rsol{"numbers"};
  my(@keys_cand)=(keys(%$rcandidate_numbers));
  for( my($a)=0;$a<=$#$rall_sols; $a++ )
  {
    my($rthis_numbers)=$$rall_sols[$a]{"numbers"};
    my(@key_this)=(keys(%$rthis_numbers));
    next if( $#key_this != $#keys_cand );
    
    my($is_equal)=1;
    for( my($b)=0; $b<= $#keys_cand; $b++ )
    {
      if( !exists($$rthis_numbers{$keys_cand[$b]} ))
      {
        $is_equal = 0;
        last;
      }
    }
    return 1 if($is_equal);
  }
  return 0;
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
        # if( $modulo == 25 )
        # {
          # print "--- $x ($$rarray[$i])\n";
        # }
        
        
        push(@sols,{"idxs"=>dec_2($allsums_size+$j),"hypo_val"=>$opposite_in_hypo});
      }
      
      push(@allsums,$x);
    }
  }
  
  
  my(@reduced)=reduce_sols(@sols);
  # for( my($i)=0;$i<= $#reduced; $i++ )
  # {
    # print "".join(" ",@{$reduced[$i]{"idxs"}})." - ".$reduced[$i]{"hypo_val"}."\n";
  # }
  
  
  return @reduced;
}

sub reduce_sols
{
  my(@sols)=@_;
  my(@hashes)=();
  for(my($i)=0;$i<=$#sols;$i++)
  {
    my(%h)=();
    for(my($j)=0;$j<=$#{$sols[$i]{"idxs"}};$j++)
    {
      $h{$sols[$i]{"idxs"}[$j]}=1;
    }
    push(@hashes,\%h);
  }
  
  my(@smallers)=();
  for(my($i)=0;$i<=$#hashes;$i++)
  {
    my(@keys_i)=(keys(%{$hashes[$i]}));
    my($is_redondant)=0;
    for(my($j)=0;$j<=$#hashes;$j++)
    {
      next if( $i == $j );
      next if( $sols[$j]{"hypo_val"} != 0 );
      my(@keys_j)=(keys(%{$hashes[$j]}));
      next if( $#keys_i < $#keys_j );
      my($j_is_included_in_i)=1;
      foreach my $k (@keys_j)
      {
        if( !exists($hashes[$i]{$k}) )
        {
          $j_is_included_in_i = 0;
          last;
        }
      }
      if( $j_is_included_in_i )
      {
        $is_redondant = 1;
        last;
      }
    }
    if( !$is_redondant )
    {
      push(@smallers,$sols[$i]);
    }
  }
  return  @smallers;
  
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