use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max );


my($debug)=0;

my($final)=0;
my($count)=0;
for(my($i)=2;$i<=9;$i++)
{
  $count = 0;
  concatened_pandigital($i);
  print "$i : $count\n";
 
}
print $final;

sub concatened_pandigital
{
  my($factor)=@_;
  
  my(%used)=();
  my(%res_used)=();
  for(my($i)=0;$i<=9;$i++)
  {
    $used{$i} = ($i == $factor) ? 1 : 0;
    $res_used{$i} = 0;
  }
  
  build_pandigital_recursive($factor,\%used,\%res_used,[],0,[]);
}

sub build_pandigital_recursive
{
  my($factor,$rused,$rres_used,$rseq,$left_over,$rleftovers)=@_;
  for(my($i)=0;$i<=9;$i++)
  {
    next if( $$rused{$i} );
    my($x)=$factor*$i + $left_over;
    my($left)= $x%10;
    next if($$rres_used{$left});
  
    my($div)= ($x - $x%10)/10;
    
    push(@$rseq,$i);
    push(@$rleftovers,(($div > 0) ? 1 : 0));
    $$rused{$i} = 1;
    $$rres_used{$left} = 1;
  
    
    if( $#$rseq == 8 && $div != 0 && !($$rres_used{$div}) )
    {
      my(@numbers)=();
      my($last_used_idx)=-1;
      for(my($idx)=0;$idx<=8;$idx++)
      {
        if(!$$rleftovers[$idx])
        {
          push(@numbers,join("",reverse(@$rseq[($last_used_idx+1)..$idx])));
          $last_used_idx=$idx;
        }
      }
      if($last_used_idx < 8 )
      {
        push(@numbers,join("",reverse(@$rseq[($last_used_idx+1)..8])));
      }
      @numbers=sort({substr($factor * $b,0,1) <=>  substr($factor * $a,0,1)} @numbers);
      
      if( $#numbers >= 1)
      {      
        $final=max($final,join("",map({ $factor * $_} @numbers)));

        if( $final == 9786105234 )
        {
          my($n)=join(' ',@numbers);
          my($m)=join(' ',map({$factor *$_} @numbers));
          print "$n x $factor = $m\n";
          <STDIN>;
        }
        
        
      }   
      
    }
    else
    {
      
      build_pandigital_recursive($factor,$rused,$rres_used,$rseq,$div,$rleftovers);
    }

    $$rres_used{$left} = 0;
    $$rused{$i} = 0;
    pop(@$rleftovers);
    pop(@$rseq);
  }
}