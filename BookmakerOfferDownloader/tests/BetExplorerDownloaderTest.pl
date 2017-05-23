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

#maybe is a time to think about find out some real parsers

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
ok($aBookmakerXmlDataParser->isCorrectRawDataFile($mockedRawDataPath), 'mockedDataDownloader->getRawDataOfEvent' ) or die;

 

my $resulXMLtFileWithDownloadedData = "output/downloadedPolandEkstraklasa.xml";



#checking parsers
(-e $correctBookmakerSelectorFile) or die "File doesn't exist $correctBookmakerSelectorFile\n";
ok($aBookmakerXmlDataParser->isCorectBookmakerDataSelectorFile($correctBookmakerSelectorFile),'Checking bookmaker data selector parser') or die;

(-e $correctDownloadedBookmakerOfferFile) or die "File doesn't exist $correctDownloadedBookmakerOfferFile\n";
ok($aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($correctDownloadedBookmakerOfferFile),'Checking bookmaker downloaded offert file parser')or die;

(-e $correctBookmakerEventList) or die "File doesn't exist $correctBookmakerEventList\n";
ok($aBookmakerXmlDataParser->isCorrectEventListFile($correctBookmakerEventList),'Checking bookmaker downloaded events list file parser');

my ($got, $expected, $testname);

if(-e $resulXMLtFileWithDownloadedData)
{
	unlink $resulXMLtFileWithDownloadedData or  die $?; 
}

my $xmlParser = XML::LibXML->new;
copy $correctBookmakerSelectorFile, $resulXMLtFileWithDownloadedData or die $?; #does it needed?

my $xmlDocWithDownloadedData = $xmlParser->parse_file($correctBookmakerSelectorFile);
my $xpath = "";

my @rootXmlNode = $xmlDocWithDownloadedData->findnodes("/");	


#checking mechanism stage  creating Event list 1
$theMockedBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile);
$theMockedBookMakerDownloader->createEventListXML($xpath, $resulXMLtFileWithDownloadedData);
my $isCreateEventListXMLCorrect = $aBookmakerXmlDataParser->isCorrectEventListFile($resulXMLtFileWithDownloadedData); 
ok($isCreateEventListXMLCorrect, "BookMakerDownloader->createEventListXML") or die;


#checking mechanism stage  filling up bookmaker offer  data concerning events(mocked version)
$theMockedBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"
my $isOutputXmlFileExist = (-e $resulXMLtFileWithDownloadedData);
($got, $expected, $testname) = ($isOutputXmlFileExist, 1, "BookMakerDownloader->pullBookmakersOffer($resulXMLtFileWithDownloadedData) mocked net");
ok($isOutputXmlFileExist, $testname) or die;
$theMockedBookMakerDownloader->pullBookmakersOffer($resulXMLtFileWithDownloadedData);
my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($resulXMLtFileWithDownloadedData);
ok($got, $testname) or die "Output file with bookmaker offer $resulXMLtFileWithDownloadedData hasn't correct format "; 


#checking mechanism stage  filling up bookmaker offer  data concerning events(online/not mocked version)
$theRealBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"
$isOutputXmlFileExist = (-e $resulXMLtFileWithDownloadedData);
($got, $expected, $testname) = ($isOutputXmlFileExist, 1, "BookMakerDownloader->pullBookmakersOffer($resulXMLtFileWithDownloadedData) real net");
ok($isOutputXmlFileExist, $testname) or die;# this one is needed I suppose .. 
$theRealBookMakerDownloader->pullBookmakersOffer($resulXMLtFileWithDownloadedData);

my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($resulXMLtFileWithDownloadedData);
ok($got, $testname) or die "Output file with bookmaker offer $resulXMLtFileWithDownloadedData hasn't correct format "; 






