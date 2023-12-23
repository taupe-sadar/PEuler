#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;

# make a crible into the lines (n-2,n-1,n,n+1,n+2) = (n+i), with i in [-2,2]
# Each line start with (n + i) * (n + i - 1)/2 + 1, and has n+i elements
# For each p prime, we set '1' for each multiple of p in the crible 
# Then we look for primes triplet, which still are set to '0'

# For optimisations, crible may be implemented with odd integers


print (calc_sum_triplet(5678027) + calc_sum_triplet(7208785));

sub calc_sum_triplet
{
  my($n)=@_;
  my(@crible)=();
  for(my($i)=-2;$i<=2;$i++)
  {
    my($full_size)=($n+$i);
    my($half_size)=0;
    if($full_size%2 == 0)
    {
      $half_size = $full_size/2;
    }
    elsif($full_size%4 == 1)
    {
      $half_size = ($full_size+1)/2;
    }
    else
    {
      $half_size = ($full_size-1)/2;
    }
    
    my(@a)=(0)x($half_size);
    push(@crible,\@a);
  }
  
  my($base)=$n*($n-1)/2 + 1;
  my($end)=$base + $n - 1;
  my($end_last_row)=$base + 3*$n + 2;
  my($p_limit)=floor(sqrt($end_last_row));
  Prime::init_crible($p_limit+1000);
  
  Prime::next_prime();#Skipping 2
  for(my($p)=Prime::next_prime();$p<$p_limit;$p=Prime::next_prime())
  {
    for(my($i)=-2;$i<=2;$i++)
    {
      my($base_line)=($n+$i)*($n+$i-1)/2 + 1;
      
      my($first_multiple)=$base_line + 2*$p - 1 - ( $base_line + $p - 1 )%(2*$p);
      my($first_offset)=crible_idx($n+$i,$first_multiple);
      
      for(my($val)=$first_offset;$val<=$#{$crible[$i+2]};$val+=$p)
      {
        $crible[$i+2][$val]=1;
      }
      
    }
  }

  my(@column_shift)=(-2*$n+3,-$n+1,0,$n,2*$n+1);
  my($sum_primes)=0;
  
  my(@adjacents)=();
  for(my($i)=-2;$i<=2;$i++)
  {
    my(@line_adjacents)=get_adjacents_mod2($n+$i);
    push(@adjacents,\@line_adjacents);
  }
  
  for(my($i)=0;$i<=$#{$crible[2]};$i++)
  {
    if($crible[2][$i] == 0)
    {
      my(@neighbors) = find_adjacents(\@crible,2,$i,$adjacents[2]);
      if($#neighbors >= 1 )
      {
        $sum_primes += crible_value($n,$i);
        # my(@triplet)=(
              # crible_value($n,$i),
              # crible_value($n + $neighbors[0][0] - 2,$neighbors[0][1]),
              # crible_value($n + $neighbors[1][0] - 2,$neighbors[1][1]),
              # );
        # print join(" ",@triplet)."\n";
      }
      elsif($#neighbors == 0 )
      {
        my(@other_neighbor) = find_adjacents(\@crible,$neighbors[0][0],$neighbors[0][1],$adjacents[$neighbors[0][0]]);
        
        for(my($k)=0;$k<=$#other_neighbor;$k++)
        {
          unless( $other_neighbor[$k][0] == 2 && $other_neighbor[$k][1] == $i )
          {
            $sum_primes += crible_value($n,$i);
            
            # my(@triplet)=(
              # crible_value($n,$i), 
              # crible_value($n + $neighbors[0][0] -2,$neighbors[0][1]),
              # crible_value($n + $other_neighbor[$k][0] -2,$other_neighbor[$k][1])
              # );
            # print join(" ",@triplet)."\n";
            last;
          }
        }
      }
    }
  }
  return $sum_primes;
}

sub crible_value
{
  my($line,$i)=@_;
  my($base)=$line * ($line-1)/2 + 1;
  
  return $base +(1-$base%2) +  $i*2;
}

sub crible_idx
{
  my($line,$val)=@_;
  die "invalid val $val in crible_idx" if($val%2 == 0);
  my($base)=$line * ($line-1)/2 + 1;
  return ($val - ($base +(1-$base%2)))/2;
}

sub get_adjacents_mod2
{
  my($line)=@_;
  my($mod)=$line%4;
  if( $mod == 0 )
  {
    return ([-1,-1],[-1,0],[1,0]);
  }
  elsif($mod == 1)
  {
    return ([-1,0],[1,-1],[1,0]);
  }
  elsif($mod == 2)
  {
    return ([-1,0],[-1,1],[1,0]);
  }
  else
  {
    return ([-1,0],[1,0],[1,1]);
  }
}

sub find_adjacents
{
  my($crible,$x,$y,$radjs)=@_;
  my(@result)=();
  
  foreach my $adj (@$radjs)
  {
    my($raw)=$$crible[$x + $$adj[0]];
    my($offset)=$y + $$adj[1];
  
    if(($offset >= 0) && ($offset <= $#$raw) && ($$raw[$offset] == 0))
    {
      push(@result,[$x + $$adj[0],$y + $$adj[1]]);
    }
  }
  return (@result);
}
