package SmartMult;
use bigint;

sub smart_mult
{
	my($n,$pow)=@_;
	my($powwow)=1;
	$n=new Math::BigInt($n);
	do
	{
		if(($pow%2)==1)
		{
			$powwow*=$n;
			$pow--;
		}
		$pow/=2;
		if($pow>0)
		{
			$n=$n*$n;
		}
		
	}while($pow>0);
	return $powwow;
}

sub smart_mult_modulo
{
	my($n,$pow,$modulo)=@_;
	my($powwow)=1;
	$n=new Math::BigInt($n);
	do
	{
		if(($pow%2)==1)
		{
			$powwow=($powwow*$n)%$modulo;
			$pow--;
		}
		$pow/=2;
		if($pow>0)
		{
			$n=($n*$n)%$modulo;
		}
		
	}while($pow>0);
	return $powwow;
}

sub fast_mult
{
  my($number,$exponent)=@_;
  my( $result )= 1;
  
  my( @exps ) = ( $number );
  
}

sub fast_mult_modulo
{
  my($number,$exponent,$modulo)=@_;
  my( $result )= 1;
  
  my( @exps ) = ( $number );
  
}

1;
