use strict;
use warnings;
use Data::Dumper;
use Gcd;
use Fraction;
use POSIX qw/floor/;
use integer;

my($max_order)=35;
my($prime_numerators,$prime_numerators_inverse)=calc_prime_numerators($max_order);
my(@sum_frac_by_denom)=(0)x($max_order+1);

my(%sum_marks)=();

for(my($q1)=2;$q1<=$max_order;$q1++)
{
  my($rp1)=$$prime_numerators[$q1];
  for(my($q2)=$q1;$q2<=$max_order;$q2++)
  {
    my($rp2)=$$prime_numerators[$q2];
    my($base)= Gcd::ppcm($q1,$q2);
    my($base_squ)= $base*$base;
    my($qq1)= $base/$q2;
    my($qq2)= $base/$q1;
    
    for(my($i1)=0;$i1<=$#$rp1;$i1++)
    {
      my($last)=0;
      my($num_part)=$qq2*$$rp1[$i1];
      my($num_squ_part)=$num_part*$num_part;
      my($i2start) = ($q1 == $q2)?$i1:0;
      for(my($i2)=$i2start;$i2<=$#$rp2;$i2++)
      {
        my($num_other) = $qq1*$$rp2[$i2];
        my($num)=$num_other + $num_part;
        my($num_squ)=$num_other*$num_other + $num_squ_part;
        if($num>=$base && $num_squ >= $base_squ)
        {
          $last = 1 if($i2==0);
          last;
        }
        
        if($num < $base)
        {
          my($zgcd)=Gcd::pgcd($num,$base);
          my($zdenom)=$base/$zgcd;
          if($zdenom <= $max_order)
          {
            store_s($$rp1[$i1],$q1,$$rp2[$i2],$q2,$num/$zgcd,$zdenom);
          }
        }
        if($num_squ < $base_squ)
        {
          my($znum)=floor(sqrt($num_squ));
          if($znum*$znum == $num_squ)
          {
            my($zgcd)=Gcd::pgcd($znum,$base);
            my($zdenom)=$base/$zgcd;
            if( $zdenom <= $max_order )
            {
              store_s($$rp1[$i1],$q1,$$rp2[$i2],$q2,$znum/$zgcd,$zdenom);
            }
          }
        }
      }
      last if($last);
    }
  }
}

for(my($p1)=1;$p1<$max_order;$p1++)
{
  my($rq1)=$$prime_numerators_inverse[$p1];
  for(my($p2)=$p1;$p2<$max_order;$p2++)
  {
    my($rq2)=$$prime_numerators_inverse[$p2];
    my($base)= Gcd::ppcm($p1,$p2);
    my($base_squ)= $base*$base;
    my($pp1)= $base/$p2;
    my($pp2)= $base/$p1;
    
    for(my($i1)=0;$i1<=$#$rq1;$i1++)
    {
      my($last)=0;
      my($num_part)=$pp2*$$rq1[$i1];
      my($num_squ_part)=$num_part*$num_part;
      my($i2start) = ($p1 == $p2)?$i1:0;
      for(my($i2)=$i2start;$i2<=$#$rq2;$i2++)
      {
        my($num_other) = $pp1*$$rq2[$i2];
        my($num)=$num_other + $num_part;
        my($num_squ)=$num_other*$num_other + $num_squ_part;
        
        my($zgcd)=Gcd::pgcd($num,$base);
        my($znum)=$num/$zgcd;
        if($znum <= $max_order)
        {
          store_s($p1,$$rq1[$i1],$p2,$$rq2[$i2],$base/$zgcd,$znum);
        }
        my($znum_root)=floor(sqrt($num_squ));
        if($znum_root*$znum_root == $num_squ)
        {
          my($zgcd_square)=Gcd::pgcd($znum_root,$base);
          my($znum_root_square)=$znum_root/$zgcd_square;
          if($znum_root_square <= $max_order)
          {
            store_s($p1,$$rq1[$i1],$p2,$$rq2[$i2],$base/$zgcd_square,$znum_root_square);
          }
        }
      }
    }
  }
}

total_frac();

sub add_frac
{
  my($num,$denom)=@_;
  $sum_frac_by_denom[$denom]+=$num;  
}

sub store_s
{
  my($p1,$q1,$p2,$q2,$psum,$qsum)=@_;
  my($f)=Fraction->new($p1,$q1)+Fraction->new($p2,$q2)+Fraction->new($psum,$qsum);
  unless(exists($sum_marks{"$f"}))
  {
    $sum_marks{"$f"} = 1;
    add_frac($p1,$q1);
    add_frac($p2,$q2);
    add_frac($psum,$qsum);
  }
}

sub total_frac
{
  my($int_part)=0;
  my($frac_part)=Fraction->new(0,1);
  for(my($f)=2;$f<=$max_order;$f++)
  {
    print "$f : $sum_frac_by_denom[$f]\n";
    my($rem)=$sum_frac_by_denom[$f]%$f;
    $int_part += ($sum_frac_by_denom[$f] - $rem)/$f;
    $frac_part += Fraction->new($rem,$f);
    if($frac_part->numerator() >= $frac_part->denominator() )
    {
      $frac_part -= Fraction->new(1,1);
      $int_part++;
    }
  }
  print "$int_part + $frac_part\n";
  print "".($int_part * $frac_part->denominator() + $frac_part->numerator() + $frac_part->denominator())."\n";
}

sub calc_prime_numerators
{
  my($max)=@_;
  my(@prs)=([],[]);
  my(@prs_inv)=();
  push(@prs_inv,[]) while($#prs_inv != $max);
  for(my($i)=2;$i<=$max;$i++)
  {
    my(@t)=();
    for(my($n)=1;$n<$i;$n++)
    {
      push(@t,$n) if(Gcd::pgcd($n,$i)==1);
      push(@{$prs_inv[$n]},$i) if(Gcd::pgcd($n,$i)==1);
    }
    push(@prs,\@t);
  }
  return (\@prs,\@prs_inv);
}