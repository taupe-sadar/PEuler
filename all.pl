use strict;
use warnings;
use Data::Dumper;

my(%skip_hash)=(
 44 => 1,
 60 => 1,
 146 => 1
);

my( %user_wanted ) = ();
my( $custom ) = 0;
for(my($i)=0;$i<=$#ARGV;$i++)
{
 if($ARGV[$i] =~m/^(\d+)$/)
 {
   $user_wanted{ $1 } = 1;
   $custom = 1;
 }
 else
 {
   die "$ARGV[$i] is not a number";
 }
}

opendir MYDIR, ".";
my(@contents) = readdir MYDIR;
closedir MYDIR;

my(@prev_results)=();
read_results(\@prev_results);

@contents = sort{ordre($a) <=> ordre($b)} @contents;

for(my($i)=0;$i<=$#contents;$i++)
{
  chomp($contents[$i]);
  if($contents[$i]=~m/^(\d+)\.pl$/)
  {
    my( $num_pb ) = "".sprintf('%3s',$1)." : ";
    
    if( $custom == 0 || exists($user_wanted{ $1 }))
    {
      if(exists($skip_hash{$1}))
      {
        print "${num_pb}Skipping\n";
        next;
      }
      
      my($value)=`perl $contents[$i]`;
      if(!defined($value))
      {
        $value="";
      }
      chomp($value);
      my($assert)=check_results($1,$value);
      print "$num_pb$value$assert\n";
    }
  }
}

sub ordre
{
  my($order)=@_;
  
  if($order=~m/^(\d+)\.pl$/)
  {
    return $1;
  }
  
  return -1;
}

sub read_results
{
  my($refresults)=@_;
  my(@lines)=();
  if(open RESULT, "results.txt")
  {
    @lines = <RESULT>;
    close RESULT;
  }
  my($i);
  for($i=0;$i<=$#lines;$i++)
  {
    if($lines[$i]=~m/^\s*(\d*)\s*:\s*((-|)(\d|[A-F]|,)*(\.\d*|))\s*$/)
    {
      $$refresults[$1]=$2;
    }
  }
}

sub check_results
{
  my($no,$output)=@_;
  if($output eq "")
  {
    return "";
  }
  if($output=~m/^\s*((-|)(\d|[A-F]|,)*(\.\d*|))\s*$/)
  {
    my($number)=$1;
    if(defined($prev_results[$no]))
    {
      if($prev_results[$no] eq $number)
      {
        return "";#OK meme valeur qu'avant
      }
      else
      {
        return " => Error : old value = $prev_results[$no]";
      }
    }
    else
    {
      open RESULT, ">> results.txt";
      print RESULT "".sprintf('%3s',$no)." : $number\n";
      return " => New value. Archiving ...";
    }
  }
  else
  {
    if(defined($prev_results[$no]))
    {
      return " => Error in script (Expected : $prev_results[$no])\n" ;
    }
    else
    {
      return " => Error in script\n" ;
    }
  }
}
