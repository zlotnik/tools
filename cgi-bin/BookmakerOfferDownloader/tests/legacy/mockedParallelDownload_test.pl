use strict;
use warnings;
#use Test::More tests => 1;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
use FindBin;
use File::Copy;
use Test::More;


my $testSuiteName = "PARALLEL DOWNLOAD TEST MOCKED NET";

print "****TEST SUITE NAME: $testSuiteName****\n\n"; 

sub runParallelOfferDownloadTest(\@\@);
sub downloadOffer($$);

	
my @childrensPIDs;	
my @listOfInputFiles = (
						"$FindBin::Bin/../../input/parameters/examples/ekstraklasaSelector.xml",
						"$FindBin::Bin/../../input/parameters/examples/qatarSelector.xml"
						);

my @listOfOutputFiles = (
						"output/downloadedParallelPoland_mockednet.xml",
						"output/downloadedParallelQatar_mockednet.xml"
						);						

runParallelOfferDownloadTest(@listOfInputFiles, @listOfOutputFiles);

sub runParallelOfferDownloadTest(\@\@)
{
	my @listOfInputFiles = @{$_[0]};

	my @listOfOutputFiles = @{$_[1]}; 

	my $idx =0;
	foreach(@listOfInputFiles)
	{
		my $selectorFile = $_;
		my $pidOfFirstChild = fork();
		my $outputfile = $listOfOutputFiles[$idx];
		
		push(@childrensPIDs, $pidOfFirstChild);
		my $isChildProcess = (not $pidOfFirstChild);  
		if($isChildProcess)
		{
			downloadOffer( $selectorFile, $outputfile);
			done_testing(1);		
			exit 0;
		}
		$idx++;
	}	

	foreach(@childrensPIDs)
	{
		my $childPID = $_;
		waitpid($childPID, 0 )

	}
	
}

sub downloadOffer($$)
{
    my ($correctBookmakerSelectorFile, $resultXMLFileWithDownloadedData) = @_;  
	

	my $theMockedBookMakerDownloader =  BetExplorerDownloader->new('--mockednet'); 
	my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 


	if(-e $resultXMLFileWithDownloadedData)
	{
		unlink $resultXMLFileWithDownloadedData or  die $?; 
	}

	#checking mechanism stage  filling up bookmaker offer  data concerning events(online/not mocked version)
	$theMockedBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"
	copy $correctBookmakerSelectorFile, $resultXMLFileWithDownloadedData or die $?; #does it needed?
	$theMockedBookMakerDownloader->pullBookmakersOffer($resultXMLFileWithDownloadedData);

	my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($resultXMLFileWithDownloadedData);
	ok($isCorectBookmakerOfferFile, "Mocked net stage parallel pulling bookmakers offer input file $correctBookmakerSelectorFile") or die; 

}


#test run mode to consider 1.debug, 2.run all  3.stop on first 4.Categorize tests
#todo: add to the desing a picture describing stages of creating output xml
#testing script should check partial corectness first	
#todo: run only specific tests using their id's
#todo: think about enwrap test in some class which will store also test properties

