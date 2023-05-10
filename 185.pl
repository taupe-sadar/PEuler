use strict;
use warnings;
use Data::Dumper;

my(@raw_grid)=(
  [90342,2],
  [70794,0],
  [39458,2],
  [34109,1],
  [51545,2],
  [12531,1]
);

my($init_state)=build_initial_state(\@raw_grid);

my(@init_checks)=();
for(my($i)=0;$i<=$#{$$init_state{"board"}};$i++)
{
  if($$init_state{"board"}[$i]{"match"} == 0)
  {
    push(@init_checks,["line",$i]);
  }    
}
process_checks($init_state,\@init_checks);

backtrack($init_state);

sub backtrack
{
  my($base_state)=@_;
  print_state($base_state);

  my($rtries)=list_tries($base_state);
  for(my($i)=0;$i<=$#$rtries;$i++)
  {
    my(@checks)=();
    my($state)=copy_state($base_state);
    place_digit($state,\@checks,@{$$rtries[$i]});
    my($ret)=process_checks($state,\@checks);
    print_state($state);
    print "Result : $ret\n";
    <STDIN>;
  }
}

sub list_tries
{
  my($state)=@_;
  my(@t)=();
  for(my($i)=0;$i<$$state{'size'};$i++)
  {
    for my $cand (keys(%{$$state{'candidates'}[$i]}))
    {
      push(@t,[$i,$cand]);
    }
  }
  return \@t;
}

sub print_state
{
  my($rstate)=@_;
  print "--------\n";
  print_board($rstate);
  print "--------\n";
  print join('',@{$$rstate{'solution'}})."\n";
  print "--------\n";
  my(@list)=();
  my($max)=0;
  for(my($j)=0;$j<$$rstate{'size'};$j++)
  {
    my(@ks)=sort(keys(%{$$rstate{'candidates'}[$j]}));
    push(@list,\@ks);
    $max = $#ks+1 if( $#ks + 1 > $max );
  }
  for(my($i)=0;$i<$max;$i++)
  {
    for(my($j)=0;$j<$$rstate{'size'};$j++)
    {
      if($#{$list[$j]} >= $i)
      {
        print $list[$j][$i];
      }
      else
      {
        print ' ';
      }
    }
    
    print "\n";
  }
  print "--------\n";
}

sub print_board
{
  my($rstate)=@_;
  my($rboard)=$$rstate{'board'};
  for(my($i)=0;$i<=$#$rboard;$i++)
  {
    for(my($j)=0;$j<=$#{$$rboard[$i]{'digits'}};$j++)
    {
      print $$rboard[$i]{'digits'}[$j];
    }
    print " $$rboard[$i]{match}/$$rboard[$i]{unknown}";
    print "\n";
  }
}

sub process_checks
{
  my($state,$rchecks)=@_;
  
  while($#$rchecks >= 0)
  {
    my($check)=shift(@$rchecks);
    if($$check[0] eq 'line')
    {
      return 1 if(check_line($state,$rchecks,$$check[1]));
    }
    elsif($$check[0] eq 'col')
    {
      return 1 if(check_col($state,$rchecks,$$check[1]));
    }
  }
  return 0;
}

sub check_line
{
  my($rstate,$rtasks,$line_idx)=@_;
  my($rboard)=$$rstate{"board"};
  my($line)=$$rboard[$line_idx];
  my($contradiction)=0;
  if($$rboard[$line_idx]{'unknown'} > 0)
  {
    my($eliminate)=($$line{'match'} == 0); 
    my($validate)=($$line{'match'} == $$line{'unknown'});
    if($eliminate || $validate)
    {
      for(my($n)=0;$n<=$#{$$rboard[$line_idx]{'digits'}};$n++)
      {
        my($digit)=$$rboard[$line_idx]{'digits'}[$n];
        if( $digit ne '.' )
        {
          if($eliminate)
          {
            eliminate($rstate,$line_idx,$n,$digit);
          }
          else
          {
            validate($rstate,$line_idx,$n,$digit);
          }

          if( candidate_contradiction($rstate,$n) )
          {
            $contradiction = 1;
            last;
          }
          push(@$rtasks,['col',$n]);
        }
      }
    }
  }
  return $contradiction;
}

sub check_col
{
  my($rstate,$rtasks,$col_idx)=@_;
  my($rboard)=$$rstate{"board"};
  my($rcands)=$$rstate{'candidates'}[$col_idx];
  
  my(@ks)=(keys(%$rcands));
  my($sol)='.';
  if( $#ks == 0 )
  {
    $sol = $ks[0];
    $$rstate{'solution'}[$col_idx] = $sol;
  }
  
  my($contradiction)=0;
  for(my($i)=0;$i<=$#$rboard;$i++)
  {
    my($digit)=$$rboard[$i]{'digits'}[$col_idx];
    if($digit ne '.' )
    {
      if( $digit eq $sol )
      {
        validate($rstate,$i,$col_idx,$digit);
        if( line_contradiction($rstate,$i) )
        {
          $contradiction = 1;
          last;
        }
        push(@$rtasks,['line',$i]);
      }
      elsif( !exists($$rcands{$digit} ))
      {
        eliminate($rstate,$i,$col_idx,$digit);
        if( line_contradiction($rstate,$i) )
        {
          $contradiction = 1;
          last;
        }
        push(@$rtasks,['line',$i]);
      }
    }
  }
  return $contradiction;
}

sub eliminate
{
  my($rstate,$li,$co,$digit)=@_;
  my($rboard)=$$rstate{"board"};
  delete $$rstate{'candidates'}[$co]{$digit};
  $$rboard[$li]{'digits'}[$co] = '.';
  $$rboard[$li]{'unknown'} --;
}

sub validate
{
  my($rstate,$li,$co,$digit)=@_;
  my($rboard)=$$rstate{"board"};
  remove_candidates($rstate,$co,$digit);
  $$rboard[$li]{'digits'}[$co] = '.';
  $$rboard[$li]{'unknown'} --;
  $$rboard[$li]{'match'} --;
}

sub candidate_contradiction
{
  my($rstate,$n)=@_;
  return keys(%{$$rstate{'candidates'}[$n]}) < 0;
}

sub line_contradiction
{
  my($rstate,$n)=@_;
  my($rboard)=$$rstate{"board"};
  my($line)=$$rboard[$n];
  return (($$line{'match'} < 0) || ($$line{'match'} > $$line{'unknown'})); 
}

sub place_digit
{
  my($rstate,$rtasks,$idx,$val)=@_;
  remove_candidates($rstate,$idx,$val);
  push(@$rtasks,["col",$idx]);
}

sub remove_candidates
{
  my($rstate,$idx,$val)=@_;
  foreach my $d (keys(%{$$rstate{'candidates'}[$idx]}))
  {
    delete $$rstate{'candidates'}[$idx]{$d} if($d != $val);
  }
}


sub build_initial_state
{
  my($rgrid)=@_;
  my(%state)=();
  my(@board)=();
  
  my($num_digits)=0;
  
  for( my($line)=0;$line <= $#$rgrid; $line ++)
  {
    my(@digits)=split('',$$rgrid[$line][0]);
    $num_digits = $#digits + 1 if( $num_digits == 0 );
    die "Uncoherent number of digits" if($num_digits != $#digits + 1);
    
    my(%hash)=(
      'digits' => \@digits,
      'match' => $$rgrid[$line][1],
      'unknown' => $num_digits
    );
    push(@board,\%hash);
  }
  $state{'board'} = \@board;
  
  my(@solution)=();
  for( my($i)=0; $i < $num_digits; $i++)
  {
    $solution[$i] = '.';
  }
  $state{'solution'} = \@solution;
  
  my(@candidates)=();
  for( my($i)=0; $i < $num_digits; $i++)
  {
    my(%cands)=();
    for( my($j)=0; $j < 10; $j++)
    {
      $cands{$j} = 1;
    }
    push(@candidates,\%cands);
  }
  $state{'candidates'} = \@candidates;
  
  $state{'size'} = $num_digits;
  
  return \%state;
}

sub copy_state
{
  my($rstate)=@_;
  
  my(%state)=();
  
  my(@board)=();
  my(@solution)=();
  my(@candidates)=();
  
  for( my($line)=0;$line <= $#{$$rstate{'board'}}; $line ++)
  {
    my(@digits)=(@{$$rstate{'board'}[$line]{'digits'}});
    my(%hash)=(
      'digits' => \@digits,
      'match' => $$rstate{'board'}[$line]{'match'},
      'unknown' => $$rstate{'board'}[$line]{'unknown'}
    );
    push(@board,\%hash);
  }
  $state{'board'} = \@board;
  
  @solution = (@{$$rstate{'solution'}});
  $state{'solution'} = \@solution;
  
  for( my($i)=0; $i < $$rstate{'size'}; $i++)
  {
    my(%cands)=(%{$$rstate{'candidates'}[$i]});
    push(@candidates,\%cands);
  }
  $state{'candidates'} = \@candidates;
  
  $state{'size'} = $$rstate{'size'};
  
  return \%state;
}