#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;
use List::Util qw/min max/;

for(my($n)=1;$n<100;$n++)
{
  my($squ)=sqrt($n);
  my($isqu)=int($squ);
  next if($isqu*$isqu == $n);

  my(@alist)=();
  my($rep)=[1,0,1];
  while($$rep[0]!=1 || $$rep[1]!=$isqu || $$rep[2]!=1)
  {
    my($intpart)=int_eval(@$rep,$squ);
    push(@alist,$intpart);
    $$rep[1]-=$intpart*$$rep[2];
    
    my($a,$b,$c)=($$rep[2]*$$rep[0],-$$rep[2]*$$rep[1],$$rep[0]*$$rep[0]*$n - $$rep[1]*$$rep[1]);
    my($d)=pgcd(pgcd($a,$b),$c);
    # print "abcd : $a $b $c $d\n";<STDIN>;
    $rep =[$a/$d,$b/$d,$c/$d];
    
    # print Dumper $rep;
    # <STDIN>;
  }
  push(@alist,int_eval(@$rep,$squ));
  print "------ n = $n -------\n";
  print "$n : [".join(" ",@alist)."]\n";
  my($limit)=1000;
  my($rbest_approx_huygens,$rbest_approx_lagrange)=best_approxs($squ,$limit);
  my($reduced,$secondary_reduced)=reduced_frac(\@alist,$limit);
  print "---------------------------\n";
  print "Reduced : ".string_array_fracs($reduced)."\n";
  print "Secondary : ".string_array_fracs($secondary_reduced)."\n";
  print "---------------------------\n";
  print "Huygens : ".string_array_fracs($rbest_approx_huygens)."\n";
  print "Lagrange : ".string_array_fracs($rbest_approx_lagrange)."\n";
  <STDIN>;
}

sub best_approxs
{
  my($irr,$limit)=@_;
  my($q)=1;

  my($min_lagrange)=1000;
  my(@approx_lagrange)=();

  my($min_huygens)=1000;
  my(@approx_huygens)=();

  while($q <= $limit)
  {
    my($qirr)=$q*$irr;
    my($best_p_lagrange)=0;
    my($p)=ceil(-$min_lagrange + $qirr);
    while( $p <= floor($min_lagrange + $qirr))
    {
      if(pgcd($p,$q)>1)
      {
        $p++;
        next;
      }
      $best_p_lagrange = $p;
      $min_lagrange = abs($p - $qirr);
      $p = max(ceil(-$min_lagrange + $qirr),$p+1);
    }
    push(@approx_lagrange,[$best_p_lagrange,$q]) if($best_p_lagrange > 0);

    
    
    my($best_p_huygens) = 0;
    $p=ceil(-$min_huygens*$q + $qirr);

    while( $p <= floor($min_huygens*$q + $qirr))
    {
      if(pgcd($p,$q)>1)
      {
        $p++;
        next;
      }
      $best_p_huygens = $p;
      $min_huygens = abs($p/$q - $irr);
      $p = max(ceil(-$min_huygens*$q + $qirr),$p+1);
    }
    push(@approx_huygens,[$best_p_huygens,$q]) if($best_p_huygens > 0 && $best_p_huygens != $best_p_lagrange);

    $q++;
  }
  return (\@approx_huygens,\@approx_lagrange);
}

sub reduced_frac
{
  my($ralist,$limit)=@_;
  
  my($p,$pp)=(1,0);
  my($q,$qq)=(0,1);
  my(@reduced)=();
  my(@secondary_reduced)=();

  my($idx)=0;
  while($q<=$limit)
  {
    my($a)=$$ralist[$idx];
    my($pn,$qn)=($pp,$qq);
    for(my($b)=1;$b < $a;$b++)
    {
      $pn+=$p;
      $qn+=$q;
      last if($qn > $limit);
      push(@secondary_reduced,[$pn,$qn]);
    }
    $pn+=$p;
    $qn+=$q;
    last if($qn > $limit);
    push(@reduced,[$pn,$qn]);
    $idx++;
    $idx = 1 if($idx > $#$ralist);
    ($p,$pp)=($pn,$p);
    ($q,$qq)=($qn,$q);
  }
  return (\@reduced,\@secondary_reduced);
}

sub string_array_fracs
{
  my($rarray)=@_;
  my(@frac_strings)= map {$$_[0]."/".$$_[1]} @$rarray;
  return join(", ",@frac_strings);
}

sub int_eval
{
  my($a,$b,$c,$sqn)=@_;
  return floor(($a*$sqn + $b)/$c);
}

sub pgcd
{
  my($a,$b)=@_;
  return 0 if($a==0);
  return 0 if($b==0);
  ($a,$b)=($b,$a) if($b>$a);
  $a = -$a if($a<0);
  $b = -$b if($b<0);
  
  while($a>0)
  {
    ($b,$a) = ($a,$b%$a);
  }
  return $b;
}



