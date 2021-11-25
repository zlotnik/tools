use strict;
use warnings;


sub transcriptSingleWord($);
sub eng_to_ipa($$);
sub transcriptWords(\@);
sub saveToFile(\@$);
sub extractTranscriptionOnly($);
sub splitToWords($);

my ( $inputFilename, $outputFilename ) = @ARGV ; 


$#ARGV == 1 or die; 


#print transcriptSingleWord('even');
#my @listOfWords =  ('even', 'single');
#print transcriptWords( @listOfWords );
#exit;
eng_to_ipa( $inputFilename, $outputFilename );

sub eng_to_ipa($$)
{

	my ( $inputFileName, $outputFileName ) = @_;

	open (my $inputFH, '<', $inputFileName ) or die;
	unlink $outputFileName;


	while( <$inputFH> )
	{
		my $lineToTranscript = $_;
		my @words = splitToWords($lineToTranscript);
		my @transcribedWords = transcriptWords( @words );
		saveToFile(@transcribedWords, $outputFileName );
	}

	close $inputFH or die;

};

sub splitToWords($)
{
	my ($lineToTranscript) = @_;

	my @words = split(/ /, $lineToTranscript );
	return @words;


}

sub transcriptWords(\@)
{
	my ( $wordsToTranscript_ref ) = @_;
	my @wordsToTranscript = @{ $wordsToTranscript_ref };

	my @transcribedWords = (); 
	foreach( @wordsToTranscript )
	{
		my $wordToTranscript = $_;


		my $singleTranscribedWord = transcriptSingleWord( $wordToTranscript );
		push (@transcribedWords, $singleTranscribedWord);
	}
	
	return @transcribedWords;


};

sub saveToFile(\@$)
{
	my ( $lineToSave_ref, $outputFileName ) = @_;
	my @lineToSave = @{ $lineToSave_ref };

	open (my $outputFH, '>>', $outputFileName  ) or die;

	foreach( @lineToSave )
	{
		my $singleWord = $_;
		print $outputFH $singleWord." ";
	
	}

	print $outputFH "\n";

	close $outputFH or die;

}

sub transcriptSingleWord($)
{
	my ( $wordToTrascript) = @_;

	$wordToTrascript = lc( $wordToTrascript);
	chomp($wordToTrascript);
	$wordToTrascript =~ s/,//;
	$wordToTrascript =~ s/\.//;

	my $commandToDownloadSite = "curl https://dictionary.cambridge.org/dictionary/english/${wordToTrascript} 2>/dev/null";
	my $downladedSite = `$commandToDownloadSite`;

	if ( $downladedSite =~ /<span class="ipa dipa lpr-2 lpl-1">(.*?)(<span class="us)/ )
	{
		my $polutedTranscription = $1;
		my $transcription = extractTranscriptionOnly( $polutedTranscription );
		return $transcription;
	}
	else
	{
		return $wordToTrascript;
	}
	

}

sub extractTranscriptionOnly($)
{
	my ( $polutedTranscription ) = @_;
	$polutedTranscription =~ s!</span>!!g;
	$polutedTranscription =~ s!<span class.*>!!g;
	$polutedTranscription =~ s!/!!g;
	$polutedTranscription =~ s! !!g;

	return $polutedTranscription;


}
