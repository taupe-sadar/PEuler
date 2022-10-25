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
# print Dumper $prime_numerators_inverse;<STDIN>;

my(%sum_marks)=();

# print "".(32*27*25*7*11*13*17*19*23*29*31)."\n";
# <STDIN>;

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
            # print "$$rp1[$i1]/$q1 + $$rp2[$i2]/$q2 = $num/$base\n";
            # <STDIN>;
            
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
              # print "$$rp1[$i1]/$q1² + $$rp2[$i2]/$q2² = $znum/$base²\n";
              # <STDIN>;
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
          # print "$$rq1[$i1]/$p1 + $$rq2[$i2]/$p2 = $num/$base\n";
          # <STDIN>;
        }
        my($znum_root)=floor(sqrt($num_squ));
        if($znum_root*$znum_root == $num_squ)
        {
          my($zgcd_square)=Gcd::pgcd($znum_root,$base);
          my($znum_root_square)=$znum_root/$zgcd_square;
          if($znum_root_square <= $max_order)
          {
            store_s($p1,$$rq1[$i1],$p2,$$rq2[$i2],$base/$zgcd_square,$znum_root_square);
            # print "$$rq1[$i1]/$p1² + $$rq2[$i2]/$p2² = $znum_root/$base²\n";
            # <STDIN>;
          }
        }
        
      }
    }
  }
}

total_frac();
print "-----------------------------\n";
test();

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

sub test_golden
{
  my($x,$y,$z,$n)=@_;
  my($f1)=pow($x,$n+1)+pow($y,$n+1)-pow($z,$n+1);
  my($f2)=(pow($x,$n-1)+pow($y,$n-1)-pow($z,$n-1))*($x*$y + $y*$z + $z*$x);
  my($f3)=(pow($x,$n-2)+pow($y,$n-2)-pow($z,$n-2))*($x*$y*$z);
  my($f)=$f1 + $f2 - $f3;
  
  if($f->numerator() != 0 )
  {
    # print "".pow($x,$n+1)." ".pow($y,$n+1)." ".pow($z,$n+1)."\n";
    # print "$x $y $z ($n) $f1 $f2 $f3\n";<STDIN>;
  }
  
  return $f->numerator() == 0;
}

sub pow
{
  my($f,$n)=@_;
  return $f->inverse() if($n == -1);
  my($p)=Fraction->new(1,1);
  while($n > 0)
  {
    $p*=$f;
    $n--;
  }
  return $p;
}

sub test
{
  my($sum)=Fraction->new(0,1);
  my($integer_part)=0;
  my(%all)=();
  
  my(@sumX)=(0)x($max_order+1);
  for(my($a)=1;$a<=$max_order;$a++)
  {
    for(my($b)=$a+1;$b<=$max_order;$b++)
    {
      for(my($c)=1;$c<=$max_order;$c++)
      {
        for(my($d)=$c+1;$d<=$max_order;$d++)
        {
          my($f)=Fraction->new($a,$b);
          my($g)=Fraction->new($c,$d);
          my($h)=$f+$g;
          if($h->numerator() < $h->denominator() && $h->denominator() <= $max_order )
          {
            unless(exists($all{"$f-$g-$h"}))
            {
              $all{"$f-$g-$h"} = 1;
              $sum += $f+$g+$h;
              # print "$f-$g-$h (1)\n";
              $sumX[$f->denominator()] += $f->numerator();
              $sumX[$g->denominator()] += $g->numerator();
              $sumX[$h->denominator()] += $h->numerator();
           }
          }
          my($f2)=Fraction->new($a*$a,$b*$b);
          my($g2)=Fraction->new($c*$c,$d*$d);
          my($issqu)=is_square($a*$a*$d*$d + $c*$c*$b*$b);
          if($issqu)
          {
            my($h2)=$f2+$g2;
            my($squ_h)=Fraction->new(sqrt($h2->numerator()),sqrt($h2->denominator()));
            if($squ_h->numerator() < $squ_h->denominator() && $squ_h->denominator() <= $max_order)
            {
              
              unless(exists($all{"$f-$g-$squ_h"}))
              {
                $all{"$f-$g-$squ_h"} = 1;
                $sum += $f+$g+$squ_h;
                # print "$f-$g-$squ_h (2)\n";
                $sumX[$f->denominator()] += $f->numerator();
                $sumX[$g->denominator()] += $g->numerator();
                $sumX[$squ_h->denominator()] += $squ_h->numerator();
              }
            }
          }
          my($f3)=Fraction->new($b,$a);
          my($g3)=Fraction->new($d,$c);
          my($h3)=($f3+$g3)->inverse();
          if($h3->numerator() < $h3->denominator() && $h3->denominator() <= $max_order )
          {
            unless(exists($all{"$f-$g-$h3"}))
            {
              $all{"$f-$g-$h3"} = 1;
              $sum += $f+$g+$h3;
              # print "$f-$g-$h3 (3)\n";
              $sumX[$f->denominator()] += $f->numerator();
              $sumX[$g->denominator()] += $g->numerator();
              $sumX[$h3->denominator()] += $h3->numerator();
            
            }
          }
          my($f4)=Fraction->new($b*$b,$a*$a);
          my($g4)=Fraction->new($d*$d,$c*$c);
          if($issqu)
          {
            my($h4)=($f4+$g4)->inverse();
            my($squ_h)=Fraction->new(sqrt($h4->numerator()),sqrt($h4->denominator()));
            if($squ_h->numerator() < $squ_h->denominator() && $squ_h->denominator() <= $max_order)
            {
              
              unless(exists($all{"$f-$g-$squ_h"}))
              {
                $all{"$f-$g-$squ_h"} = 1;
                $sum += $f+$g+$squ_h;
                # print "$f-$g-$squ_h (4)\n";
                $sumX[$f->denominator()] += $f->numerator();
                $sumX[$f->denominator()] += $g->numerator();
                $sumX[$f->denominator()] += $squ_h->numerator();
              }
            }
          }
          while($sum->numerator() > $sum->denominator())
          {
            $sum -= Fraction->new(1,1);
            $integer_part++;
          }
          
        }
      }
    }
  }
  for(my($i)=2;$i<=$max_order;$i++)
  {
    print "$i : $sumX[$i]\n";
  }
  
  
  print "test : $integer_part + $sum\n"
}

sub is_square
{
  my($n)=@_;
  my($x)=floor(sqrt($n));
  return ($x*$x == $n);
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