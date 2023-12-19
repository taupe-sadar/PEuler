#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;

# my($n)=11;
# my($n)=10000;
# my($n)=5678027;
my($n)=7208785;

if(1)
{
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
  
  # print Dumper \@crible;


  my(@column_shift)=(-2*$n+3,-$n+1,0,$n,2*$n+1);
  my($sum_primes)=0;
  for(my($i)=0;$i<=$#{$crible[2]};$i++)
  {
    if($crible[2][$i] == 0)
    {
      # print "$i : \n";<STDIN>;
      
      my(@adjacents)=get_adjacents_mod2($n);
      my(@neighbors) = find_adj2(\@crible,2,$i,\@adjacents);
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
        my(@other_adjacents)=get_adjacents_mod2($n + $neighbors[0][0] - 2);
        my(@other_neighbor) = find_adj2(\@crible,$neighbors[0][0],$neighbors[0][1],\@other_adjacents);
        
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
  print $sum_primes;
  exit(0);
}

sub crible_value
{
  my($line,$i)=@_;
  my($base)=$line * ($line-1)/2 + 1;
  
  # print "$line $i ->".($base +(1-$base%2) +  $i*2)."\n";
  
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


my(@first_primes)=(2,3,5,7,11,13);
my($prod)=1;
for(my($i)=0;$i<=$#first_primes;$i++)
{
  $prod*=$first_primes[$i];
}

my($rpattern)=build_pattern($n,$prod,\@first_primes);


# for( my($i)=0;$i<5;$i++)
# {
# print (join(" ",@{$$rpattern[$i]})."\n");
# }
# exit(0);

my(@adjacents)=([-1,-1],[-1,0],[-1,1],[1,-1],[1,0],[1,1]);
my(@cand_triplets)=();
my(%prime_links)=();
for(my($k)=0;$k<$prod;$k++)
{
  if($$rpattern[2][$k] == 0)
  {
    my(@adjs)=find_adj($rpattern,0,$k,$prod);
    if($#adjs == 1 )
    {
      add_triplet_cand(\@cand_triplets,\%prime_links,[[0,$k],[$adjs[0][0],$adjs[0][1]-$k],[$adjs[1][0],$adjs[1][1]-$k]]);
    }
    elsif( $#adjs > 1 )
    {
      die "Not supported";
    }
    
    foreach my $a (@adjs)
    {
      my(@next_adj)=find_adj($rpattern,$$a[0],$$a[1],$prod);
      foreach my $b (@next_adj)
      {
        if(!( $$b[0] == 0 && $$b[1] <= $k ))
        {
          add_triplet_cand(\@cand_triplets,\%prime_links,[[0,$k],[$$a[0],$$a[1]-$k],[$$b[0],$$b[1]-$k]]);
        }
      }
    }
  }
}
# print"******\n";
# my(%dec)=Prime::decompose(50012683);
# print Dumper \%dec;
# print"******\n";

my($base)=$n*($n-1)/2 + 1;
my($end)=$base + $n - 1;
my($end_last_row)=$base + 3*$n + 2;
my($p_limit)=floor(sqrt($end_last_row));
Prime::init_crible($p_limit+1000);
my(@primes)=(Prime::next_prime());
while($primes[-1] <= $p_limit )
{
  push(@primes,Prime::next_prime());
}
my(@precision)=(-2*$n+3,-$n+1,0,$n,2*$n+1);

my($result)=0;
for(my($offset)=0;$offset < ($end-$base);$offset += $prod)
{
  my($ii)=0;
  my(%triplet_cache)=();
  my($last_cand_prime)=0;
  foreach my $triplet (@cand_triplets)
  {
    my($cand)=$base + $$triplet[0][1] + $offset;
    last if $cand > $end;
    next if( exists($triplet_cache{$cand}));
    
    %triplet_cache = () if( $last_cand_prime < $cand-2);
    $last_cand_prime = $cand;
    
    my($test1)=1;
    my($neighbor1)=$cand + $precision[$$triplet[1][0]+2]+$$triplet[1][1];
    if(exists($triplet_cache{$neighbor1}))
    {
      next if($triplet_cache{$neighbor1}==0);
      $test1 = 0;
    }
    
    my($test2)=1;
    my($neighbor2)=$cand + $precision[$$triplet[2][0]+2]+$$triplet[2][1];
    if(exists($triplet_cache{$neighbor2}))
    {
      next if($triplet_cache{$neighbor2}==0);
      $test2 = 0;
    }
    
    my($is_prime)=1;
    for(my($pidx)=$#first_primes+1;$pidx<$#primes;$pidx++)
    {
      my($p)=$primes[$pidx];
      if($cand%$p == 0){$is_prime=0;$triplet_cache{$cand}=0;last;}
      if( $test1 && $neighbor1%$p == 0){$is_prime=0;$triplet_cache{$neighbor1}=0;last;}
      if( $test2 && $neighbor2%$p == 0){$is_prime=0;$triplet_cache{$neighbor2}=0;last;}
    }
    if($is_prime)
    {
      my($cand_start)=$base + $$triplet[0][1];
      my($nb)=floor(($end-$cand_start)/$prod);
      my($current)=($cand-$cand_start)/$prod;
      print (display_triplet($cand,$triplet)." ($ii/$#cand_triplets - $current/$nb)\n");
      # my($a,$b,$c)=check_triplet($cand,$triplet);
      # print "$a $b $c\n";
      # print Dumper $triplet;
      # <STDIN>;
      
      $triplet_cache{$cand}=1;
      $triplet_cache{$neighbor1}=1;
      $triplet_cache{$neighbor2}=1;
      $result+=$cand;
      
    }
    $ii++;
  }
}

print $result;


# print Dumper \%prime_links;
# print ($#cand_triplets+1);

sub display_triplet
{
  my($nb,$triplet)=@_;
  my($ngh1)=$nb + $precision[$$triplet[1][0]+2]+$$triplet[1][1];
  my($ngh2)=$nb + $precision[$$triplet[2][0]+2]+$$triplet[2][1];
  return "$nb $ngh1 $ngh2";
}

sub check_triplet
{
  my($nb,$triplet)=@_;
  my($ngh1)=$nb + $precision[$$triplet[1][0]+2]+$$triplet[1][1];
  my($ngh2)=$nb + $precision[$$triplet[2][0]+2]+$$triplet[2][1];
  return (Prime::is_prime($nb),Prime::is_prime($ngh1),Prime::is_prime($ngh2));
}




# print "$prod\n";

sub build_pattern
{
  my($line,$pattern_size,$rfirst_primes)=@_;
  my(@pattern)=();
  for(my($i)=-2;$i<=2;$i++)
  {
    my(@neighbor_pattern)=(0)x($pattern_size);
    my($base)=($line-1+$i)*($line+$i)/2 + 1;
    my($end)=$base + $line-1 +$i;
    for(my($j)=0;$j<=$#$rfirst_primes;$j++)
    {
      my($p)=$$rfirst_primes[$j];
      my($rem)=$base%$p;
      my($div_start)=($rem==0)?0:($p-$rem);
      # print "base=$base | $i , $p, $div_start";<STDIN>;
      for(my($mult)=$div_start;$mult<$pattern_size;$mult+=$p)
      {
        $neighbor_pattern[$mult]=1;
      }
    }
    push(@pattern,\@neighbor_pattern);
  }
  return \@pattern;
}

sub find_adj
{
  my($rpattern,$x,$y,$max)=@_;
  my(@result)=();
  foreach my $a (@adjacents)
  {
    my(@neighbor)=($x + $$a[0], $y + $$a[1]);
    next if($neighbor[0]<-2);
    next if($neighbor[0]>2);
    my(@test)=@neighbor;
    
    $test[1] += $max if($test[1]<0);
    $test[1] -= $max if($test[1]>=$max);
    
    if($$rpattern[$test[0]+2][$test[1]] == 0)
    {
      push(@result,\@neighbor);
    }
  }
  return (@result);
}

sub find_adj2
{
  my($crible,$x,$y,$radjs)=@_;
  my(@result)=();
  
  # print Dumper $radjs;
  
  foreach my $adj (@$radjs)
  {
    my($raw)=$$crible[$x + $$adj[0]];
    my($offset)=$y + $$adj[1];
  
    # print "--- $x $y $$adj[0] $$adj[1]\n";

    if(($offset >= 0) && ($offset <= $#$raw) && ($$raw[$offset] == 0))
    {
      # print "  -> Yes\n";
      push(@result,[$x + $$adj[0],$y + $$adj[1]]);
    }
  }
  return (@result);
}

sub add_triplet_cand
{
  my($list,$hash,$triplet)=@_;
  push(@$list,$triplet);
  foreach my $t (@$triplet)
  {
    my($key)="$$t[0]-$$t[1]";
    $$hash{$key} = [] if( !exists($$hash{$key}) );
    push(@{$$hash{$key}},$#$list);
  }
}
