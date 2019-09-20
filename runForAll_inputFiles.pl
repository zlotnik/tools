#!/bin/perl

my @selectorFiles = <input/*.xml>;


($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $timeStamp = $year +1900 . $mon+1 . $mday . '_' . $hour . '_' . $min . '_' .$sec ;	

my $outputDirectory = "results/${timeStamp}";

mkdir $outputDirectory or die "Error during creating output directory $outputDirectory \nndToExecute"; 


foreach(@selectorFiles)
{
	my $selectorFileName = $_;

	$selectorFileName =~ /[\\\/](\w+)\.xml/;
	my $outputFileName_prefix = $1; 

	my $outputFilePath = "${outputDirectory}/${outputFileName_prefix}_profitability.xml";

	my $commandToExecute = "./surebetCrafter.sh $selectorFileName $outputFilePath";  
	(system($commandToExecute) == 0) or die $!;
	#`$commandToExecute`;die $commandToExecute;
}

