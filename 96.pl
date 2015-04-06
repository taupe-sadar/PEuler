use strict;
use warnings;
use Data::Dumper;
use FileHandle;
use IPC::Open2;

my( $OS ) = "win32";
my( $sudoku_command ) ="";
if( $OS ne "win32" )
{
  $sudoku_command = "sudoku.exe";
}
else
{
  $sudoku_command ="./sudoku";
}

open(SUDOKUS, "96_sudoku.txt") or die "cannot open file";
my($line)="";
my($sudoku_number)=-1;
my($input_string)="";
my($output_sum)=0;
my($count_rows)=0;
my($grid_number)=-1;
while(defined($line = <SUDOKUS>))
{
    chomp($line);
    if($line =~ m/Grid (\d+)$/)
    {
	$input_string = "";
	$count_rows = 0;
	$grid_number = $1;
	next;
    }
    elsif( $line =~ m/^\d+$/)
    {
	$input_string.= "$line\n";
	$count_rows++;
    }
    else
    {
	die "Unrecognized line $line.";
    }
    
    if( $count_rows == 9)
    {
	my($resolved_string) = recursive_solve_sudoku( $input_string );
	$resolved_string ne "" or die "Impossible sudoku :\n$input_string";
	$resolved_string =~m/^(\d{3})/ or die "unexcepted result $resolved_string";
	$output_sum += $1;
    }
}
close(SUDOKUS);

print $output_sum;

sub recursive_solve_sudoku
{
    my($input)= @_;
    

    my($exit_status, $solution, $rcandidats) = run_process_sudoku( $input );
    my( $ret )="";
    
    if( $exit_status == 0 )
    {
	$ret= $solution;
    }
    elsif( $exit_status == 1 )
    {
	$ret = "";
    }
    else #if( $exit_status == 2 )
    {
	#take an undetermined candidate idx, try a solution
	my(@ks)=keys(%$rcandidats);
	my(@candidats)=@{$$rcandidats{$ks[0]}};
	
	$ret= try_hypothetical_solutions( $input , $ks[0], @candidats );
    }
    
    
    return $ret;
}

sub try_hypothetical_solutions
{
    my($input , $idx, @candidats )=@_;
    my(@hypothetical_status)=();
    for( my($i)=0;$i<=$#candidats; $i++)
    {
	my($hypothetical_input)= replace_in_input($input, $idx, $candidats[$i]);
	my($solution) = recursive_solve_sudoku( $hypothetical_input );
	if( $solution ne "" )
	{
	    # Solution found !
	    return $solution;
	}
    }
    # Found only contradictions ...
    return "";
    
    
}
sub run_process_sudoku
{
    my($input)=@_;
    my($pid) = open2(*READER, *WRITER, $sudoku_command) or die "Problem in double pipe";
    print WRITER $input;    
    my($line) = "";
    my(%candidates_not_alone)=();
    my($solution)="";
    while(defined($line = <READER> ))
    {
    msys_chomp( \$line );
	my($idx,@candidats)=get_candidats( $line );
	if( $#candidats > 0 )
	{
	  $candidates_not_alone{ $idx } = \@candidats;
	}
	

	if( $#candidats == 0)
	{
	    $solution.= $candidats[0];
	}
	else
	{
	    $solution.="0";
	}
	
    }
    close( READER );
    close( WRITER );
    # Needed for void the process table
    waitpid( $pid, 0 );
    
    return ( $? >> 8, $solution,\%candidates_not_alone );

}

sub get_candidats
{
    my($suoku_binary_output)=@_;
    
    if( !($suoku_binary_output =~ m/^(\d+): (\d) \| (\d) \|\s*(\S.*|)$/))
    {
	die "Unrecognize regexp : $suoku_binary_output\n";
    }
    else
    {
	my( $idx, $nb_candidates, $string_candidates) = ($1,$3,$4);
	my(@cand_ret)=();
	if( $nb_candidates  > 0 )
	{
	    @cand_ret = split(/ /,$string_candidates);
	}

	    
	return ($idx,@cand_ret);
    }
    
}

sub replace_in_input
{
    my($input,$idx,$val)=@_;
    $input=~s/\s//m;
    my(@t)=split( //,$input);
    $t[$idx] = $val;
    return join("",@t);
}

sub msys_chomp
{
  my( $rline ) = @_;
  while( $$rline =~ m/^(.*)(\r|\n)$/ )
  {
    $$rline = $1;
  }
}