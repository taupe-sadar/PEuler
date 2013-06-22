use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor ceil/;

my($overall_size)=10**5;
my($sorted_element_requiered)=10**4;

#Starting with 1
my($count_radical)=1;

my($nb)=1;
my($element_requiered)=0;
while(1)
{
  $nb++;
  my(%decomposition)=Prime::decompose($nb);
  next if(!first_radical(\%decomposition));

  
  my( @primes_dec )=sort( {$a<=>$b} keys( %decomposition ));
  my($count_same_radical) = count_integer_with_same_radical( $overall_size, @primes_dec );
  
  print "".join(" ",@primes_dec)." -> ";
  print "+ $count_same_radical = ".($count_same_radical+$count_radical )."\n";#<STDIN>;
  
  
  if( $count_radical + $count_same_radical >= $sorted_element_requiered )
  {
    $element_requiered = find_indexed_integer_with_radical( $overall_size , $sorted_element_requiered - $count_radical, \@primes_dec );
    last;
  }
  else
  {
    $count_radical+= $count_same_radical;
  }
  
}

print $element_requiered;

sub first_radical
{
  my( $rhash )=@_;
  my($a);
  foreach  $a (values(%$rhash))
  {
    return 0 if $a!=1;
  }
  return 1;
}

sub count_integer_with_same_radical
{
  my($size, @primedec ) =@_;
  my($p,@others)=(@primedec);
  my($reduced_size)= floor($size/product(@primedec));
  my($rlistcomposites)= list_composites($reduced_size, @others  );
  my($counting)=0;
  

  for(my($i)=0;$i<=$#$rlistcomposites;$i++)
  {
    my($add)=   log($reduced_size /  $$rlistcomposites[$i]  )/log($p)  ;

    $counting += floor("$add" + 1);
 }


  my($rfullist) = list_composites($reduced_size, @primedec  );

  if( ($#$rfullist+1) != $counting )
  {
    print "".join(" ",@primedec)."\n";
    print Dumper $rlistcomposites;
    print Dumper $rfullist;
    print "$reduced_size\n";
    die "$#$rfullist + 1 != $counting "
  }
  
  return $counting ;
  
}

sub find_indexed_integer_with_radical
{
  my( $size, $index_wanted , @primedec ) =@_;
  my($mincomposite) = product(@primedec);
  my($reduced_size) = floor($size/$mincomposite);
  die "TODO";
}

sub list_composites
{
  my($max, @primes)=@_;
  
  return [1] if $#primes < 0;
  
  my(@composites)=(1);
  
  my($pow,@otherscomposites)=(@primes);
  while( $pow <= $max )
  {
    push(@composites,$pow);
    $pow*=$primes[0];
  }
    
  if( $#primes > 0 )
  {
    my($size_single_composite)=$#composites;
    my($rothers_composites)= list_composites( $max, @otherscomposites );
    #Starting with the first element not equal to one 
    for(my($i)=1;$i<=$#$rothers_composites;$i++)
    {
      for(my($j)=0;$j<=$size_single_composite;$j++)
      {
        my($composite)= $$rothers_composites[$i]*$composites[$j];
        last if($composite > $max );
        push(@composites,$composite);
      }
    }
  }
  return \@composites;
}

sub product
{
  my(@factors)=@_;
  my($prod)=1;
  for(my($i)=0;$i<=$#factors;$i++)
  {
    $prod*=$factors[$i];
  }
  return $prod;
}
