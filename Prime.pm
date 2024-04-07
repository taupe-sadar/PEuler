package Prime;
use strict;
use warnings;
use PrimeC;
use Hashtools;
use Data::Dumper;
use POSIX qw/floor ceil/;
use List::Util qw( max min );
use IrregularBase;

#Crible variables
my(@indexes)=(0);
our($default_size_crible)=50000;
my($crible_size)=10000;

sub protected_is_prime
{
  my($n)=@_;
  if($n==0)
  {
    return 0;
  }
  
  if(abs($n)==1)
  {
    return 1;
  }
  return is_prime(abs($n));
}

#second_argument is used to init with higher prime
sub fast_is_prime
{
  my($n)=@_;
  my($local_idx)=0;
  my($go_no_further)=sqrt($n);
  my($p)= getNthPrime( $local_idx  );
  while($p<=$go_no_further)
  {
    if(!($n%$p))
    {
      return 0;
    }
    $local_idx++;
    $p=getNthPrime( $local_idx  );
  }
  return 1;
}

sub is_prime
{
  my($n)=@_;
  my( $last_sieved ) = PrimeC::getHighestSievedValue();
  
  my($response)="";
  #print "Priming!\n";
  if( $last_sieved >= $n )
  {
    $response = dichotomy_is_prime( $n );
  }
  else
  {
    $response = fast_is_prime( $n );
  }
  
  #print "$n  => $response !\n"; <STDIN>;
  
  return $response;
  
}

#Do not call with n superior to the maximum prime calculated in PRimeC.pm
sub dichotomy_is_prime
{
  my($n)=@_;
  my($min_idx,$max_idx)=(0,PrimeC::getNumCalculatedPrimes()-1);
  
  return 1 if( $n == 2 || $n == getNthPrime($max_idx) );
  
  while( ( $min_idx +1 ) <  $max_idx )
  {
    my( $idx ) = floor( $min_idx  + $max_idx ) / 2;
    my( $middle_prime ) = PrimeC::getNthPrime($idx);
    
    return 1 if( $n == $middle_prime );
    
    if( $n > $middle_prime )
    {
      $min_idx = $idx;
    }
    else # $n < $middle_prime
    {
      $max_idx = $idx;
    }
  }
  return 0;
  
}

sub hash_product
{
  my($ref1,$ref2)=@_;
  my(%hash)=%{$ref2};
  my($key);
  foreach $key (keys %{$ref1})
  {
    Hashtools::increment(\%hash,$key,$$ref1{$key});
  }
  return %hash;
}

sub num_divisors_hash
{
  my($ref)=@_;
  my($key);
  my($num)=1;
  foreach $key (keys %{$ref})
  {
    $num*=($$ref{$key}+1);
  }
  return $num;
}

sub decompose_tab
{
  my($n)=@_;
  my(%hash)=decompose($n);
  return sort({$a <=> $b } keys(%hash));
}

#retourne le plus petit facteur premier, sa plus grande puissance, et le reste dans la decomposition 
# Exemple : avec $n=2**9 * 3**7 * 5**21 * 7**2; => retourne (2,2**9 , 3**7 * 5**21 * 7**2)

sub partial_decompose 
{
  my($n)=@_;
  my($go_no_further)=sqrt($n);
  reset_prime_index();
  if($n<=1)
  {
    return (1,1,1);
  } 
  my($prime)=next_prime();
  my($weak_factor)=1;
  my($rest)=$n;
  while($prime <= $go_no_further)
  {
    while( ($rest % $prime)==0 )
    {
      $rest/=$prime;
      $weak_factor*=$prime;
    }
    if($rest<$n)
    {
      last;
    }
    $prime = next_prime();
  }
  if($weak_factor==1) #cas n est premier
  {
    return ($rest,$rest,1);
  }
  else
  {
    return ($prime,$weak_factor,$rest);
  }
}

sub decompose
{
  my($n)=@_;
  my(%hash)=();
  my($go_no_further)=sqrt($n);
  init_crible($default_size_crible);
  my($prime)=next_prime();
  
  while(($prime <= $go_no_further)&& ($prime>1))
  {
    while( ($n % $prime)==0 && ($prime <= $go_no_further) && ($prime>1))
    {
      Hashtools::increment(\%hash,$prime);
      
      $go_no_further = sqrt($n);
      $n = $n/$prime;
    }
    $prime = next_prime();
  }
  if($n > 1)
  {
    Hashtools::increment(\%hash,$n);
  }
  return %hash;
}

sub dec_to_nb
{
  my($rdec)=@_;
  my($nb)=1;
  foreach my $prime_nb (keys(%$rdec))
  {
    $nb*= $prime_nb**( $$rdec{$prime_nb} );
  }
  return $nb;
}

sub init_crible
{
  my($n)=@_;
  reset_prime_index();
  PrimeC::processSieve( $n );
}


sub reset_prime_index
{
  my($idx)=@_;
  if(!defined($idx))
  {
    $idx=0;
  }
  
  $indexes[$idx]=0;
}

