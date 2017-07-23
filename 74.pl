use strict;
use warnings;
use Data::Dumper;
use List::Util qw( sum max min );
use Hashtools;
use Permutations;

my($max_digits)=6; #we look into number having less or equal to 6 digits

my(@facts)=(1);
my(@number_in_fact_dec)=(0);
my($sum_of_facts_digits)=0;

for(my($k)=1;$k<=9;$k++)
{
  $facts[$k]=$k*$facts[$k-1];
  $number_in_fact_dec[$k]=0;
}

my(%fact_tree)=();

my(%direct_candidates_59)=();

while( increment())
{
  my($s)=join("",reverse(@number_in_fact_dec[1..9]))+0;
  my($l)=get_recursive_depth($s);
  if($l >= 59 )
  {
    Hashtools::increment(\%direct_candidates_59,$s);
  }
}

## Pour que le code soit complet :
## il aurait fallu gerer les cas differents de 60 ou 59.
##
## De plus ici, il ne faut pas oublier les solutions ou on a 
## Une decomposition factiorielle non unique. Ex: 1000 = 0400
## Par chance, les solutions de cette instance n'ont pas ce genre de cas
## dans le cas general ca peut arriver !!! 

my($cand);
my($num_60)=0;
foreach $cand (keys(%direct_candidates_59))
{
  my($s)=$cand;
  my($prod)=1;
  my($num_digits_left)=sum(split(//,$cand));
  while(length($s)>0)
  {
    $s=~m/^(.*)(.)$/;
    #Cas du 0/1
    if( length($s)==length($cand))
    {
       #Il faut ajouter autant de zero que de 1, mais ne pas compter le cas ou les zeros sont devant
        my($count_zero_ones_may_be_first)= ( Permutations::cnk( $num_digits_left ,$2)*( 2** $2) );
        my($count_first_one_is_zero) = ( Permutations::cnk( $num_digits_left-1 ,$2-1)*( 2** ($2-1) ));
        $prod*=( $count_zero_ones_may_be_first - $count_first_one_is_zero);
    }
    else
    {
        $prod*=Permutations::cnk( $num_digits_left , $2);
    }
    $s=$1;
    $num_digits_left -= $2;
  }
  $num_60+=$prod;
} 
print $num_60;

sub get_recursive_depth
{
  my($s)=@_;
  if(exists($fact_tree{$s}))
  {
    if( $fact_tree{$s}!=-1) #On tombe sur un nombre deja connu
    {
      return $fact_tree{$s};
    } 
    else #On tombe sur un nombre deja parcuru : on vient de boucler
    {
      $fact_tree{$s} = -2;
      return 0;
    }
  }
  else
  {
    $fact_tree{$s} = -1;
    my($next_decimal)= next_fact($s);
    
    my($depth)= get_recursive_depth($next_decimal) + 1;
  
    if ( $fact_tree{$s} == -2 )
    # onest revenu sur la premiere fois ou on a parcouru ce nombre. Il faut remplir le cycle. 
    {
      my($deeper_decimal)= $s;
      for( my($loop)= $depth; $loop>0;$loop --)
      {
        $fact_tree{$deeper_decimal} = $depth;
        $deeper_decimal = next_fact($deeper_decimal);
      }
    }
    else
    {
        $fact_tree{$s} = $depth;
    }
  
    return $depth;
  }
}

sub next_fact
{
  my($fact)=@_;
  my($decimal)=calc_decimal($fact);
  my(@dec)=split(//,$decimal);
  my(@t)=();
  for(my($a)=0;$a<=9;$a++)
  {
    $t[$a]=0;
  }
  for(my($a)=0;$a<=$#dec;$a++)
  {
    $t[$dec[$a]]++;
  }
  my($decimal2)=join("",reverse(@t[1..9]))+$t[0];
  my($ret)= decompose_fact(calc_decimal($decimal2));
  #print "fact $fact decimal $decimal decimal2 $decimal2 return $ret\n";
  #<STDIN>;
  return $ret;
}

sub calc_decimal
{
  my($fact)=@_;
  my(@t)=split(//,$fact);
  my($val)=0;
  for(my($a)=0;$a<=$#t;$a++)
  {
    $val+=$facts[$a+1]*$t[$#t- $a];  
  }
  return $val;
}

sub decompose_fact
{
  my($v)=@_;
  my($ret)=0;
  for(my($n)=1;$n<=9;$n++)
  {
    my($digit)=($v%($n+1));
    $ret += $digit*(10**($n-1));
    $v = ($v - $digit)/($n+1) ;
  }
  return $ret;
}

sub increment
{
  for(my($idx)=1;$idx<=9;$idx++)
  {
    if( $sum_of_facts_digits == 6 || $number_in_fact_dec[$idx] == $idx )
    {
      if( $number_in_fact_dec[$idx] == 0 )
      {
        next;
      }
      else
      {
        $sum_of_facts_digits -= $number_in_fact_dec[$idx];
        $number_in_fact_dec[$idx] = 0;
      }
    }
    else
    {
      $sum_of_facts_digits ++;
      $number_in_fact_dec[$idx]++;
      return 1;
    }
  }
  return 0;
}
