#!/bin/perl

sub randomSecond_Delay($$);
my @selectorFiles = <input/*.xml>;

my $delayInSeconds_from;
my $delayInSeconds_to;
if(defined $ARGV[0])
{
	if($ARGV[0] =~ /--delay=(\d+)\.\.(\d+)/ )
	{
		$delayInSeconds_from = $1;
		$delayInSeconds_to = $2; 
	}
	else 
	{
		print "WARNING incorrect argument\n"
	}
}


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

	if(defined $delayInSeconds_from)
	{
		randomSecond_Delay($delayInSeconds_from, $delayInSeconds_to);
	}
	
	my $commandToExecute = "./surebetCrafter.sh $selectorFileName $outputFilePath";  
	(system($commandToExecute) == 0) or die $!;	
}


sub randomSecond_Delay($$)
{
	my ($from, $to) = @_;
	my $delay = int(rand($to)) + $from;
	sleep($delay);
}
