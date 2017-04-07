use strict;
use warnings;
use Test::More tests => 7;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
#TODO think about split tests
#nice would be to have some bin directory with tools eg. parsing file for comments others tools
#TODO nice will be to have a hooks checking format of commits

my $correctBookmakerSelectorFile = "dataExamples/dataSelector.xml";
my $correctBookmakerOfferFile = "dataExamples/bookMakersOffer.xml";
my $correctBookmakerEventList = "dataExamples/eventList.xml";

 
my $selectorFile = 'input/parameters/polandEkstraklasaSelector.xml';
my $outputFile = "output/downloadedPolandEkstraklasa.xml";

#BetExplorerDownloader::updateEventListXMLWithEventDetails('');
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 
my $theBookMakerDownloader =  BetExplorerDownloader->new(); 

ok($aBookmakerXmlDataParser->isCorectBookmakerSelectorFile($correctBookmakerSelectorFile),'BookmakerXmlDataParser->isCorectBookmakerSelectorFile') or die;


ok($aBookmakerXmlDataParser->isCorrectEventListFile($correctBookmakerOfferFile),'BookmakerXmlDataParser->isCorrectEventListFile') or die;
ok($aBookmakerXmlDataParser->isCorectBookmakerSelectorFile($correctBookmakerEventList),'BookmakerXmlDataParser->isCorectBookmakerSelectorFile')or die;


my $isCorectBookmakerSelectorFile = $aBookmakerXmlDataParser->isCorectBookmakerSelectorFile($selectorFile);
my ($got, $expected, $testname) = ($isCorectBookmakerSelectorFile, 1, "Corectness of bookmaker selector file : $outputFile");
ok($got eq $expected, $testname) or die;


if(-e $outputFile)
{
	unlink $outputFile or  die $?; 
}


my $xmlParser = XML::LibXML->new;
copy $selectorFile, $outputFile or die $?; #does it needed?
my $doc = $xmlParser->parse_file($selectorFile);
my $xpath = "";
my @rootXmlNode = $doc->findnodes("/");	
#my $rootXmlNode = $doc->findnodes("/")[0]; maybe this is better		
BookMakerDownloader->isCorrectEventListFile($outputFile); 


BookMakerDownloader->createEventListXML($rootXmlNode[0], $xpath, $outputFile);
my $isCreateEventListXMLCorrect = BookMakerDownloader->isCorrectEventListFile($outputFile); 
ok($isCreateEventListXMLCorrect, "BookMakerDownloader->createEventListXML") or die;


$theBookMakerDownloader->loadSelectorFile($selectorFile);
$theBookMakerDownloader->generateOutputXML($outputFile);

my $isOutputXmlFileExist = (-e $outputFile);
($got, $expected, $testname) = ($isOutputXmlFileExist, 1, "BookMakerDownloader->generateOutputXML($outputFile)");
ok($isOutputXmlFileExist, $testname) or die;

my $isCorectBookmakerOfferFile = $aBookmakerXmlDataParser->isCorectBookmakerOfferFile($outputFile);
($got,$expected, $testname) = ($isCorectBookmakerOfferFile, 1, "Checking if the output file $outputFile is a correct file with bookamker offer");
ok($got, $testname) or die; 