sub next_prime
{
  my($idx)=@_;
  if(!defined($idx))
  {
    $idx = 0;
  }
  $indexes[$idx] = 0 if( $#indexes < $idx );
  my( $p ) = getNthPrime($indexes[$idx]);
  $indexes[$idx] ++;
  return $p;
}

sub getNthPrime
{
  my($nth)=@_;
  my($p) = PrimeC::getNthPrime( $nth );
  while( $p == 0  )
  {
    $crible_size*=2;
    PrimeC::processSieve( $crible_size );
    $p = PrimeC::getNthPrime( $nth );
  }
  return $p;
}


sub all_divisors_no_larger
{
  # $test == 0 or undef means that there is no test
  my($ref_hash,$test)=@_;
  if((!defined($test))||(!($test=~m/\d+/)))
  {
    $test = 0;
  }
  my(@keys) = keys(%$ref_hash);
  return (1) if $#keys  < 0;
  my(@divisors)=();
  my(%hashcopy)=%{$ref_hash};
  my(@tabkeys)=keys(%hashcopy);
  my($key)=pop(@tabkeys);
  if($#tabkeys<0)
  {
    @divisors=(1);
  }
  else
  {
    delete $hashcopy{$key};
    @divisors = all_divisors_no_larger(\%hashcopy,$test);
  }
  my($div_length_1)=$#divisors;
  my($i,$j)=(0,0);
  for($i=0;$i<=$div_length_1;$i++)
  {
    my($div)=$divisors[$i];
    for($j=1;$j<=$$ref_hash{$key};$j++)
    {
      $div*=$key;
      if((!$test)||($div < $test))
      {
        push(@divisors,$div);
      }
      else
      {
        last;
      }
    }
  }
  return @divisors;
}

# Calculate all decompositions, such : 12 = 2*6 = 3*4 = 2*2*3
sub all_divisors_decompositions
{
  my($n)=@_;
  my( %decomposition )= decompose( $n );
  my( @primes ) = keys(%decomposition);
  return () if( $#primes < 0 );
  my( @max_exp ) = map( {$decomposition{$_}} @primes);
  
  my( $irr_number ) = IrregularBase->new( \@max_exp, \@max_exp );
  return all_divisors_decompositions_internal( \@primes, $irr_number, $irr_number->clone() );
}


sub all_divisors_decompositions_internal
{
  my( $rprimes, $irr_number, $max_irr_number )=@_;
 
  sub build_nb_from_dec
  {
    my($rp,$irr_nb)=@_;
    my($nb)=1;
    my(@re)=$irr_nb->get_nb();
    for(my $i = 0; $i <=$#re; $i ++ )
    {
      $nb*= $$rp[$i]**$re[$i];
    }
    return $nb;
  }

  my( @decompositions ) = ();
  @decompositions =( [ build_nb_from_dec( $rprimes, $irr_number )  ] ) unless( $irr_number->compare( $max_irr_number ) > 0 ); 

  while( $irr_number->uniterate() )
  {
    last if( $irr_number->{"nb"}[-1] == 0 );
    next if( $irr_number->compare( $max_irr_number ) > 0 );
    
    # print Dumper $irr_number;<STDIN>;
    
    my( $irr_dec_left ) = $irr_number->opposite();
    $irr_dec_left->use_nb_as_base();
    my( @all_decompositions_left ) = all_divisors_decompositions_internal( $rprimes, $irr_dec_left, $irr_number );
    
    my( $num ) = build_nb_from_dec( $rprimes,  $irr_number  );
        
    for( my($i)=0;$i<=$#all_decompositions_left;$i++ )
    {
      unshift( @{$all_decompositions_left[$i]}, $num );
      push( @decompositions, $all_decompositions_left[$i] );
    }
  }
  return @decompositions ;
}

sub p_valuation
{
  my( $n , $p ) = @_;
  
  my($pval) = 0;
  while( $n % $p  == 0) 
  {
    $pval++;
    $n= $n/$p;
  }
  return $pval;
}

sub fact_p_valuation
{
  my($nb,$p)=@_;
  my($pval)=0;
  my($div)=$p;
  while($nb >= $div)
  {
    $pval += floor($nb/$div);
    $div *= $p;
  }
  return $pval;
}

sub pow_loop
{
  my($n,$init_fn,$incr_func,$operation_func,$last_prime)=@_;
  $last_prime = $n unless(defined($last_prime));
  
  Prime::init_crible($n+1000);
  my($sqrt_n)=floor(sqrt($n));
  my(@list)=(1);
  my($p)=Prime::next_prime();

  while($p <= $last_prime)
  {
    my(@pows)=();
    my($pow)=$p;
    while($pow<=$n)
    {
      push(@pows,$pow);
      $pow*=$p;
    }
    
    @list = sort({$a<=>$b} @list) if($p<=$sqrt_n);
    my($nextp)=Prime::next_prime();
    my($max_elem)=floor($n/$nextp);

    my($end_list)=$#list;
    $init_fn->($p);

    #Dichotomy
    my($splice_idx)=-1;

    if( $p<=$sqrt_n )
    {
      my($bound_min)=0;
      my($bound_max)=$end_list;
      while( $bound_max - $bound_min > 1)
      {
        my($test)=ceil(($bound_min+$bound_max)/2);
        if($list[$test] <= $max_elem)
        {
          $bound_min = $test;
        }
        else
        {
          $bound_max = $test;
        }
      }
      $splice_idx = $bound_max if( $list[$bound_max] > $max_elem );
    }

    foreach my $ppow (@pows)
    {
      for(my($i)=0;$i<=$end_list;$i++)
      {
        my($elem)=$ppow*$list[$i];
        last if($elem > $n);

        $operation_func->($elem,$list[$i],$max_elem);

        if($elem <= $max_elem)
        {
          push(@list,$elem);
        }
      }
      $incr_func->();
    }
    
    splice(@list,$splice_idx,$end_list-$splice_idx+1) if($splice_idx!=-1);
    $p=$nextp;
  }
}

1;

