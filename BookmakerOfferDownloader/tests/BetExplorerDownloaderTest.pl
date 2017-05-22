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

 
#my $selectorFile = 'input/parameters/polandEkstraklasaSelector.xml';
my $outputFile = "output/downloadedPolandEkstraklasa.xml";

#BetExplorerDownloader::updateEventListXMLWithEventDetails('');


(-e $correctBookmakerSelectorFile) or die "File doesn't exist $correctBookmakerSelectorFile\n";
ok($aBookmakerXmlDataParser->isCorectBookmakerDataSelectorFile($correctBookmakerSelectorFile),'BookmakerXmlDataParser->isCorectBookmakerDataSelectorFile') or die;

(-e $correctDownloadedBookmakerOfferFile) or die "File doesn't exist $correctDownloadedBookmakerOfferFile\n";
ok($aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($correctDownloadedBookmakerOfferFile),'BookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile')or die;

(-e $correctBookmakerEventList) or die "File doesn't exist $correctBookmakerEventList\n";
ok($aBookmakerXmlDataParser->isCorrectEventListFile($correctBookmakerEventList),'BookmakerXmlDataParser->isCorrectEventListFile');

my ($got, $expected, $testname);

if(-e $outputFile)
{
	unlink $outputFile or  die $?; 
}

my $xmlParser = XML::LibXML->new;
copy $correctBookmakerSelectorFile, $outputFile or die $?; #does it needed?
my $doc = $xmlParser->parse_file($correctBookmakerSelectorFile);
my $xpath = "";

my @rootXmlNode = $doc->findnodes("/");	
#my $rootXmlNode = $doc->findnodes("/")[0]; maybe this is better		

$theMockedBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile);
$theMockedBookMakerDownloader->createEventListXML($xpath, $outputFile);

$theMockedBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"
my $isOutputXmlFileExist = (-e $outputFile);
($got, $expected, $testname) = ($isOutputXmlFileExist, 1, "BookMakerDownloader->pullBookmakersOffer($outputFile) mocked net");
ok($isOutputXmlFileExist, $testname) or die;
$theMockedBookMakerDownloader->pullBookmakersOffer($outputFile);



$theRealBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile); #temporary moved before "BookMakerDownloader->createEventListXML"
$isOutputXmlFileExist = (-e $outputFile);
($got, $expected, $testname) = ($isOutputXmlFileExist, 1, "BookMakerDownloader->pullBookmakersOffer($outputFile) real net");
ok($isOutputXmlFileExist, $testname) or die;
$theRealBookMakerDownloader->pullBookmakersOffer($outputFile);





my $isCreateEventListXMLCorrect = $aBookmakerXmlDataParser->isCorrectEventListFile($outputFile); 
ok($isCreateEventListXMLCorrect, "BookMakerDownloader->createEventListXML") or die;

die("TODO: correct to early closing event node"); 

my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($outputFile);
($got,$expected, $testname) = ($isCorectBookmakerOfferFile, 1, "BookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile");
ok($got, $testname) or die "Output file with bookmaker offer $outputFile hasn't correct format "; 
