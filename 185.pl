use strict;
use warnings;
use Data::Dumper;

# Backtracking algorithm :
# A state consists in :
# - on each column, possible digits (candidates). If only one candidate, then its part of the solution
# - on each row, the number of digits that remain unknown : part of solution or not ? (unknown)
# - on each row, the number of digits among the unknow that should be part of the solution (match)
#
# Rules applies, on each row : 
#  - if there is no more match number, all remaining digits are invalid candidates in their column
#  - if if the unknown digits equals to the match number, all remaining digits are solutions, and in their column, 
#    all other digits areinvalid candidates
#  - if somehow there are more match digits than the remaining unknown, or the match digits is negative the current 
#    state is in contradiction
#
# The backtracking algorithm consists in several candidate tries. A try consist in a digit on a column. 
# We asssuming a candidate as valid. 
# - If this lead to a contradiction, one can remove for sure this candidate in the current state.
# - If no contradiction can be found. We make another assumption, making it recursive.
# - If there are no more tries left, and still no contradiction, then we found a solution.
# 
# We choose the candidate with a cost function, the highest its assumption generates modifications, 
# the earliest it will be chosen. For optimization reason, this cost is calculate only at the begining. 
# 
# Note : Once a solution found, we keep looking for eventual others, trying all candidates that are not
# in the solution
#

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

use constant MATCH => 0;
use constant UNKNOWN => 1;
use constant CANDIDATES => 2;

my($board,$init_state)=build_initial_state(\@raw_grid);

my(%init_checks)=();
for(my($i)=0;$i<=$#{$$init_state[MATCH]};$i++)
{
  if($$init_state[MATCH][$i] == 0)
  {
    $init_checks{$i}=1;
  }    
}
process_checks($init_state,\%init_checks);

my(@global_costs)=();
for(my($i)=0;$i<$num_digits;$i++)
{
  my(@costs)=(0)x10;
  push(@global_costs,\@costs);
}
update_costs($init_state,\@global_costs);
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
      my(%checks)=();
      my($col,$digit)=($result[1],$result[2]);
      if(eliminate($loop_state,$col,$digit,\%checks) == -1)
      {
        return -1;
      }
            
      my($ret_check)=process_checks($loop_state,\%checks);
      
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
          my(@k)=(keys(%{$$loop_state[CANDIDATES][$i]}));
          push(@presume_sol,$k[0]);
        }
        update_costs($init_state,\@global_costs);
      }
      
      my($solution)=join('',@presume_sol);
      # print "Solution : $solution ($depth)\n";
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
  
  my($acost)=$global_costs[$$a[0]][$$a[1]];
  my($bcost)=$global_costs[$$b[0]][$$b[1]];
  return $bcost <=> $acost || $$a[0] <=> $$b[0] || $$a[1] <=> $$b[1];
  
}

