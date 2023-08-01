use strict;
use warnings;
use Data::Dumper;

# my(@raw_grid)=(
  # [90342,2],
  # [70794,0],
  # [39458,2],
  # [34109,1],
  # [51545,2],
  # [12531,1]
# );
my(@raw_grid)=(
  [5616185650518293,2],
  [3847439647293047,1],
  [5855462940810587,3],
  [9742855507068353,3],
  [4296849643607543,3],
  [3174248439465858,1],
  [4513559094146117,2],
  [7890971548908067,3],
  [8157356344118483,1],
  [2615250744386899,2],
  [8690095851526254,3],
  [6375711915077050,1],
  [6913859173121360,1],
  [6442889055042768,2],
  [2321386104303845,0],
  [2326509471271448,2],
  [5251583379644322,2],
  [1748270476758276,3],
  [4895722652190306,1],
  [3041631117224635,3],
  [1841236454324589,3],
  [2659862637316867,2]
);

my($num_digits)=0;

my(@presume_sol)=();

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

# print_state($init_state);
# <STDIN>;

my($result,$solution)=backtrack($init_state,0);
if($result == 0)
{
  print $solution;
}
elsif($result == 1)
{
  print "Several solutions in the Number mind\n";
}
elsif($result == -1)
{
  print "Contradiction in the Number mind\n";
}

