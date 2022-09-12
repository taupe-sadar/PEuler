package Bouncy;
use strict;
use warnings;
use Permutations;
no warnings 'recursion';
use Math::BigInt;
use SmartMult;

my(%cache_bouncy)=();
my(%cache_descending_power10)=();

# Returns the number of bouncy numbers in
# [ 1 ; 10^n - 1 ]
sub count_bouncy_power10
{
  my($n)=@_;
  my($num)=SmartMult::smart_mult(10,$n);
  if( !exists($cache_bouncy{$num}))
  {
    my($constants )= 9*$n ;
    my($ascending ) = Permutations::cnk( $n + 9 , 9 ) - $constants - 1; #Remove the num of constant terms
    my($decending)= count_descending( $n );
    $cache_bouncy{$num} = $num - 1 - ($ascending + $decending + $constants);
  }
  return $cache_bouncy{$num}
}

sub count_descending
{
  my($n)=@_;
  if( !exists($cache_descending_power10{$n}) )
  {
    if( $n <= 1 )
    {
      $cache_descending_power10{$n} = 0;
    }
    else
    {
      $cache_descending_power10{$n} = Permutations::cnk( $n + 9 , 9 ) - 10 + count_descending( $n-1 ); 
    }
  }
  return $cache_descending_power10{$n}
}

