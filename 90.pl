use strict;
use warnings;
use Data::Dumper;

my(%all_solutions) =();
my( @necessary_linked )= (
    [ 8, 1 ],
    [ 1, 0 ],
    [ 1, 6 ],
    [ 0, 6 ],
    [ 0, 4 ],
    [ 6, 4 ],
    [ 6, 3 ]
    );

my( @necessary_solutions ) = (
);

my($start_s1)="2";
my($start_s2)="5";

find_all_necessary_solutions( $start_s1, $start_s2, 0 );
for( my($n)=0;$n <=$#necessary_solutions; $n++ )
{
  find_all_solutions( $necessary_solutions[$n][0], $necessary_solutions[$n][1] );
}

print scalar(keys(%all_solutions));



sub find_all_necessary_solutions
{
  my($s1,$s2,$idx)=@_;
  
  my($l1,$l2)=(length($s1),length($s2));
  
  if( $l1 > 6 || $l2 > 6 )
  {
    #Unvalid ...
    return;
  }
  
  if( $idx > $#necessary_linked )
  {
    for(my($i)=$l1 ; $i < 6; $i ++ )
    {
      $s1.="X";
    }
    for(my($i)=$l2 ; $i < 6; $i ++ )
    {
      $s2.="X";
    }
    push( @necessary_solutions, [$s1, $s2] );
  
    if( $s1 =~m/^(.*)6(.*)$/ )
    {
      push( @necessary_solutions, [ "$1".'9'."$2", $s2] );
    }
    if( $s2 =~m/^(.*)6(.*)$/ )
    {
      push( @necessary_solutions, [ $s1, "$1".'9'."$2"] );
    }
    if( "$s1|$s2" =~m/^(.*)6(.*)\|(.*)6(.*)$/ )
    {
      push( @necessary_solutions, [  "$1".'9'."$2", "$3".'9'."$4"] );
    }
    return;
  }
  #else
  my(@t)=@{$necessary_linked[$idx]};

  #First case
  
  find_all_necessary_solutions( no_same_digit( $s1 ,$t[0]) , no_same_digit( $s2 ,$t[1]) , $idx + 1 );
  find_all_necessary_solutions( no_same_digit( $s1 ,$t[1]) , no_same_digit( $s2 ,$t[0]) , $idx + 1 );
}

sub no_same_digit
{
  my($string,$char)=@_;
  if( $string=~m/$char/ )
  {
    return $string;
  }
  else
  {
    return "$string$char";
  }
}

sub find_all_solutions
{
  my($dice1,$dice2)=@_;
  my(@tab)=();
  if( @tab =($dice1=~m/^([^X]*)X(.*)$/) )
  {
    for(my($n)=0;$n<=9;$n++)
    {
      if( $tab[0]=~m/$n/  )
      {
        next;
      }
      
      find_all_solutions( "$tab[0]$n$tab[1]" , $dice2 );
    }
  }
  elsif( @tab =($dice2=~m/^([^X]*)X(.*)$/) )
  {
    for(my($n)=0;$n<=9;$n++)
    {
      if( $tab[0]=~m/$n/  )
      {
        next;
      }
      find_all_solutions( "$tab[0]$n$tab[1]", $dice1 );
    }
  }
  else
  {
    $dice1=join("",sort(split(//,$dice1)));
    $dice2=join("",sort(split(//,$dice2)));
    my( $val )= join( "" ,(sort($dice1,$dice2)));
    $all_solutions{$val}=1;
  }
}
