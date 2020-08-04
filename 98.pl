use strict;
use warnings;
use Data::Dumper;
use List::Util qw( max min );
use POSIX qw/floor ceil/;

open(FILE, "98_words.txt" ) or die "Cannot open file";
my($line)="";
my(@words)=();
while(defined($line=<FILE>))
{
  chomp($line);
  @words=split(/,/,$line);
}
close(FILE);

my(@words_classed)=();
for(my($i)=0;$i<=$#words;$i++)
{
  $words[$i]=~m/"(.*)"/; 
  my($length)=length($1);
  if( $length > $#words_classed )
  {
    for(my($l)=($#words_classed+1); $l<=$length;$l++)
    {
      $words_classed[$length] = [];  
    }
  }
  push(@{$words_classed[$length]},$1);
}

my($solution)="";

for( my($length)=$#words_classed; $length>=0; $length--)
{
  my(%anagrams)=();

  for(my($i)=0;$i<=$#{$words_classed[$length]};$i++)
  {
    add_in_anagrams( \%anagrams, $words_classed[$length][$i] );
  }
  delete_singletons( \%anagrams );
  if( ! keys(%anagrams))
  {
    next;
  }
  
  my(%anagrams_squares)=();
  my($first_root)= ceil ( sqrt( 10**($length-1)) );
  my($last_root) = floor( sqrt( 10** $length   ) );
  for(my($i)=$first_root;$i<=$last_root;$i++)
  {
    add_in_anagrams( \%anagrams_squares, $i*$i );
  }
  delete_singletons( \%anagrams_squares );
  
  my( %anagrams_indexed )= build_anagram_hash_inedxed(\%anagrams ) ;
  my( %anagrams_squares_indexed )= build_anagram_hash_inedxed(\%anagrams_squares);
  
  my($rmatched)=try_matching_dictionaries( \%anagrams_indexed, \%anagrams_squares_indexed );
  if( $#$rmatched >= 0 )
  {
    $solution = select_highest_square($rmatched);
    last;
  }
}
print $solution;

sub select_highest_square
{
  my($rmatched)=@_;
  my($max)=-1;
  for(my($i)=0;$i<=$#$rmatched;$i++)
  {
    for(my($j)=0;$j<=$#{$$rmatched[$i][2]};$j++)
    {
      $max = max( $max, $$rmatched[$i][2][$j][0], $$rmatched[$i][2][$j][1] );
    }
  }
  return $max;
}

sub add_in_anagrams
{
  my($ranagrams,$word)=@_;
  
  my(@letters_sorted)=sort(split(//,$word));
  my($key_in_anagram)=join("",@letters_sorted);
  create_or_push_array_in_ref($ranagrams,$key_in_anagram,$word );
}

sub delete_singletons
{
  my($rhash)=@_;
  my($k);
  foreach $k (keys(%$rhash))
  {
    if( $#{$$rhash{$k}} == 0 )
    {
      delete $$rhash{$k};
    }
  }
}


sub format_with_indexes
{
  my($input_key)=@_;
  my(@char_array)=split(//,$input_key);
  my(%occurences)=();
  for(my($i)=0;$i<=$#char_array;$i++)
  {
    if( !exists($occurences{ $char_array[$i]}))
    {
      $occurences{ $char_array[$i]} = 1;
    }
    else
    {
      $occurences{ $char_array[$i]} ++;
    }
  }
  my(@sorted_occurences)=sort( { $occurences{$b} <=> $occurences{$a} } keys(%occurences) );
  my($idexes_string)="";
  my($current_occurence)=0;
  for(my($i)=0;$i<=$#sorted_occurences;)
  {
    $idexes_string.=$i;
    $current_occurence++;
    if( $occurences{ $sorted_occurences[$i] } == $current_occurence )
    {
      $current_occurence =0;
      $i++;
    }
  }
  return $idexes_string;
}

sub build_anagram_hash_inedxed
{
  my( $ranagrams ) = @_;

  my( %indexed_hash )=();
  my( @keys ) = keys(%$ranagrams);
  for(my($k)=0;$k<=$#keys;$k++)
  {
    my($formet_key)=format_with_indexes( $keys[$k] );
    create_or_push_array_in_ref(\%indexed_hash, $formet_key, $$ranagrams{$keys[$k]} );
  }
  return %indexed_hash;
}

sub create_or_push_array_in_ref
{
  my($rhash,$key,$ref)=@_;

  if(!exists($$rhash{$key}))
  {
    $$rhash{$key} = [ $ref ];  
  }
  else
  {
    push(@{$$rhash{$key}},$ref);
  }
}

sub try_matching_dictionaries
{
  my($rdico_smaller,$rdico_bigger)=@_;
  my($k);
  my( @all_succesfuls)=();
  foreach $k (keys( %$rdico_smaller ))
  {
    if( exists( $$rdico_bigger{$k} ) )
    {
      push( @all_succesfuls, try_matching_words(  $$rdico_smaller{$k}, $$rdico_bigger{$k}));
    }
  }
  return \@all_succesfuls;
}

sub try_matching_words
{
  my(  $rwords_few, $rwords_several )=@_;
  
  my( @successfuls) = ();
  for( my($set_few)=0;$set_few <= $#$rwords_few; $set_few++ )
  {
    my($set)= $$rwords_few[ $set_few ];
    for( my($w1)=0;$w1 < $#$set; $w1++ )
    {
      for( my($w2)=$w1+1;$w2 <= $#$set; $w2++ )
      {
        my($rmapping)= create_mapping( $$set[$w1], $$set[$w2] );
        my($ridenticals_w1)= locate_identicals( $$set[$w1]  );
        
        my($rsuccessful_mapped)=try_mapping_on_sets( $rmapping, $ridenticals_w1, $rwords_several );
        if( $#$rsuccessful_mapped >= 0 )
        {
          push( @successfuls, [ $$set[$w1], $$set[$w2] , $rsuccessful_mapped ] );
        }
      }
    }
  }
  return @successfuls;
}

sub create_mapping
{
  my($w1,$w2)=@_;
  my(@mapping)=();

  my(@reverse_mapping)=(); #Used only to be sure that identical characters in word2 are used only once
  
  my(@word1)=split(//,$w1);
  my(@word2)=split(//,$w2);
  ( $#word1 == $#word2 ) or die "Words are nor same length !\n";
  for( my($c)= 0; $c<= $#word1; $c++ )
  {
    my($char1)=$word1[$c];
    for( my($d)= 0; $d<= $#word2; $d++ )
    {
      if( defined( $reverse_mapping[ $d ] ))
      {
        next;
      }
      my($char2)= $word2[$d];
      if( $char1 eq $char2 )
      {
        $mapping[ $c ] = $d;
        $reverse_mapping[ $d ] = $c;
        last;
      }
    }
  }
  return \@mapping;
}

sub locate_identicals
{
  my($word)=@_;
  my(@letters)=split(//,$word);
  my(@identicals)=();
  for(my($i)=0;$i<=$#letters;$i++)
  {
    my($char)=$letters[$i];
    $letters[$i]="";
    my(@tab_identicals)=($i);
    for(my($j)=$i+1;$j<=$#letters;$j++)
    {
      if( $letters[$j] eq $char )
      {
        push( @tab_identicals, $j);
        $letters[$j]="";
      }
    }
    if( $#tab_identicals > 0)
    {
      push( @identicals, \@tab_identicals );
    }
  }
  return \@identicals;
}

sub try_mapping_on_sets
{
  my($rmapping, $ridenticals_w1,$rset_of_words)=@_;
  
  my( @successful_mapped )=();

  for( my($set_word)=0;$set_word <= $#$rset_of_words; $set_word++ )
  {
    my($set)= $$rset_of_words[ $set_word ];
    for( my($w1)=0;$w1 <= $#$set; $w1++ )
    {
      if( !has_identical_letters( $ridenticals_w1, $$set[$w1] ) )
      {
        next;
      }

      for( my($w2)=0;$w2 <= $#$set; $w2++ )
      {
        if( $w1 == $w2 )
        {
          next;
        }
        if( try_mapping_on_words( $rmapping, $$set[$w1], $$set[$w2] )  )
        {
          push( @successful_mapped, [ $$set[$w1], $$set[$w2] ] );
        }
      }
    }
  }
  return \@successful_mapped;
}

sub has_identical_letters
{
  my($ridenticals,$word)=@_;
  for(my($i)=0;$i<=$#$ridenticals;$i++)
  {
    my($base_char)=substr( $word, $$ridenticals[$i][0], 1);
    for( my($j)= 1;$j<=$#{ $$ridenticals[$i]}; $j++ )
    {
      if( substr( $word, $$ridenticals[$i][$j], 1) ne $base_char)
      {
        return 0;
      }
    }
  }
  return 1;
}

sub try_mapping_on_words
{
  my($rmapping, $word1, $word2)=@_;
  for( my($i)=0;$i<=$#$rmapping; $i++ )
  {
    if( (substr( $word1, $i, 1) ne substr( $word2, $$rmapping[$i], 1)) )
    {
      return 0;
    }
  }
  return 1;
}
