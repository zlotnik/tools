use strict;
use warnings;

use LWP::Simple ();

sub get($$);
sub showUsage();

if ($#ARGV == 1 )
{
	my ($urlToDownload, $outputFile) = @ARGV;
	get($urlToDownload, $outputFile);
}
else
{
	showUsage();
}


sub get($$)
{
	my ($linkToGet, $outputFile) = @_;

	my $downloadedHtml =  LWP::Simple::get($linkToGet) or die "unable to get $linkToGet";  
	my $outputHtml_FH;
	open $outputHtml_FH, '>', $outputFile or die;   
	
	print $outputHtml_FH $downloadedHtml;
	close $outputHtml_FH or die;
	
};

sub showUsage()
{
	print "You must specify url to download"

}