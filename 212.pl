#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor/;
use List::Util qw(max min);

my($num_cuboids)=50000;
my($space)=10000;
my($width)=399;
my($divisions)=25;

my(@cuboids)=();
my(@regions_main)=();
my(@regions_presence)=();
for(my($r)=0; $r < ($divisions**3); $r++)
{
  push(@regions_main,[]);
  push(@regions_presence,[]);
}

my($gen)=generator();

for(my($c)=0;$c<$num_cuboids;$c++)
{
  my($cubo)=cuboid($gen);
  my(@xidx)=(idx_div($$cubo[0]),idx_div($$cubo[0]+$$cubo[3]-1));
  my(@yidx)=(idx_div($$cubo[1]),idx_div($$cubo[1]+$$cubo[4]-1));
  my(@zidx)=(idx_div($$cubo[2]),idx_div($$cubo[2]+$$cubo[5]-1));
  pop(@xidx) if($xidx[1]==$xidx[0]);
  pop(@yidx) if($yidx[1]==$yidx[0]);
  pop(@zidx) if($zidx[1]==$zidx[0]);

  my(@cubo_idxs)=();
  
  for my $x (@xidx){ for my $y (@yidx){ for my $z (@zidx){
    my($rid)=region_id($x,$y,$z);
    push(@cubo_idxs,$rid);
    push(@{$regions_presence[$rid]},$c);
  }}}
  my($zone)=shift(@cubo_idxs);
  
  push(@cuboids,[$cubo,$zone,\@cubo_idxs]);
  my($rid)=region_id($xidx[0],$yidx[0],$zidx[0]);

  push(@{$regions_main[$rid]},$c);
  
}

# print Dumper \@cuboids;
# for(my($i)=0;$i<=$#regions;$i++)
# {
  # print ("$i : [".join(" ",@{$regions[$i]})."]\n");
# }

my($union)=0;
for(my($r)=0;$r<=$#regions_main;$r++)
{
  my($current_cuboids)=$regions_main[$r];
  for(my($c)=0;$c<=$#$current_cuboids;$c++)
  {
    my($cuboid,$zone,$radjacents)=(@{$cuboids[$$current_cuboids[$c]]});
    $union += volume($cuboid);
    # print "Simple : ($$current_cuboids[$c]) : +".volume($cuboid)."\n";
    
    
    my(%all_others_idx)=();
    for(my($cc)=$c+1;$cc<=$#$current_cuboids;$cc++)
    {
      my($cuboid_other_idx)=$$current_cuboids[$cc];
      $all_others_idx{$cuboid_other_idx} = 1;
    }
    for(my($idx_adj)=0;$idx_adj<=$#$radjacents;$idx_adj++)
    {
      my($zone_adj)=$$radjacents[$idx_adj];
      for(my($cub_adj)=0;$cub_adj<=$#{$regions_presence[$zone_adj]};$cub_adj++)
      {
        my($adj_idx)=$regions_presence[$zone_adj][$cub_adj];
        if( $cuboids[$adj_idx][1] > $zone )
        {
          $all_others_idx{$adj_idx}=1;
        }
      }
    }
    
    my(@all_others)=();
    foreach my $idx (sort(keys(%all_others_idx)))
    {
      push(@all_others,$cuboids[$idx][0]);
    }
    # print "($$current_cuboids[$c]) rec_inter (".($#all_others+1).") ($r/$#regions_main)" if($#all_others>=0);
    my($aa)=rec_intersections($cuboid,\@all_others);
    # print "($$current_cuboids[$c]) rec_inter (".join(" ",(keys(%all_others_idx))).") -$aa\n" if($#all_others>=0);
    $union -= $aa;
  }
  
  # print "($r) [".(join(" ",@{$regions_main[$r]}))."]\n";
}

print $union;

sub rec_intersections
{
  my($current_intersected,$alls)=@_;
  
  my($total_volume)=0;
  for(my($i)=0;$i<=$#$alls;$i++)
  {
    my($inter)=intersection($current_intersected,$$alls[$i]);
    
    my($vol)=volume($inter);
    next if($vol==0);
    $total_volume += $vol;
    
    if( $i < $#$alls )
    {
      my(@next_volumes)=@$alls[$i+1..$#$alls];
      
      $total_volume -= rec_intersections($inter,\@next_volumes);
    }
  }
  return $total_volume;
}

sub intersection
{
  my($c1,$c2)=@_;
  
  my(@cr)=(0)x6;
  for(my($co)=0;$co<3;$co++)
  {
    my($cmin,$cmax)=($$c1[$co]<$$c2[$co])?($c1,$c2):($c2,$c1);
    
    next if($$cmin[$co] + $$cmin[$co+3] <= $$cmax[$co]);
    $cr[$co]=$$cmax[$co];
    $cr[$co+3]=min($$cmax[$co+3], $$cmin[$co] - $$cmax[$co] + $$cmin[$co+3]);
  }
  # unless ($cr[3] == 0 || $cr[4] == 0 || $cr[5] == 0 )
  # {
    # print Dumper $c1;
    # print Dumper $c2;
    # print Dumper \@cr;
    # <STDIN>;
  # }
  return \@cr;
}

sub volume
{
  my($cuboid)=@_;
  return $$cuboid[3]*$$cuboid[4]*$$cuboid[5];
}

sub region_id
{
  my($x,$y,$z)=@_;
  return (($z*$divisions + $y)*$divisions + $x);
}

sub idx_div
{
  my($coord)=@_;
  return floor($coord*$divisions/($space+$width));
}


sub cuboid
{
  my($generator)=@_;
  my(@parameters)=();
  for(my($i)=0;$i<3;$i++)
  {
    push(@parameters,gen_next($generator)%$space);
  }
  for(my($i)=0;$i<3;$i++)
  {
    push(@parameters,1+gen_next($generator)%$width);
  }
  return \@parameters;
}

sub generator
{
  my($current)=0;
  my(@state)=();
  return [$current,\@state];
}

sub gen_next
{
  my($generator)=@_;
  $$generator[0]++;
  my($k)=$$generator[0];
  if($k <= 55)
  {
    push(@{$$generator[1]},(100003 - 200003*$k+300007*$k*$k*$k)%1000000);
    return $$generator[1][$k-1];
  }
  else
  {
    my($kidx)=($k-1)%55;
    my($other_idx)=($kidx-24+55)%55;
    $$generator[1][$kidx] = ($$generator[1][$kidx] + $$generator[1][$other_idx]) %1000000;
    return $$generator[1][$kidx];
  }
}

