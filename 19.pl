use strict;
use warnings;
use Data::Dumper;

my(@month_length)=(31,28,31,30,31,30,31,31,30,31,30,31);
my(@offset)=calc_offsets(@month_length,0);
my(@offset_leap)=calc_offsets(@month_length,1);

my($first_year)=1901;
my($until_year)=2001;

my($mult_28_years)=int(($until_year-$first_year)/28);
my($years_left)=($until_year-$first_year)%28;

#Monday:0 -> Sunday:6
my($first_day)=1;
my($target_day)=6;


my($a,$b);
my($sum)=$mult_28_years*12*4;
for($a=0;$a<12;$a++)
{
  my(@seq)=start_of_month_sequence($first_day,$a,\@offset,\@offset_leap);
  for($b=0;$b<$years_left;$b++)
  {
    if($seq[$b]==$target_day)
    {
      $sum++;
    }
  }
}

print $sum;

sub calc_offsets
{
  my(@months)=@_;
  my(@ret)=(0);
  my($i);
  for($i=0;$i<($#months-1);$i++)
  {
    push(@ret,$ret[$i]+$months[$i]+(($i==1)?$months[-1]:0));
  }
  return @ret;
}

sub start_of_month_sequence
{
  my($first_day,$month,$roffsets,$roffsets_leap)=@_;
  my(@sequence)=();
  my($i);
  for($i=1;$i<=28;$i++)
  {
    if(($i%4)==0)
    {
      push(@sequence,($first_day+$$roffsets_leap[$month])%7);
      $first_day+=2;
    }
    else
    {  
      push(@sequence,($first_day+$$roffsets[$month])%7);
      $first_day++;
    }    
  }
  return @sequence;
}