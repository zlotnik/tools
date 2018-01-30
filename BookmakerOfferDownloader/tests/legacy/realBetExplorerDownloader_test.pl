use strict;
use warnings;
use Test::More tests => 2;
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
my $resultXMLFileWithDownloadedData = "output/downloadedPolandEkstraklasa_realnet.xml";


if(-e $resultXMLFileWithDownloadedData)
{
	unlink $resultXMLFileWithDownloadedData or  die $?; 
}


$theRealBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile);
$theRealBookMakerDownloader->prepareTemplateForXmlFileWithResults($resultXMLFileWithDownloadedData);
$theRealBookMakerDownloader->createEventListXML($xpath, $resultXMLFileWithDownloadedData);
my $isCreateEventListXMLCorrect = $aBookmakerXmlDataParser->isCorrectEventListFile($resultXMLFileWithDownloadedData); 
ok($isCreateEventListXMLCorrect, "Real net stage 1: Creating event list xml: $resultXMLFileWithDownloadedData") or die;


#checking mechanism stage  filling up bookmaker offer  data concerning events(online/not mocked version)
$theRealBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"
copy $correctBookmakerSelectorFile, $resultXMLFileWithDownloadedData or die $?; #does it needed?
$theRealBookMakerDownloader->pullBookmakersOffer($resultXMLFileWithDownloadedData);

my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($resultXMLFileWithDownloadedData);
ok($isCorectBookmakerOfferFile, "Real net stage 2: Pulling bookmakers offer ") or die; 


#test run mode to consider 1.debug, 2.run all  3.stop on first 4.Categorize tests
#todo: add to the desing a picture describing stages of creating output xml
#testing script should check partial corectness first	

#maybe it is a time to think about find out some real parsers

#todo: run only specific tests using their id's
#todo: think about enwrap test in some class which will store also test properties