sub backtrack
{
  my($base_state,$depth)=@_;

  my($loop_state)=copy_state($base_state);
  my($result)=0;
  my(@result)=backtrack_tries($loop_state,$depth);
  while(1)
  {
    if($result[0] == -1) #means contradiction found
    {
      my(@checks)=();
      remove_one_candidate($loop_state,$result[1],$result[2]);
      push(@checks,['col',$result[1]]);
      my($ret)=process_checks($loop_state,\@checks);
      
      if($ret < 0)
      {
        return -1;
      }
    }
    elsif($result[0] == 1) #means no contradiction found 
    {
      if($depth < 2)
      {
      # print "($depth) No contradiction found\n";
      # print_state($loop_state);
      # <STDIN>;
      }
      return 1;
    }
    else #0 : means grid solved, no tries to do
    {
      if($depth < 2)
      {
      # print "($depth) Grid solved, no tries\n";
      # print_state($loop_state);
      # <STDIN>;
      }
      
      if($#presume_sol < 0)
      {
        for(my($i)=0;$i<$num_digits;$i++)
        {
          my(@k)=(keys(%{$$loop_state{'candidates'}[$i]}));
          push(@presume_sol,$k[0]);
        }
      }
      
      my($solution)=join('',@presume_sol);
      print "Solution : $solution ($depth)\n";
      return (0,$solution);
    }
    @result=backtrack_tries($loop_state,$depth);
  }
}

sub pref_fn
{
  if($#presume_sol >= 0)
  {
    return 1 if($presume_sol[$$a[0]] == $$a[1]);
    return -1 if($presume_sol[$$b[0]] == $$b[1]);
  }
  
  # return $$b[0] <=> $$a[0] || $$a[1] <=> $$b[1];
  return $$b[2] <=> $$a[2] || $$a[0] <=> $$b[0] || $$a[1] <=> $$b[1];
  
}

sub backtrack_tries
{
  my($base_state,$depth)=@_;
  # print_state($base_state);

  my($rtries)=list_tries($base_state);
  
  my($space)='  'x$depth;
  print "$space($depth) Numtries : ".($#$rtries+1)."\n" if($depth <=0);
  
  return 0 if($#$rtries < 0);
  
  for(my($i)=0;$i<=$#$rtries;$i++)
  {
    my(@checks)=();
    my($state)=copy_state($base_state);
    my($count)=place_digit($state,\@checks,@{$$rtries[$i]});
    # print "$space($depth) Try : ($$rtries[$i][0],$$rtries[$i][1])\n" if($depth <=0);
    my($ret)=process_checks($state,\@checks);
    if($ret < 0)
    {
      # print "$space($depth) Remove : ($$rtries[$i][0],$$rtries[$i][1])\n" if($depth <=0);
      return (-1,$$rtries[$i][0],$$rtries[$i][1]);
    }
    
    push(@{$$rtries[$i]},$ret + $count);
    push(@{$$rtries[$i]},$state);
  }
  @$rtries = sort(pref_fn @$rtries);
  
  for(my($i)=0;$i<=$#$rtries;$i++)
  {
    print "$space($depth) Retry : ($$rtries[$i][0],$$rtries[$i][1])\n" if($depth <=0);
    my($ret)=backtrack($$rtries[$i][3],$depth+1);
    if($ret < 0)
    {
      # print "$space($depth) FinallyRemove : ($$rtries[$i][0],$$rtries[$i][1])\n" if($depth <=0);
      return (-1,$$rtries[$i][0],$$rtries[$i][1]);
    }
  }
  return 1;
}

sub list_tries
{
  my($state)=@_;
  my(@t)=();
  for(my($i)=0;$i<$num_digits;$i++)
  {
    my(@cand_keys)=(sort(keys(%{$$state{'candidates'}[$i]})));
    next if($#cand_keys <= 0);
    for my $cand (@cand_keys)
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
  my(@list)=();
  my($max)=0;
  for(my($j)=0;$j<$num_digits;$j++)
  {
    my(@ks)=sort(keys(%{$$rstate{'candidates'}[$j]}));
    push(@list,\@ks);
    $max = $#ks+1 if( $#ks + 1 > $max );
  }
  for(my($i)=0;$i<$max;$i++)
  {
    for(my($j)=0;$j<$num_digits;$j++)
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
  
  my($all_modifs)=0;
  while($#$rchecks >= 0)
  {
    my($check)=shift(@$rchecks);
    if($$check[0] eq 'line')
    {
      my($modifs)=check_line($state,$rchecks,$$check[1]);
      return -1 if($modifs < 0);
      $all_modifs += $modifs;
    }
    elsif($$check[0] eq 'col')
    {
      my($modifs)=check_col($state,$rchecks,$$check[1]);
      return -1 if($modifs < 0);
      $all_modifs += $modifs;
    }
  }
  return $all_modifs;
}

sub check_line
{
  my($rstate,$rtasks,$line_idx)=@_;
  my($rboard)=$$rstate{"board"};
  my($line)=$$rboard[$line_idx];
  my($modifs)=0;
  if($$rboard[$line_idx]{'unknown'} > 0)
  {
    my($eliminate)=($$line{'match'} == 0); 
    my($validate)=($$line{'match'} == $$line{'unknown'});
    if($eliminate || $validate)
    {
      for(my($n)=0;$n<=$#{$$rboard[$line_idx]{'digits'}};$n++)
      {
        my($digit)=$$rboard[$line_idx]{'digits'}[$n];
        if( $digit != -1 )
        {
          if($eliminate)
          {
            $modifs += eliminate($rstate,$line_idx,$n,$digit);
          }
          else
          {
            $modifs += validate($rstate,$line_idx,$n,$digit);
          }
          
          if( candidate_contradiction($rstate,$n) )
          {
            $modifs = -1;
            last;
          }
          push(@$rtasks,['col',$n]);
        }
      }
    }
  }
  return $modifs;
}

sub check_col
{
  my($rstate,$rtasks,$col_idx)=@_;
  my($rboard)=$$rstate{"board"};
  my($rcands)=$$rstate{'candidates'}[$col_idx];
  
  my(@ks)=(keys(%$rcands));
  my($sol)=-1;
  if( $#ks == 0 )
  {
    $sol = $ks[0];
  }
  
  my($modifs)=0;
  for(my($i)=0;$i<=$#$rboard;$i++)
  {
    my($digit)=$$rboard[$i]{'digits'}[$col_idx];
    if($digit != -1 )
    {
      if( $digit eq $sol )
      {
        $modifs += validate($rstate,$i,$col_idx,$digit);
        
        if( line_contradiction($rstate,$i) )
        {
          $modifs = -1;
          last;
        }

        push(@$rtasks,['line',$i]);
      }
      elsif( !exists($$rcands{$digit} ))
      {
        $modifs += eliminate($rstate,$i,$col_idx,$digit);
        if( line_contradiction($rstate,$i) )
        {
          $modifs = -1;
          last;
        }
        push(@$rtasks,['line',$i]);
      }
    }
  }
  return $modifs;
}

sub eliminate
{
  my($rstate,$li,$co,$digit)=@_;
  my($rboard)=$$rstate{"board"};
  my($count)=remove_one_candidate($rstate,$co,$digit);
  $$rboard[$li]{'digits'}[$co] = -1;
  $$rboard[$li]{'unknown'} --;
  return $count;
}

sub validate
{
  my($rstate,$li,$co,$digit)=@_;
  my($rboard)=$$rstate{"board"};
  my($count)=remove_candidates($rstate,$co,$digit);
  $$rboard[$li]{'digits'}[$co] = -1;
  $$rboard[$li]{'unknown'} --;
  $$rboard[$li]{'match'} --;
  return $count;
}

sub candidate_contradiction
{
  my($rstate,$n)=@_;
  my(@ks)=keys(%{$$rstate{'candidates'}[$n]});
  return ($#ks < 0);
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
  my($count)=remove_candidates($rstate,$idx,$val);
  push(@$rtasks,["col",$idx]);
  return 1000 + $count;
}

sub remove_candidates
{
  my($rstate,$idx,$val)=@_;
  my($count)=0;
  my(@keys)=(keys(%{$$rstate{'candidates'}[$idx]}));
  if(exists($$rstate{'candidates'}[$idx]{$val}))
  {
    $$rstate{'candidates'}[$idx]={$val=>1};
    return $#keys;
  }
  else
  {
    $$rstate{'candidates'}[$idx]={};
    return $#keys+1;
  }
}

sub remove_one_candidate
{
  my($rstate,$idx,$val)=@_;
  if(exists($$rstate{'candidates'}[$idx]{$val}))
  {
    delete $$rstate{'candidates'}[$idx]{$val};
    return 1;
  }
  return 0;
}

sub build_initial_state
{
  my($rgrid)=@_;
  my(%state)=();
  my(@board)=();
  
  for(my($line)=0;$line <= $#$rgrid; $line ++)
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
  
  return \%state;
}

sub copy_state
{
  my($rstate)=@_;
  
  my(%state)=();
  
  my(@board)=();
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
  
  for( my($i)=0; $i < $num_digits; $i++)
  {
    my(%cands)=(%{$$rstate{'candidates'}[$i]});
    push(@candidates,\%cands);
  }
  $state{'candidates'} = \@candidates;
  
  return \%state;
}