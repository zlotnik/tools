#!/usr/bin/perl -w
use strict;
use warnings;
use BetExplorerDownloader;
use ProfitabilityCalculator;
use File::Basename;
use Cwd;
use WojtekToolbox;
    

#SUBS DECLARATIONS
sub parseArguments();
sub printUsage();
sub printManual();
sub checkRunMode();
sub findSureBets($$);


###########MAIN#############
if( parseArguments() )
{
	my $runMode = checkRunMode();

	if($runMode eq 'SHOW_MANUAL_MODE')
	{
		printManual();
	}
	elsif($runMode eq 'FIND_SUREBET_MODE')
	{
		my $xmlSelectorFile = $ARGV[0];
		my $xmlResultFile = $ARGV[1];
		findSureBets($xmlSelectorFile, $xmlResultFile);
	}	
}
else
{
	printUsage();
}



#########SUBS DEFINITIONS##############
sub parseArguments()
{
	if ($#ARGV == -1)
	{
		return 0;
	}
	
	my $allProgramArguments = join(' ',@ARGV);
	
	if ($allProgramArguments =~ /^([\w\\\.\/]+) ([\w\\\.\/]+)$/)
	{
		return 1;
	}
	
	if ($allProgramArguments =~ /^--help$/)
	{
		return 2;
	}
	
	return 0;
	
	

};


sub printManual()
{

	my $manualFilePath = "docs/manual.txt";
	open my $fh_manual , "<", $manualFilePath or die "Can't open manual file at $manualFilePath"; 

	{
		local $/ = undef;
		print <$fh_manual>;
	}
	
	close $fh_manual or die;

}

sub printUsage()
{
	my $usageFile_path = "docs/usage.txt";
	open my $fh_usageFile , "<", $usageFile_path or die "Can't open usage filke at $usageFile_path";
	{
		local $/ = undef;
		print <$fh_usageFile>;
	}
	
	close $$fh_usageFile or die;
		
}

sub checkRunMode()
{
	if($#ARGV == 0)
	{
		return 'SHOW_MANUAL_MODE' 
	}
	elsif($#ARGV == 1)
	{
		return 'FIND_SUREBET_MODE'
	}

	die;
};

sub findSureBets($$)
{
	#todo bug when input and output i sthe same file
	#todo add to argument verification that we except only *.xml file
	my ($xmlSelectorFile , $xmlResultFile) = @_;
	
	my $theRealBookMakerDownloader =  BetExplorerDownloader->new('--realnet');
	$theRealBookMakerDownloader->loadSelectorFile( $xmlSelectorFile ); #temporary moved before "BookMakerDownloader->createEventListXML"
	$theRealBookMakerDownloader->set_OutputFile( $xmlResultFile  );
	$theRealBookMakerDownloader->create_BookmakersOfferFile( $xmlResultFile );

	my $theProfitabilityCalculator = ProfitabilityCalculator->new();
	$theProfitabilityCalculator->loadBookmakersOfferFile($xmlResultFile);
	$theProfitabilityCalculator->generateOfferProfitabilityFile($xmlResultFile);

};
