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

my(@checks)=();
for(my($i)=0;$i<=$#{$init_state["board"]};$i++)
{
  if($$init_state["board"][$i]{"match"} == 0)
  {
    push(@checks,["line",$i]);
  }    
}
process_checks($init_state,\@checks);


my($state)=copy_state($init_state);


my($error)=obvious_solve($state);
# print_state($state);

place_digit($state,0,9);

$error=obvious_solve($state);

print_state($state);


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

sub obvious_solve
{
  my($rstate)=@_;
  
  my($has_changed)=1;
  my($contradiction)=0;
  while( $has_changed && !$contradiction)
  {
    $has_changed = 0;
    my($rboard)=$$rstate{'board'};
    for(my($i)=0;$i<=$#$rboard;$i++)
    {
      if($$rboard[$i]{'unknown'} > 0)
      {
        if($$rboard[$i]{'match'} == 0)
        {
          $has_changed = 1;
          for(my($n)=0;$n<=$#{$$rboard[$i]{'digits'}};$n++)
          {
            my($digit)=$$rboard[$i]{'digits'}[$n];
            if( $digit ne '.' )
            {
              delete $$rstate{'candidates'}[$n]{$digit};
              $$rboard[$i]{'digits'}[$n] = '.';
              $$rboard[$i]{'unknown'} --;
            }
          }
          
        }
        elsif($$rboard[$i]{'match'} == $$rboard[$i]{'unknown'})
        {
          $has_changed = 1;
          for(my($n)=0;$n<=$#{$$rboard[$i]{'digits'}};$n++)
          {
            my($digit)=$$rboard[$i]{'digits'}[$n];
            if( $digit ne '.' )
            {
              if( exists($$rstate{'candidates'}[$n]{$digit}))
              {
                $$rstate{'candidates'}[$n] = {};
                $$rstate{'solution'}[$n] = $digit;
          
                $$rboard[$i]{'digits'}[$n] = '.';
                $$rboard[$i]{'unknown'} --;
                $$rboard[$i]{'match'} --;
              }
              else
              {
                $contradiction = 1;
                last;
              }
            }
          }
        }
      }
      last if($contradiction);
    }
    last if($contradiction);

    # print_state($rstate); <STDIN>;
    
    for(my($j)=0;$j<$$rstate{'size'};$j++)
    {
      my($sol)=$$rstate{'solution'}[$j];
      if( $sol ne '.' )
      {
        for(my($i)=0;$i<=$#$rboard;$i++)
        {
          if($$rboard[$i]{'unknown'} > 0 && $$rboard[$i]{'digits'}[$j] eq $sol)
          {
            $$rboard[$i]{'digits'}[$j] = '.';
            $$rboard[$i]{'unknown'} --;
            $$rboard[$i]{'match'} --;
          }
        }
      }
      else
      {
        my($rcands)=$$rstate{'candidates'}[$j];
        
        my(@ks)=(keys(%$rcands));
        if( $#ks < 0 )
        {
          $contradiction = 1;
          last;
        }
        else
        {
          my($sol)='.';
          $sol = $ks[0] if( $#ks == 0 );
          
          for(my($i)=0;$i<=$#$rboard;$i++)
          {
            my($digit)=$$rboard[$i]{'digits'}[$j];
            if($digit ne '.' )
            {
              if( $digit eq $sol )
              {
                $has_changed = 1;
                $$rboard[$i]{'digits'}[$j] = '.';
                $$rboard[$i]{'unknown'} --;
                $$rboard[$i]{'match'} --;
              }
              elsif( !exists($$rcands{$digit} ))
              {
                $has_changed = 1;
                $$rboard[$i]{'digits'}[$j] = '.';
                $$rboard[$i]{'unknown'} --;
              }
            }
          }
        }
      }
    }
    # print_state($rstate); <STDIN>;
  }
  return $contradiction;
}

sub process_checks
{
  my($state,$rchecks)=@_;
  
  while($#$rchecks >= 0)
  {
    my($check)=shift(@$rchecks);
    if($$check[0] eq 'line')
    {
      return 1 if(check_line($$state,$rchecks,$$check[1]));
    }
    elsif($$check[0] eq 'col')
    {
      return 1 if(check_col($$state,$rchecks,$$check[1]));
    }
  }
}

sub check_line
{
  my($state,$rtasks,$line_idx)=@_;
  my($rboard)=$$state["board"];
  my($line)=$$rboard[$line_idx];
  my($contradiction)=0;
  if($$rboard[$i]{'unknown'} > 0)
  {
    my($eliminate)=($$line{'match'} == 0); 
    my($validate)=($$line{'match'} == $$line{'unknown'});
    if($eliminate || $validate)
    {
      for(my($n)=0;$n<=$#{$$rboard[$i]{'digits'}};$n++)
      {
        my($digit)=$$rboard[$i]{'digits'}[$n];
        if( $digit ne '.' )
        {
          if($eliminate)
          {
            eliminate($state,$i,$n,$digit);
          }
          else
          {
            validate($state,$i,$n,$digit);
          }

          if( candidate_contradiction($$rstate,$n) )
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
  my($state,$rtasks,$col_idx)=@_;
  my($rboard)=$$state["board"];
  my($line)=$$rboard[$line_idx];
  my($contradiction)=0;
  if($$rboard[$i]{'unknown'} > 0)
  {
    my($eliminate)=($$line{'match'} == 0); 
    my($validate)=($$line{'match'} == $$line{'unknown'});
    if($eliminate || $validate)
    {
      for(my($n)=0;$n<=$#{$$rboard[$i]{'digits'}};$n++)
      {
        my($digit)=$$rboard[$i]{'digits'}[$n];
        if( $digit ne '.' )
        {
          if($eliminate)
          {
            eliminate($state,$i,$n,$digit);
          }
          else
          {
            validate($state,$i,$n,$digit);
          }

          if( candidate_contradiction($$rstate,$n) )
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

sub eliminate
{
  my($state,$li,$co,$digit)=@_;
  my($rboard)=$$state["board"];
  delete $$rstate{'candidates'}[$co]{$digit};
  $$rboard[$li]{'digits'}[$co] = '.';
  $$rboard[$li]{'unknown'} --;
}

sub validate
{
  my($state,$li,$co,$digit)=@_;
  my($rboard)=$$state["board"];
  foreach my $d (keys(%{$$rstate{'candidates'}[$co]}))
  {
    delete $$rstate{'candidates'}[$co]{$d} if($d != $digit);
  }
  $$rboard[$i]{'digits'}[$n] = '.';
  $$rboard[$i]{'unknown'} --;
  $$rboard[$i]{'match'} --;
}

sub candidate_contradiction
{
  my($rstate,$n)=@_;
  my($rboard)=$$state["board"];
  return keys(%{$$rstate{'candidates'}[$n]}) < 0;
}

sub place_digit
{
  my($rstate,$idx,$val)=@_;
  for(my($i)=0;$i<=$#{$$rstate{'board'}};$i++)
  {
    my($nb)=$$rstate{'board'}[$i]{'digits'}[$idx];
    if( $nb ne '.' )
    {
      if( $nb eq $val )
      {
        $$rstate{'board'}[$i]{'match'}--;
      }

      $$rstate{'board'}[$i]{'unknown'}--;
      $$rstate{'board'}[$i]{'digits'}[$idx] = '.';
    }
  }
  $$rstate{'solution'}[$idx]=$val;
  $$rstate{'candidates'}[$idx]={};
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