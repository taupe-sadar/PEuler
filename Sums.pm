package Sums;

sub int_sum
{
	my($last)=@_;
	return ($last)*($last+1)/2;
}

sub int_sum_offset
{
    my($offset,$quantity)=@_;
    if( $quantity <= 0 )
    {
	return 0;
    }
    elsif( $offset == 0 )
    {
	return int_sum( $quantity );
    }
    
    return $offset*$quantity + int_sum( $quantity-1);
}

sub side_sum
{
    my($side,$n)=@_;
    if($side==3)
    {
	return int_sum($n);
    }
    elsif($side==4)
    {
	return $n*$n;
    }
    elsif($side==5)
    {
	return $n*(3*$n-1)/2;
    }
    elsif($side==6)
    {
	return $n*(2*$n-1);
    }
    elsif($side==7)
    {
	return $n*(5*$n-3)/2;
    }
    elsif($side==8)
    {
	return $n*(3*$n-2);
    }
    
}
sub int_square_sum
{
	my($last)=@_;
	return int_sum($last)*(2*$last+1)/3;
}

#return sum of int(n/d)
sub sum_integer_div_by
{
    my($n,$d)=@_;
    my($q)=int($n/$d);
    my($r)=$n%$d;
    my($s)=$q*($q-1)/2*$d + $q*($r+1);
    return $s;
}
1;
