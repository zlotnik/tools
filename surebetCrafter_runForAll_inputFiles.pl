#!/bin/perl

my @selectorFiles = <input/*.xml>;
foreach(@selectorFiles)
{
	my $selectorFileName = $_;
	$selectorFileName =~ /[\\\/](\w+)\.xml/;

	my $outputFileName = "results/". $1 . '_profitability.xml';

	my $commandToExecute = "./surebetCrafter.sh $selectorFileName $outputFileName";  
	(system($commandToExecute) == 0) or die $!;
	#`$commandToExecute`;die $commandToExecute;
}
