#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Gcd;
use POSIX qw/floor/;

my($rmax)=1053779;
my(%base)=();


#Case 1
my($count)=0;
my($p)=1;
while(1)
{
  my($qmax)= $p + 4*$rmax/$p/sqrt(3);
  last if(3*$p+1 > $qmax);

  $count+=qloop1($p,3*$p+1,4);
  $count+=qloop1($p,3*$p+2,1);
  $count+=qloop1($p+1,3*$p+4,4);
  
  $p+=2;
}

print $count;
print "\n";
$p=1;
while(1)
{
  my($qmax)= $p + 4*$rmax/$p*sqrt(3);
  last if($p+1 > $qmax);

  $count+=qloop2($p,$p+1,4);
  $count+=qloop2($p,$p+2,1);
  $count+=qloop2($p+1,$p+2,4);
  
  $p+=2;
}

print $count;
print "\n";
exit(0);
my($brute)=0;
for(my($a)=3;$a<20000;$a++)
{
  print "a : $a\n" if($a%100 == 0 );
  for(my($b)=2;$b<$a;$b++)
  {
    my($c) = sqrt($a*$a + $b*$b - $a*$b);
    if( floor($c)==$c)
    {
      my($r2)= r2circle($a,$b,$c);
      # print "$a $b $c -> $r2\n";
      if($$r2[0]/$$r2[1]<$rmax*$rmax)
      {
        
         $brute ++;
         if(Gcd::pgcd($a,$b)==1)
         {
           if(exists($base{"$a-$b"}))
           {
             delete $base{"$a-$b"};
           }
           else
           {
             print "Error : unexistant $a/$b/$c\n";
           }
         }
      }
    }
  }
}
print "$brute\n";
print Dumper \%base;


sub qloop1
{
  my($p,$qstart,$coeff)=@_;
  
  my($qmax)= $p + 4*$rmax/$p/sqrt(3)/$coeff;
  my($num)=0;
  
  for(my($q)=$qstart;$q < $qmax;$q+=2)
  {
    next if($q%3==0);
    
    if(Gcd::pgcd($p,$q) == 1)
    {
      my($radius)=$p*($q-$p)*sqrt(3)/4;
      $num+=floor($rmax/$radius/$coeff);
      
      #Only debug
      next;
      my($a)=($q*$q -3*$p*$p + 2*$p*$q)*$coeff/4;
      if($a > 0)
      {
        my($b)=$p*$q*$coeff;
        my($c)=(3*$p*$p + $q*$q) * $coeff/4;
        
        my($r2)= r2circle($a,$b,$c);
        my($r)=sqrt($$r2[0]/$$r2[1]);
        
        
        my($co)=floor($rmax/$radius/$coeff);
        print "$p,$q -> $a, $b, $c . R = $r => $co. (qmax : $q/$qmax)\n";
        if($r>=$rmax)
        {
          print "error !\n";
          <STDIN>;
        }
        my($key)="$a-$b";
        if(exists($base{$key}))
        {
          print "Key error : $base{$key}!\n";
          <STDIN>;
        }
        $base{$key} = "$p : $q (1)";
        if($a*$a - $a *$b +$b*$b != $c*$c)
        {
          print "60 deg error !\n";
          <STDIN>;
        }
        if($a<$b )
        {
          print "a>b error !\n";
          <STDIN>;
        }
        
        
        # <STDIN>;
      }
    }
  }
  return $num;
}

sub qloop2
{
  my($p,$qstart,$coeff)=@_;
  
  return 0 if($p%3==0);
  
  my($qmax)= ($p + 4*$rmax/$p*sqrt(3)/$coeff)/3;
  my($num)=0;
  
  for(my($q)=$qstart;$q < $qmax;$q+=2)
  {
    if(Gcd::pgcd($p,$q) == 1)
    {
      my($radius)=$p*(3*$q-$p)/sqrt(3)/4;
      $num+=floor($rmax/$radius/$coeff);
      
      #Only debug
      next;
      my($a)=(3*$q*$q -$p*$p + 2*$p*$q)*$coeff/4;
      if($a > 0)
      {
        my($b)=$p*$q*$coeff;
        my($c)=($p*$p + 3*$q*$q) * $coeff/4;
        
        my($r2)= r2circle($a,$b,$c);
        my($r)=sqrt($$r2[0]/$$r2[1]);
        my($co)=floor($rmax/$radius/$coeff);
        print "$p,$q -> $a, $b, $c . R = $r => $co. (qmax : $q/$qmax)\n";
        # <STDIN>;
        if($r>=$rmax)
        {
          print "error !\n";
          <STDIN>;
        }
        my($key)="$a-$b";
        if(exists($base{$key}))
        {
          print "Key error : $base{$key}!\n";
          <STDIN>;
        }
        $base{$key} = "$p : $q (2)";
        if($a*$a - $a *$b +$b*$b != $c*$c)
        {
          print "60 deg error !\n";
          <STDIN>;
        }
        if($a<$b )
        {
          print "a>b error !\n";
          <STDIN>;
        }
      }
    }
  }
  return $num;
}




sub r2circle
{
  my($a,$b,$c)=@_;
  my($num)=($a+$b-$c)*($a+$c-$b)*($b+$c-$a);
  my($denom)=($a+$b+$c)*4;
  
  return [$num,$denom];
}
