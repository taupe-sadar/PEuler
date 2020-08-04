package Words;

sub get_words
{
  my($refwords,$file)=@_;
  open FILE, $file or die "$file not found";
  my($line)="";
  if(defined($line=<FILE>)) 
  {
    chomp($line);
    @{$refwords}=split(/,/,$line);
  }
  my($i);
  for($i=0;$i<=$#{$refwords};$i++)
  {
    $$refwords[$i]=~s/"(.*)"/$1/
  }
  close(FILE);
}

sub score
{
  my($string)=@_;
  my(@t)=split(//,uc($string));
  my($sum)=0;
  my($a);
  for($a=0;$a<=$#t;$a++)
  {
    $sum+=ord($t[$a])-ord('A')+1;
  }
  return $sum;
}

1;
