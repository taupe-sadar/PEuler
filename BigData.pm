package BigData;
use strict;
use warnings;
use Data::Dumper;
use ArrayDir;
use List::Util qw( max min );

our(@BIGARRAY)=();
our($dim)=0;

sub init
{ 
	my($big_number,$delim1,$delim2)=@_;
	if(defined($delim1))
	{
		$dim++;
		@BIGARRAY=split(/$delim1/,$big_number);
		if(defined($delim2))
		{
			$dim++;
			my($arraysize)=$#BIGARRAY+1;
			my($i)=0;
			for($i=0;$i<$arraysize;$i++)
			{
				my(@arr)=split(/$delim2/,$BIGARRAY[$i]);
				$BIGARRAY[$i]=\@arr;
			}
		}
	}
	
}

sub calcMax
{
	my($calc,$operandes,$direction)=@_;
	my(@BIGCOPY)=@BIGARRAY;
	my(@d)=fill_undef(\@BIGCOPY,$calc);
	my(@prepro)=();
	my(@vector)=(1);
	
	preprocess(\@BIGCOPY,\@prepro,$calc,$operandes,$direction,@d);
	my($max)=process(\@BIGCOPY,\@prepro,$calc,$operandes,$direction,@d);
}

#private functions

sub preprocess
{
	my($refBIGCOPY,$refprepro,$calc,$operandes,$direction,@d)=@_;
	my($i,$j)=(0,0);
	
	my(@vector)=ArrayDir::init($direction,$operandes,@d);
		
	# Filling prepro with zeros
	if($#d==0)
	{
		for($i=0;$i<$d[0];$i++)
		{
			$$refprepro[$i]=1;
		}
	}
	else
	{
		for($i=0;$i<$d[0];$i++)
		{
			for($j=0;$j<$d[1];$j++)
			{
				$$refprepro[$i][$j]=1;
			}
		}
	}
	
	# PREPRO
	if($#d==0)
	{
		my($stop_index,$factor,@point)=ArrayDir::iteration();
		if($calc eq 'x')
		{
			for($i=0;$i<=$#{$refBIGCOPY};$i++)
			{
				#When zeros, cancel multiplication
				if($$refBIGCOPY[$i]==0)
				{
					for($j=$i;($i-$j)<$operandes;$j--)
					{
						if($j>=0)
						{
							$$refprepro[$i]=0;
						}
					}	
				}
				#When out of prepro, cancel
				if($i>=$stop_index)
				{
					$$refprepro[$i]=0;
				}
			}
		}
		
		# Up/down rule
		for($i=1;$i<$stop_index;$i++)
		{
			if($$refprepro[$i]==0)
			{
				next;
			}
			
			if($$refBIGCOPY[$i-1]>=$$refBIGCOPY[$i+4])
			{
				$$refprepro[$i]=0;
			}
			else
			{
				$$refprepro[$i-1]=0;
			}
			
		}
	}
	else
	{
		my($stop_index,$factor,@point)=ArrayDir::iteration();
		if($calc eq 'x')
		{
			while($stop_index!=-1)
			{
				for($i=0;$i<($stop_index+$factor-1);$i++)
				{
					#When zeros, cancel multiplication
					my(@p)=translate(\@point,\@vector,$i);
					
					if($$refBIGCOPY[$p[0]][$p[1]]==0)
					{
						for($j=$i;($i-$j)<$operandes;$j--)
						{
							if($j>=0)
							{
								my(@p2)=translate(\@point,\@vector,$i);
								$$refprepro[$p2[0]][$p2[1]]=0;
							}
						}	
					}
					#When out of prepro, cancel
					if($i>=$stop_index)
					{
						$$refprepro[$p[0]][$p[1]]=0;
					}
				}
				($stop_index,$factor,@point)=ArrayDir::iteration();
			}
			
			
		}
		
		ArrayDir::reset();
		# Up/down rule
		($stop_index,$factor,@point)=ArrayDir::iteration();
		while($stop_index!=-1)
		{
			for($i=1;$i<$stop_index;$i++)
			{
				my(@p)=translate(\@point,\@vector,$i);
				
				if($$refprepro[$p[0]][$p[1]]==0)
				{
					next;
				}
				
				my(@pm1)=translate(\@point,\@vector,$i-1);
				my(@ppf)=translate(\@point,\@vector,$i+$factor-1);
				if( $$refBIGCOPY[$pm1[0]][$pm1[1]] >= $$refBIGCOPY[$ppf[0]][$ppf[1]] )
				{
					$$refprepro[$p[0]][$p[1]]=0;
				}
				else
				{
					$$refprepro[$pm1[0]][$pm1[1]]=0;
				}
			}
			($stop_index,$factor,@point)=ArrayDir::iteration();
		}
		
	}
}

sub process
{
	my($refBIGCOPY,$refprepro,$calc,$operandes,$direction,@d)=@_;
	my(@vector)=ArrayDir::init($direction,$operandes,@d);
	my($i,$j)=(0,0);
	my($max)=0;
	if($#d==0)
	{
		my($stop_index,$factor,@point)=ArrayDir::iteration();
		for($i=0;$i<$stop_index;$i++)
		{
			if($$refprepro[$i]!=0)
			{
				if($calc eq 'x')
				{
					$max = max( $max, $$refBIGCOPY[$i]*$$refBIGCOPY[$i+1]*$$refBIGCOPY[$i+2]*$$refBIGCOPY[$i+3]*$$refBIGCOPY[$i+4]);
				}
			}
		}
	}
	else
	{
		my($stop_index,$factor,@point)=ArrayDir::iteration();
		while($stop_index!=-1)
		{
			for($i=0;$i<$stop_index;$i++)
			{
				my(@p)=translate(\@point,\@vector,$i);
				if($$refprepro[$p[0]][$p[1]]!=0)
				{
					my($m)=$$refBIGCOPY[$p[0]][$p[1]];
					for($j=1;$j<$factor;$j++)
					{
						my(@pp)=translate(\@point,\@vector,$j+$i);
						if($calc eq 'x')
						{
							$m*=$$refBIGCOPY[$pp[0]][$pp[1]];
						}
					}
					$max = max( $max, $m);
				}
			}
			($stop_index,$factor,@point)=ArrayDir::iteration();
		}
	}
	return $max;
}

sub fill_undef
{
	my($reftab,$calc)=@_;
	my($value)=($calc eq "x")?1:0;
	if($dim==1)
	{
		return ($#{$reftab}+1);
	}
	my($i,$j)=(0,0);
	my($max)=-1;
	for($i=0;$i<$#{$reftab};$i++)
	{
		if($max<$#{$$reftab[$i]})
		{
			$max=$#{$$reftab[$i]};
		}
	}
	for($i=0;$i<$#{$reftab};$i++)
	{
		for($j=$#{$$reftab[$i]}+1;$j<$max;$j++)
		{
			$$reftab[$i][$j]=$value;
		}
	}
	return ($#{$reftab}+1,$max+1);
}

sub translate
{
	my($refpoint,$refvect,$index)=@_;
	return ($$refpoint[0]+$index*$$refvect[0],$$refpoint[1]+$index*$$refvect[1]);
}

1;