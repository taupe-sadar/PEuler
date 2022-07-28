use strict;
use warnings;
use Data::Dumper;
use integer;
use Permutations;

my($alpha_size)=16;
my($str_length)=16;
my($need_numbers)=3;

my($res)=0;
for(my($size)=$need_numbers;$size<=$str_length;$size++)
{
  my($starting_by)= set_containing_at_least_1_of_each($alpha_size,$size-1,$need_numbers-1);
  my($others)= set_containing_at_least_1_of_each($alpha_size,$size-1,$need_numbers);
  $res += $starting_by * ($need_numbers-1) + $others * ($alpha_size - $need_numbers);
}

print sprintf("%X",$res);

sub set_containing_at_least_1_of_each
{
  my($al_size,$str_size,$req)=@_;
  my($sum)=0;
  for(my($i)=1;$i<=$req;$i++)
  {
    $sum += Permutations::cnk($req,$i) * (($i%2==0)?-1:1)*set_containing_at_least_1_of_any($al_size,$str_size,$i);
  }
  return $sum;
}

sub set_containing_at_least_1_of_any
{
  my($al_size,$str_size,$req)=@_;
  return $al_size**$str_size - ($al_size-$req)**$str_size;
}