use strict;
use warnings;
use Test::More tests => 2;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
use FindBin;
use File::Copy;

print "****TEST MOCKED BETEXPLORER DOWNLOADER*****\n\n"; 

#todo: mock isn't enough close to real implementation creating javascripts isn't mocked 

my $xpath = "";
my $bookMakerOfferDownloader_path = $ENV{BACKEND_ROOT_DIRECTORY}. "/BookmakerOfferDownloader"; 
my $correctBookmakerSelectorFile = "${bookMakerOfferDownloader_path}/input/parameters/examples/ekstraklasaSelector.xml";

my $theMockedBookMakerDownloader =  BetExplorerDownloader->new('--mockednet'); 
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 
my $resultXMLFileWithDownloadedData = "output/downloadedPolandEkstraklasa_mockednet.xml";


if(-e $resultXMLFileWithDownloadedData)
{
	unlink $resultXMLFileWithDownloadedData or  die $?; 
}


$theMockedBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile);
$theMockedBookMakerDownloader->prepareTemplateFor_SportEventsFile($resultXMLFileWithDownloadedData); #this should be inside createEventListXML
$theMockedBookMakerDownloader->createEventListXML($xpath, $resultXMLFileWithDownloadedData);
my $isCreateEventListXMLCorrect = $aBookmakerXmlDataParser->isCorrectEventListFile($resultXMLFileWithDownloadedData); 
ok($isCreateEventListXMLCorrect, "Mocked net stage 1: Creating event list xml") or die;

#checking mechanism stage  filling up bookmaker offer  data concerning events(online/not mocked version)
$theMockedBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"
$theMockedBookMakerDownloader->create_BookmakersOfferFile($resultXMLFileWithDownloadedData);

my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($resultXMLFileWithDownloadedData);
ok($isCorectBookmakerOfferFile, "Mocked net stage 2: Pulling bookmakers offer ") or die; 



#test run mode to consider 1.debug, 2.run all  3.stop on first 4.Categorize tests
#todo: add to the desing a picture describing stages of creating output xml
#testing script should check partial corectness first	
#todo: run only specific tests using their id's
#todo: think about enwrap test in some class which will store also test properties

