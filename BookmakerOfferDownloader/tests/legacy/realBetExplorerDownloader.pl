use strict;
use warnings;
use Test::More tests => 1;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
use FindBin;
use File::Copy;

print "****TEST REAL BETEXPLORER DOWNLOADER*****\n\n"; 

my $xpath = "";
my $correctBookmakerSelectorFile = "$FindBin::Bin/../../input/parameters/examples/ekstraklasaSelector.xml";

my $theRealBookMakerDownloader =  BetExplorerDownloader->new('--realnet'); 
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 
my $resultXMLFileWithDownloadedData = "output/downloadedPolandEkstraklasa.xml";


if(-e $resultXMLFileWithDownloadedData)
{
	unlink $resultXMLFileWithDownloadedData or  die $?; 
}


$theRealBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile);
$theRealBookMakerDownloader->prepareTemplateForXmlFileWithResults($resultXMLFileWithDownloadedData);
$theRealBookMakerDownloader->createEventListXML($xpath, $resultXMLFileWithDownloadedData);
my $isCreateEventListXMLCorrect = $aBookmakerXmlDataParser->isEventListFileHasCorrectSyntax($resultXMLFileWithDownloadedData); 
ok($isCreateEventListXMLCorrect, "Creating event list xml on real net: $resultXMLFileWithDownloadedData") or die;


#TODO think about split tests
#nice would be to have some bin directory with tools eg. parsing file for comments others tools
#TODO nice would be to have hooks checking format of commits
#atest run mode to consider 1.debug, 2.run all  3.stop on first 4.Categorize tests
#todo: add to the desing a picture describing stages of creating output xml
#testing script should check partial corectness first	

#maybe it is a time to think about find out some real parsers

#todo: run only specific tests using their id's
#todo: think about enwrap test in some class which will store also test properties






