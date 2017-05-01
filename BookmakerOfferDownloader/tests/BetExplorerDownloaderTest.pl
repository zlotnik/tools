use strict;
use warnings;
use Test::More tests => 7;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
use FindBin;
use File::Copy;
#TODO think about split tests
#nice would be to have some bin directory with tools eg. parsing file for comments others tools
#TODO nice would be to have hooks checking format of commits
#atest run mode to consider 1.debug, 2.run all  3.stop on first 4.Categorize tests
#todo: add to the desing a picture describing stages of creating output xml
#testing script should check partial corectness first	

my $correctBookmakerSelectorFile = "$FindBin::Bin/../input/parameters/examples/ekstraklasaSelector.xml";
my $correctDownloadedBookmakerOfferFile = "$FindBin::Bin/../output/example/downloadedBookMakersOffer.xml";
my $correctBookmakerEventList = "$FindBin::Bin/../output/example/downloadedEventList.xml";


 
#my $selectorFile = 'input/parameters/polandEkstraklasaSelector.xml';
my $outputFile = "output/downloadedPolandEkstraklasa.xml";

#BetExplorerDownloader::updateEventListXMLWithEventDetails('');
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 
my $theBookMakerDownloader =  BetExplorerDownloader->new(); 


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

$theBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile);
$theBookMakerDownloader->createEventListXML($xpath, $outputFile);

#$theBookMakerDownloader->generateOutputXML($outputFile);

my $isCreateEventListXMLCorrect = $aBookmakerXmlDataParser->isCorrectEventListFile($outputFile); 
ok($isCreateEventListXMLCorrect, "BookMakerDownloader->createEventListXML") or die;


$theBookMakerDownloader->loadSelectorFile($correctBookmakerSelectorFile);
$theBookMakerDownloader->generateOutputXML($outputFile);

my $isOutputXmlFileExist = (-e $outputFile);
($got, $expected, $testname) = ($isOutputXmlFileExist, 1, "BookMakerDownloader->generateOutputXML($outputFile)");
ok($isOutputXmlFileExist, $testname) or die;

my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectBookmakerOfferFile($outputFile);
($got,$expected, $testname) = ($isCorectBookmakerOfferFile, 1, "Checking if the output file $outputFile is a correct file with bookamker offer");
ok($got, $testname) or die; 
