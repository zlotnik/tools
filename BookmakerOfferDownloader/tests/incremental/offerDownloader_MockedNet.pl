use strict;
use warnings;
use Test::More tests => 6;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
use FindBin;
use File::Copy;

my $correctBookmakerSelectorFile = "$FindBin::Bin/../../input/parameters/examples/ekstraklasaSelector.xml";
my $correctDownloadedBookmakerOfferFile = "$FindBin::Bin/../../output/example/downloadedBookMakersOffer.xml";
my $correctBookmakerEventList = "$FindBin::Bin/../../output/example/downloadedEventList.xml";
my $mockedRawDataPath = "$FindBin::Bin/../../tmp/rawDataMockFile";

my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 
my $theMockBookMakerDownloader =  BetExplorerDownloader->new('--mockednet'); 


my $resultXMLFileWithDownloadedData = "output/downloadedPolandEkstraklasa_mockednet.xml";

my $xmlParser = XML::LibXML->new;
copy $correctBookmakerSelectorFile, $resultXMLFileWithDownloadedData or die $?; #does it needed?

my $xmlDocWithDownloadedData = $xmlParser->parse_file($correctBookmakerSelectorFile);
my $xpath = "";

my @rootXmlNode = $xmlDocWithDownloadedData->findnodes("/");	


#checking mechanism stage  filling up bookmaker offer  data concerning events(online/not mocked version)
$theMockBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"

copy $correctBookmakerSelectorFile, $resultXMLFileWithDownloadedData or die $?; #does it needed?
$theMockBookMakerDownloader->pullBookmakersOffer($resultXMLFileWithDownloadedData);

my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($resultXMLFileWithDownloadedData);
ok($isCorectBookmakerOfferFile, "Stage 2 with mock net: Pulling bookmaker offer ") or die $/; 

#TODO think about split tests
#nice would be to have some bin directory with tools eg. parsing file for comments others tools
#TODO nice would be to have hooks checking format of commits
#atest run mode to consider 1.debug, 2.run all  3.stop on first 4.Categorize tests
#todo: add to the desing a picture describing stages of creating output xml
#testing script should check partial corectness first	

#maybe it is a time to think about find out some real parsers

#todo: run only specific tests using their id's
#todo: think about enwrap test in some class which will store also test properties






