#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;

my($n)=5678027;

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
        if(!( $$b[0] == 0 && $$b[1] == $k ))
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
my(%remember)=();
my($result)=0;
my($ii)=0;
foreach my $triplet (@cand_triplets)
{
  
  my($cand_start)=$base + $$triplet[0][1];
  for(my($cand)=$cand_start;$cand <= $end;$cand += $prod)
  {
    next if( exists($remember{$cand}));
    
    my($is_prime)=1;
    for(my($pidx)=$#first_primes+1;$pidx<$#primes;$pidx++)
    {
      my($p)=$primes[$pidx];
      if($cand%$p == 0){$is_prime=0;last;}
      my($neighbor_offset_1)=$precision[$$triplet[1][0]+2]+$$triplet[1][1];
      if( ($cand + $neighbor_offset_1)%$p == 0){$is_prime=0;last;}
      my($neighbor_offset_2)=$precision[$$triplet[2][0]+2]+$$triplet[2][1];
      if( ($cand + $neighbor_offset_2)%$p == 0){$is_prime=0;last;}
    }
    if($is_prime)
    {
      my($nb)=floor(($end-$cand_start)/$prod);
      my($current)=($cand-$cand_start)/$prod;
      print (display_triplet($cand,$triplet)." ($ii/$#cand_triplets - $current/$nb)\n");
      # my($a,$b,$c)=check_triplet($cand,$triplet);
      # print "$a $b $c\n";
      # print Dumper $triplet;
      # <STDIN>;
      
      $remember{$cand}=1;
      $result+=$cand;
      
    }
  }
  $ii++;
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

