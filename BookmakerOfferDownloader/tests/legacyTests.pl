use strict;
use warnings;
use Test::More tests => 6;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
use DataDownloader; #needed??
use RealDataDownloader;
use MockedDataDownloader;
use FindBin;
use File::Copy;
#TODO think about split tests
#nice would be to have some bin directory with tools eg. parsing file for comments others tools
#TODO nice would be to have hooks checking format of commits
#atest run mode to consider 1.debug, 2.run all  3.stop on first 4.Categorize tests
#todo: add to the desing a picture describing stages of creating output xml
#testing script should check partial corectness first	

#maybe it is a time to think about find out some real parsers

#todo: run only specific tests using their id's
#todo: think about enwrap test in some class which will store also test properties


my $correctBookmakerSelectorFile = "$FindBin::Bin/../input/parameters/examples/ekstraklasaSelector.xml";
my $correctDownloadedBookmakerOfferFile = "$FindBin::Bin/../output/example/downloadedBookMakersOffer.xml";
my $correctBookmakerEventList = "$FindBin::Bin/../output/example/downloadedEventList.xml";
my $mockedRawDataPath = "$FindBin::Bin/../tmp/rawDataMockFile";

my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 
my $theMockedBookMakerDownloader =  BetExplorerDownloader->new('--mockednet'); 
my $theRealBookMakerDownloader =  BetExplorerDownloader->new('--realnet'); 

my $mockedDataDownloader =  MockedDataDownloader->new();
open ( MOCKEDRAWDATA , ">", $mockedRawDataPath) or die;

my $mockedRawData = $mockedDataDownloader->getRawDataOfEvent('');
print MOCKEDRAWDATA $mockedRawData or die;
close MOCKEDRAWDATA or die $!;

ok($aBookmakerXmlDataParser->isCorrectRawDataFile($mockedRawDataPath), 'Checking raw data parser' ) or die;

 

my $resultXMLFileWithDownloadedData = "output/downloadedPolandEkstraklasa.xml";



#checking parsers
(-e $correctBookmakerSelectorFile) or die "File doesn't exist $correctBookmakerSelectorFile\n";
ok($aBookmakerXmlDataParser->isCorectBookmakerDataSelectorFile($correctBookmakerSelectorFile),'Checking bookmaker data selector parser') or die;

(-e $correctDownloadedBookmakerOfferFile) or die "File doesn't exist $correctDownloadedBookmakerOfferFile\n";
ok($aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($correctDownloadedBookmakerOfferFile),'Checking bookmaker downloaded offert file parser')or die;

(-e $correctBookmakerEventList) or die "File doesn't exist $correctBookmakerEventList\n";
ok($aBookmakerXmlDataParser->isCorrectEventListFile($correctBookmakerEventList),'Checking bookmaker downloaded events list file parser');

my ($got, $expected, $testname);

if(-e $resultXMLFileWithDownloadedData)
{
	unlink $resultXMLFileWithDownloadedData or  die $?; 
}

my $xmlParser = XML::LibXML->new;
copy $correctBookmakerSelectorFile, $resultXMLFileWithDownloadedData or die $?; #does it needed?

my $xmlDocWithDownloadedData = $xmlParser->parse_file($correctBookmakerSelectorFile);
my $xpath = "";

my @rootXmlNode = $xmlDocWithDownloadedData->findnodes("/");	


#checking mechanism stage  creating Event list 1
$theMockedBookMakerDownloader->createEventListXML($xpath, $resultXMLFileWithDownloadedData);
$theMockedBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile);
my $isCreateEventListXMLCorrect = $aBookmakerXmlDataParser->isCorrectEventListFile($resultXMLFileWithDownloadedData); 
ok($isCreateEventListXMLCorrect, "Stage 1: Creating event list xml") or die;


#checking mechanism stage  filling up bookmaker offer  data concerning events(mocked version)
$theMockedBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"

#my $isOutputXmlFileExist = (-e $resultXMLFileWithDownloadedData);
#($got, $expected, $testname) = ($isOutputXmlFileExist, 1, "BookMakerDownloader->pullBookmakersOffer($resultXMLFileWithDownloadedData) mocked net");
#ok($isOutputXmlFileExist, "") or die;

$theMockedBookMakerDownloader->pullBookmakersOffer($resultXMLFileWithDownloadedData);
my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($resultXMLFileWithDownloadedData);
ok($isCorectBookmakerOfferFile, "Stage 2 with mocked net: Pulling bookmaker offer ") or die $/; 


#checking mechanism stage  filling up bookmaker offer  data concerning events(online/not mocked version)
$theRealBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"

copy $correctBookmakerSelectorFile, $resultXMLFileWithDownloadedData or die $?; #does it needed?
$theRealBookMakerDownloader->pullBookmakersOffer($resultXMLFileWithDownloadedData);

$isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($resultXMLFileWithDownloadedData);
ok($isCorectBookmakerOfferFile, "Stage 2 with real net: Pulling bookmaker offer ") or die $/; 






