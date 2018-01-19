use strict;
use warnings;

use LWP::Simple ();

sub get($);
sub showUsage();

if ($#ARGV == 0 )
{
	my ($urlToDownload) = @ARGV;
	get($urlToDownload);
}
else
{
	showUsage();
}


sub get($)
{
	my ($linkToGet) = @_;

	print LWP::Simple::get($linkToGet) or die "unable to get $linkToGet";  
};

sub showUsage()
{
	print "You must specify url to download"

}