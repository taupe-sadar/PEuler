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

my($board,$init_state)=build_initial_state(\@raw_grid);

my(@init_checks)=();
for(my($i)=0;$i<=$#{$$init_state{"matches"}};$i++)
{
  if($$init_state{"matches"}[$i]{"match"} == 0)
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
      my(%to_check)=();
      my($col,$digit)=($result[1],$result[2]);
      my($ret)= eliminate($loop_state,$col,$digit,\%to_check);
      if($ret < 0)
      {
        return -1;
      }
      
      my(@checks)=();
      foreach my $li (sort(keys(%to_check)))
      {
        if( $$board[$li][$col] == $digit)
        {
          push(@checks,['line',$li]);
        }
      }
      
      my($ret_check)=process_checks($loop_state,\@checks);
      
      if($ret_check < 0)
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
    
    my($ret_place)=place_digit($state,\@checks,@{$$rtries[$i]});
    if($ret_place < 0)
    {
      # print "$space($depth) Remove(fast) : ($$rtries[$i][0],$$rtries[$i][1])\n" if($depth <=0);
      return (-1,$$rtries[$i][0],$$rtries[$i][1]);
    }
    
    my($ret_checks)=process_checks($state,\@checks);
    if($ret_checks < 0)
    {
      print "$space($depth) Remove : ($$rtries[$i][0],$$rtries[$i][1])\n" if($depth <=0);
      return (-1,$$rtries[$i][0],$$rtries[$i][1]);
    }

    push(@{$$rtries[$i]},$ret_place + $ret_checks);
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
  my($rmatches)=$$rstate{'matches'};
  for(my($i)=0;$i<=$#$board;$i++)
  {
    for(my($j)=0;$j<=$#{$$board[$i]};$j++)
    {
      my($d)=$$board[$i][$j];
      if(exists($$rstate{'candidates'}[$j]{$d}))
      {
        print $d;
      }
      else
      {
        print ".";
      }
    }
    print " $$rmatches[$i]{match}/$$rmatches[$i]{unknown}";
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
  }
  return $all_modifs;
}

sub check_line
{
  my($rstate,$rtasks,$line_idx)=@_;
  my($rmatches)=$$rstate{"matches"};
  my($line)=$$rmatches[$line_idx];
  my($modifs)=0;
  my(%to_check)=();
  if($$rmatches[$line_idx]{'unknown'} > 0)
  {
    my($eliminate)=($$line{'match'} == 0); 
    my($validate)=($$line{'match'} == $$line{'unknown'});
    if($eliminate || $validate)
    {
      for(my($n)=0;$n<$num_digits;$n++)
      {
        my($digit)=$$board[$line_idx][$n];
        my($rcands)=$$rstate{"candidates"}[$n];
        my($is_valid)=exists($$rcands{$digit});
        if($is_valid)
        {
          if($eliminate)
          {
            $modifs += eliminate($rstate,$n,$digit,\%to_check);
          }
          else
          {
            $modifs += validate($rstate,$n,$digit,\%to_check);
          }
        }
      }
    }
  }
  
  foreach my $c (sort(keys(%to_check)))
  {
    if( line_contradiction($rstate,$c) )
    {
      $modifs = -1;
      last;
    }
    push(@$rtasks,['line',$c]);
  }
  return $modifs;
}

sub eliminate
{
  my($rstate,$co,$digit,$rtocheck)=@_;
  return remove_one_candidate($rstate,$co,$digit,$rtocheck);
}

sub validate
{
  my($rstate,$co,$digit,$rtocheck)=@_;
  return remove_candidates($rstate,$co,$digit,$rtocheck);
}

sub line_contradiction
{
  my($rstate,$n)=@_;
  
  my($line)=$$rstate{"matches"}[$n];
  return (($$line{'match'} < 0) || ($$line{'match'} > $$line{'unknown'})); 
}

sub place_digit
{
  my($rstate,$rtasks,$idx,$val)=@_;
  
  my(%to_checks)=();
  
  my($count)=validate($rstate,$idx,$val,\%to_checks);
  
  foreach my $c (sort(keys(%to_checks)))
  {
    if( line_contradiction($rstate,$c) )
    {
      return -1;
    }
    push(@$rtasks,['line',$c]);
  }

  return $count;
}

sub remove_candidates
{
  my($rstate,$idx,$val,$rtocheck)=@_;
  my($count)=0;
  foreach my $c (sort(keys(%{$$rstate{'candidates'}[$idx]})))
  {
    $count += remove_one_candidate($rstate,$idx,$c,$rtocheck) unless($c == $val);
  }
  return $count;
}

sub remove_one_candidate
{
  my($rstate,$co,$val,$rtocheck)=@_;
  my($rcands)=$$rstate{'candidates'}[$co];
  my(@cands)=(keys(%$rcands));
  
  if($#cands <= 0 || !exists($$rcands{$val}))
  {
    return 0;
  }
  
  my($sol)=-1;
  if($#cands == 1)
  {
    $sol = ($cands[0] == $val)?$cands[1]:$cands[0];
  }
  delete $$rcands{$val};
  my($rmatches)=$$rstate{'matches'};
  my($count)=0;
  for(my($li)=0;$li<=$#$rmatches;$li++)
  {
    if($$board[$li][$co] == $sol)
    {
      $$rmatches[$li]{'unknown'} --;
      $$rmatches[$li]{'match'} --;
      $$rtocheck{$li}=1;
      $count+=1000;
    }
    elsif($$board[$li][$co] == $val)
    {
      $$rmatches[$li]{'unknown'} --;
      $$rtocheck{$li}=1;
      $count++;
    }
  }
  return $count;
}

sub build_initial_state
{
  my($rgrid)=@_;
  my(%state)=();
  my(@matches)=();
  
  my(@board)=();
  
  for(my($line)=0;$line <= $#$rgrid; $line ++)
  {
    my(@digits)=split('',$$rgrid[$line][0]);
    $num_digits = $#digits + 1 if( $num_digits == 0 );
    die "Uncoherent number of digits" if($num_digits != $#digits + 1);
    
    push(@board,\@digits);
    
    my(%hash)=(
      'match' => $$rgrid[$line][1],
      'unknown' => $num_digits
    );
    push(@matches,\%hash);
  }
  $state{'matches'} = \@matches;
  
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
  
  return (\@board,\%state);
}

sub copy_state
{
  my($rstate)=@_;
  
  my(%state)=();
  
  my(@matches)=();
  my(@candidates)=();
  
  for( my($line)=0;$line <= $#{$$rstate{'matches'}}; $line ++)
  {
    my(%hash)=(
      'match' => $$rstate{'matches'}[$line]{'match'},
      'unknown' => $$rstate{'matches'}[$line]{'unknown'}
    );
    push(@matches,\%hash);
  }
  $state{'matches'} = \@matches;
  
  for( my($i)=0; $i < $num_digits; $i++)
  {
    my(%cands)=(%{$$rstate{'candidates'}[$i]});
    push(@candidates,\%cands);
  }
  $state{'candidates'} = \@candidates;
  
  return \%state;
}