# Returns the number of bouncy numbers in
# [ 1 ; n ]
sub count_bouncy
{
  my($n)=@_;
  if( $n < 100 )
  {
    return 0;
  }

  if( !exists($cache_bouncy{$n}))
  {
    my($count_last_zeros)=0;
    $n=~m/^(.*([^0]))(0*)$/ or die "invalid number $n";
    my($prefix)=$1;
    my($prefixlast)=$2;
    my($num_zeros)=length($3);
    if( length($prefix) == 1 )
    {
      $cache_bouncy{$n} = count_bouncy_power10( $num_zeros );
      for( my($a)=1; $a< $prefix; $a++ )
      {
        $cache_bouncy{$n} += count_bouncy_interval( $a, $num_zeros );
      }
    }
    else
    {
      #my($ascending,$descending)= ascending_or_descending( $prefix );
      my($type,@parts)=split_in_bouncy_parts( $prefix );
      
      if( $type =~ m/(.)!/ )
      {
        my($previous_part)=$1;
        my($big)=SmartMult::smart_mult(10,$num_zeros);
        if( $previous_part eq '<' )
        {
          $cache_bouncy{$n} = $parts[2]*$big;
        }
        else #'>'
        {
          $parts[1]=~m/(.)$/;
          my( $last_of_monotone_part )=$1;
          my($working_zeros)= $num_zeros + length($parts[2]) - 1;
          my($working_base) = SmartMult::smart_mult(10,$working_zeros);
          $cache_bouncy{$n} = $parts[2]* $big - ($last_of_monotone_part + 1)*$working_base  + 1;
          
          for(my($i)=0;$i<= $last_of_monotone_part; $i++ )
          {
            $cache_bouncy{$n} += $working_base - count_descending_interval( $i,$working_zeros );
          }
        }
        
        my($big_parts)=SmartMult::smart_mult(10,$num_zeros + length($parts[2]));
        $cache_bouncy{$n} += count_bouncy( "$parts[0]$parts[1]"*$big_parts);
      }
      elsif($type eq '<' )
      {
        my(@digits)=split(//,$parts[1]);
        $parts[0]=~m/(.)$/;
        my($constant_digit)=$1;
        $cache_bouncy{$n} = ($num_zeros == 0) ? 0 : 1; # Is this number bouncy ?
        my($working_zeros)=  $num_zeros;
        my($working_base) = SmartMult::smart_mult(10,$working_zeros);
        
        for( my($d)= $#digits;$d>=1;$d--)
        {
          my($high_digit)=$digits[$d];
          my($previous_digit)=$digits[$d-1];
          $cache_bouncy{$n} += $working_base * $previous_digit; #All them are bouncy
          for( my($v)= $previous_digit; $v<$high_digit;$v++)
          {
            $cache_bouncy{$n} += $working_base - count_ascending_interval( $v,$working_zeros );
          }
          $working_zeros++;
          $working_base*=10;
        }
        #$d=0
        {
           
          my($high_digit)=$digits[0];
          my($previous_digit)= $constant_digit;
          for( my($v)= 0; $v<$previous_digit;$v++)
          {
            $cache_bouncy{$n} += $working_base - count_descending_interval( $v,$working_zeros );
          }
          $cache_bouncy{$n} += count_bouncy_interval( $previous_digit ,$working_zeros );
          for( my($v)= $previous_digit+1; $v<$high_digit;$v++)
          {
            $cache_bouncy{$n} += $working_base - count_ascending_interval( $v,$working_zeros );
          }
          $working_zeros++;
          $working_base*=10;
        }
        #$cache_bouncy{$n} -=0; #Not need to Remove the constant*10*workingbase which is descending
        $cache_bouncy{$n} += count_bouncy( $parts[0]*$working_base );
      }
      elsif( $type eq '>' )
      {
        my(@digits)=split(//,$parts[1]);
        my($working_zeros)=  $num_zeros;
        my($working_base) = SmartMult::smart_mult(10,$working_zeros);
        
        $cache_bouncy{$n} = 0; # This number is descending
        for( my($d)= $#digits;$d>=0;$d--)
        {
          my($high_digit)=$digits[$d];
          for( my($v)= 0; $v<$high_digit;$v++)
          {
            $cache_bouncy{$n} += $working_base - count_descending_interval( $v,$working_zeros );
          }

          $working_zeros++;
          $working_base*=10;
        }
        #$cache_bouncy{$n} -=0; #Not need to Remove the constant*10*workingbase which is descending
        $cache_bouncy{$n} += count_bouncy( $parts[0]*$working_base );
      }
      elsif( $type eq '=' )
      {
        $parts[0]=~m/(.)$/;
        my($digits)=$1;
        my($working_zeros)= $num_zeros;
        my($working_base) = SmartMult::smart_mult(10,$working_zeros);

        $cache_bouncy{$n} = 0; # This number is descending
        for( my($d)= length($parts[0]) - 1 ;$d>=1;$d--)
        {
          for( my($v)= 0; $v<$digits;$v++)
          {
            $cache_bouncy{$n} += $working_base - count_descending_interval( $v,$working_zeros );
          }
          $working_zeros++;
          $working_base*=10;
        }
        #$cache_bouncy{$n} -=0;
        $cache_bouncy{$n} += count_bouncy( $digits*$working_base );
      }
      else
      {
        die "Unexcpected case";
      }
    }
  }
  return $cache_bouncy{$n};
}

# Returns the number of ascending/descending numbers in
# [ prefix * 10^num_digits ; (prefix+1) * 10^num_digits -1 ]
# knowing that prefix as the same property, 
# and given the last number of prefix
# COUNT THE CONSTANT !
sub count_ascending_interval
{
  my($prefixlast, $num_digits)=@_;
  return Permutations::cnk( $num_digits + 9 - $prefixlast , 9 - $prefixlast  );
}

sub count_descending_interval
{
  my($prefixlast, $num_digits)=@_;
  return Permutations::cnk( $num_digits + $prefixlast , $prefixlast  );
}

# Returns the number of bouncy  numbers in
# [ prefix * 10^num_digits ; (prefix+1) * 10^num_digits -1 ]
# knowing that prefix is constant, 
# and given the last number of prefix
sub count_bouncy_interval
{
  my($prefixlast, $num_digits)=@_;
  if( $num_digits==0)
  {
    return 0;
  }
  return SmartMult::smart_mult(10,$num_digits) - count_ascending_interval($prefixlast, $num_digits) - count_descending_interval($prefixlast, $num_digits) + 1;
}

sub ascending_or_descending
{
  my( $n )=@_;
  my(@sorted)=sort({ $a <=> $b } split(//,$n));
  my($sorted_increased) = join("",@sorted);
  my($sorted_decreased) = join("",reverse(@sorted));
  return ($n==$sorted_increased,$n==$sorted_decreased);
}

sub split_in_bouncy_parts
{
  my($prefix)=@_;
  my(@tab)=split(//,$prefix);
  my($type,$constant,$monotone,$bouncy)=("","","");
  my($d);
  my($previous)="";
  my($current)="";
  while( defined( $d = shift( @tab)) )
  {
    if($previous eq "" )
    {
      $type = '='; #for constant
    }
    elsif( $type eq '=' && $previous != $d )
    {
      $constant = $current;
      $current="";
      $type = ( $previous < $d ) ? '<' : '>'; #for ascending or descending
    }
    elsif( ($type eq '<' && $previous > $d)||( $type eq '>' && $previous < $d )  )
    {
      $monotone = $current;
      $current="";
      $type .=  '!'; #for bouncy (with first part ascending/decending)
    }
    
    $current.=$d;
    $previous=$d;
  }
  if( $type eq '=' )
  {
    $constant = $current;
  }
  elsif( $type eq '<' || $type eq '>' )
  {
    $monotone = $current;
  }
  else
  {
    $bouncy = $current;
  }
  return ($type,$constant,$monotone,$bouncy);
}

1;
