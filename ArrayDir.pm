package ArrayDir;
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );

our($index)=-1;
our(@stop_index)=();
our(@tab_points)=();
our(@factors)=();
our($dim)=0;

sub init
{
	my($direction,$operandes,@d)=@_;
	{
		if($#d==0)
		{
			$dim=1;
			$index=-1;
			@stop_index=($d[0]-$operandes+1);
			@tab_points=(0);
			@factors=($operandes);
			return (1);
		}
		elsif($#d>0)
		{
			$dim=2;
			$index=-1;
			@stop_index=();
			@tab_points=();
			@factors=();
			my($i)=0;
				
			if($direction eq '-')
			{
				for($i=0;$i<$d[1];$i++)
				{
					$factors[$i]=$operandes;
					$stop_index[$i]=$d[0]-$operandes+1;
					my(@point)=(0,$i);
					push(@tab_points,\@point);
				}
				return (1,0);
			}
			elsif($direction eq '|')
			{
				for($i=0;$i<$d[0];$i++)
				{
					$factors[$i]=$operandes;
					$stop_index[$i]=$d[1]-$operandes+1;
					my(@point)=($i,0);
					push(@tab_points,\@point);
				}
				return (0,1);
			}
			elsif($direction eq '/')
			{
				for($i=0;$i<($d[1]-1);$i++)
				{
					$factors[$i]=min($i+1,$operandes);
					$stop_index[$i]=max(1,min($i+1-$operandes,$d[0]-$operandes+1)); 
					my(@point)=(0,$i);
					push(@tab_points,\@point);
				}
				for($i=0;$i<$d[0];$i++)
				{
					$factors[$d[1]-1+$i]=min($d[0]-$i,$operandes);
					$stop_index[$d[1]-1+$i]=max(1,min($d[1]-$operandes+1,$d[0]-$operandes+1-$i)); 
					my(@point)=($i,$d[1]-$operandes);
					push(@tab_points,\@point);
				}
				return (1,-1);
			}
			elsif($direction eq '\\') 
			{
				for($i=0;$i<$d[1];$i++)
				{
					$factors[$i]=min($d[1]-$i,$operandes);
					$stop_index[$i]=max(1,min($d[1]-$operandes+1-$i,$d[0]-$operandes+1)); 
					my(@point)=(0,$i);
					push(@tab_points,\@point);
				}
				for($i=1;$i<$d[0];$i++)
				{
					$factors[$d[1]-1+$i]=min($d[0]-$i,$operandes);
					$stop_index[$d[1]-1+$i]=max(1,min($d[0]-$operandes+1,$d[1]-$operandes+1-$i)); 
					my(@point)=($i,0);
					push(@tab_points,\@point);
				}
				return (1,1);
			}
			else
			{
				die "Unknown direction $direction";
			}
		}
	}
	
}

sub iteration
{
	
	$index++;
	if($index>$#stop_index)
	{
		return (-1,-1,-1);
	}
	else
	{
		my($stop,$factor,@point)=();
		if($dim==1)
		{
			return ($stop_index[$index],$factors[$index]);
		}
		else
		{
			return ($stop_index[$index],$factors[$index],@{$tab_points[$index]})
		}
	}
}

sub reset
{
	$index=-1;
}
1;