#!/usr/bin/perl -w
use strict;
use warnings;
use SurebetFinder;

########################SUBS DECLARATIONS###############
sub checkProgramArguments();
sub showUsage();



########################MAIN###############
if(!checkProgramArguments())
{
	showUsage();
	die;
}

my ($bookmakerOfferFilename, $surebetsFile) = @ARGV;
my $theSurebetFinder = SurebetFinder->new();

#todo here should be copying bookmaker offer file from a lopcation inside BetExplorerDownloader

$theSurebetFinder->loadBookmakersOfferFile($bookmakerOfferFilename);
$theSurebetFinder->generateSurebetsFile($surebetsFile);



#######################SUBS DEFINITIONS#################
sub checkProgramArguments()
{
	if ($#ARGV == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
};


sub showUsage()
{
	open my $usageFile_FH , '<', 'design/usage.txt' or die;

	{
		local $/ = undef;
		print <$usageFile_FH>;
	}
	
	close $usageFile_FH or die;
}
	
	
