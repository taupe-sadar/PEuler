use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum min max );
use Math::BigInt;

my($stop_idx)= 30;

my($increment_power)=2;
my($stop_power)= 2;

my(@store_powers)=(0);

my(%power_infos)=();

while( $#store_powers < $stop_idx )
{
  my($alimit)=min(9*$stop_power,10**($stop_power/2));
  my(@store_powers_tmp)=();
  for(my($a)=2;$a<=$alimit;$a++)
  {
    if(!exists($power_infos{$a}))
    {
      $power_infos{$a}={"pow"=>1,"val"=>new Math::BigInt($a)};
    }
    
    my($stop_nb)=10**$stop_power;
    while( $power_infos{$a}{"val"}< $stop_nb )
    {
      $power_infos{$a}{"val"}*= $a;
      $power_infos{$a}{"pow"}++;

      my($nb_powered)=$power_infos{$a}{"val"};
      if(  sum(split(//,$nb_powered)) == $a )
      {
        push( @store_powers_tmp , $nb_powered)
      }
    }
  }
  push( @store_powers, sort( {$a<=>$b} @store_powers_tmp ));
  $stop_power+=$increment_power;
}

print $store_powers[$stop_idx];