sub backtrack_tries
{
  my($base_state,$depth)=@_;

  my($rtries)=list_tries($base_state);
  
  return 0 if($#$rtries < 0);

  my($space)='  'x$depth;
  # print "$space($depth) Numtries : ".($#$rtries+1)."\n" if($depth <=0);
  
  for(my($i)=0;$i<=$#$rtries;$i++)
  {
    my($rcands)=$$base_state[CANDIDATES][$$rtries[$i][0]];
    next if(!exists($$rcands{$$rtries[$i][1]}) || keys %$rcands <= 1);
    
    # print "$space($depth) Retry : ($$rtries[$i][0],$$rtries[$i][1])\n" if($depth <=0);
    my($backtrack_state)=copy_state($base_state);
    my($ret_simple)=simple_try($backtrack_state,$$rtries[$i][0],$$rtries[$i][1]);
    if($ret_simple < 0)
    {
      # print "$space($depth) Remove : ($$rtries[0][0],$$rtries[0][1])\n" if($depth <=0);
      return (-1,$$rtries[$i][0],$$rtries[$i][1]);
    }
    
    my($ret_backtrack)=backtrack($backtrack_state,$depth+1);
    if($ret_backtrack < 0)
    {
      # print "$space($depth) FinallyRemove : ($$rtries[$i][0],$$rtries[$i][1])\n" if($depth <=0);
      return (-1,$$rtries[$i][0],$$rtries[$i][1]);
    }
  }
  return 1;
}

sub list_tries
{
  my($rstate)=@_;
  my(@t)=();
  for(my($i)=0;$i<$num_digits;$i++)
  {
    my(@cand_keys)=(sort(keys(%{$$rstate[CANDIDATES][$i]})));
    next if($#cand_keys <= 0);
    for my $cand (@cand_keys)
    {
      push(@t,[$i,$cand]);
    }
  }
  @t = sort(pref_fn @t);
  return \@t;
}

sub update_costs
{
  my($rstate,$rcosts)=@_;
  my($rtries)=list_tries($rstate);
  
  for(my($i)=0;$i<=$#$rtries;$i++)
  {
    my($tried_state)=copy_state($rstate);
    my($count) = simple_try($tried_state,@{$$rtries[$i]});
    if($count != -1)
    {
      $$rcosts[$$rtries[$i][0]][$$rtries[$i][1]] = $count;
    }
  }
}

sub simple_try
{
  my($state,$co,$digit)=@_;
  my(%checks)=();
  
  my($ret_place)=validate($state,$co,$digit,\%checks);
  if($ret_place == -1)
  {
    return -1;
  }

  my($ret_checks)=process_checks($state,\%checks);
  if($ret_checks < 0)
  {
    return -1;
  }
  return $ret_place + $ret_checks;
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
    my(@ks)=sort(keys(%{$$rstate[CANDIDATES][$j]}));
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
  for(my($i)=0;$i<=$#$board;$i++)
  {
    for(my($j)=0;$j<=$#{$$board[$i]};$j++)
    {
      my($d)=$$board[$i][$j];
      if(exists($$rstate[CANDIDATES][$j]{$d}))
      {
        print $d;
      }
      else
      {
        print ".";
      }
    }
    print " $$rstate[MATCH][$i]/$$rstate[UNKNOWN][$i]";
    print "\n";
  }
}

sub process_checks
{
  my($state,$rchecks)=@_;
  
  my($all_modifs)=0;
  while(1)
  {
    my(@lines_to_check)=(sort(keys(%$rchecks)));
    last if($#lines_to_check < 0);
    while($#lines_to_check >= 0)
    {
      my($check)=shift(@lines_to_check);
      delete $$rchecks{$check};
      my($modifs)=check_line($state,$rchecks,$check);
      return -1 if($modifs < 0);
      $all_modifs += $modifs;
    }
  }
  return $all_modifs;
}

sub check_line
{
  my($rstate,$rtasks,$line_idx)=@_;
  my($rmatch)=$$rstate[MATCH][$line_idx];
  my($runknown)=$$rstate[UNKNOWN][$line_idx];
  my($modifs)=0;
  if($runknown > 0)
  {
    my($eliminate)=($rmatch == 0); 
    my($validate)=($rmatch== $runknown);
    if($eliminate || $validate)
    {
      for(my($n)=0;$n<$num_digits;$n++)
      {
        my($digit)=$$board[$line_idx][$n];
        my($rcands)=$$rstate[CANDIDATES][$n];
        my($is_valid)=exists($$rcands{$digit});
        if($is_valid)
        {
          my($num)=0;
          if($eliminate)
          {
            $num = eliminate($rstate,$n,$digit,$rtasks);
          }
          else
          {
            $num = validate($rstate,$n,$digit,$rtasks);
          }
          return -1 if($num == -1);
          $modifs += $num;
        }
      }
    }
  }
  
  return $modifs;
}

sub line_contradiction
{
  my($rstate,$n)=@_;
  return (($$rstate[MATCH][$n] < 0) || ($$rstate[MATCH][$n] > $$rstate[UNKNOWN][$n])); 
}

sub validate
{
  my($rstate,$idx,$val,$rtocheck)=@_;
  my($count)=0;
  foreach my $c (sort(keys(%{$$rstate[CANDIDATES][$idx]})))
  {
    unless($c == $val)
    {
      my($num)=eliminate($rstate,$idx,$c,$rtocheck);
      return -1 if($num==-1);
      $count += $num;
    }
  }
  return $count;
}

sub eliminate
{
  my($rstate,$co,$val,$rtocheck)=@_;
  my($rcands)=$$rstate[CANDIDATES][$co];
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
  my($rmatch)=$$rstate[MATCH];
  my($runknown)=$$rstate[UNKNOWN];
  my($count)=0;
  for(my($li)=0;$li<=$#$rmatch;$li++)
  {
    if($$board[$li][$co] == $sol)
    {
      $$runknown[$li]--;
      $$rmatch[$li]--;
      
      return -1 if(line_contradiction($rstate,$li));

      $$rtocheck{$li}=1;
      $count+=1000;
    }
    elsif($$board[$li][$co] == $val)
    {
      $$runknown[$li]--;

      return -1 if(line_contradiction($rstate,$li));

      $$rtocheck{$li}=1;
      $count++;
    }
  }
  return $count;
}

sub build_initial_state
{
  my($rgrid)=@_;
  my(@state)=();

  my(@match)=();
  my(@unknown)=();
  my(@candidates)=();
  
  my(@board)=();
  
  for(my($line)=0;$line <= $#$rgrid; $line ++)
  {
    my(@digits)=split('',$$rgrid[$line][0]);
    $num_digits = $#digits + 1 if( $num_digits == 0 );
    die "Uncoherent number of digits" if($num_digits != $#digits + 1);
    
    push(@board,\@digits);
    
    push(@match,$$rgrid[$line][1]);
    push(@unknown,$num_digits);
  }
  
  for( my($i)=0; $i < $num_digits; $i++)
  {
    my(%cands)=();
    for( my($j)=0; $j < 10; $j++)
    {
      $cands{$j} = 1;
    }
    push(@candidates,\%cands);
  }
  push(@state,\@match,\@unknown,\@candidates);
  
  return (\@board,\@state);
}

sub copy_state
{
  my($rstate)=@_;
  
  my(@state)=();
  
  my(@match)=();
  my(@unknown)=();
  my(@candidates)=();
  
  for( my($line)=0;$line <= $#{$$rstate[MATCH]}; $line ++)
  {
    push(@match,$$rstate[MATCH][$line]);
    push(@unknown,$$rstate[UNKNOWN][$line]);
  }
  
  for( my($i)=0; $i < $num_digits; $i++)
  {
    my(%cands)=(%{$$rstate[CANDIDATES][$i]});
    push(@candidates,\%cands);
  }
  push(@state,\@match,\@unknown,\@candidates);
  
  return \@state;
}