use strict;
use warnings;
use Test::More tests => 7;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
use FindBin;
#TODO think about split tests
#nice would be to have some bin directory with tools eg. parsing file for comments others tools
#TODO nice will be to have a hooks checking format of commits
#atest run mode to consider 1.debug, 2.run all  3.stop on first 4.Categorize tests

my $correctBookmakerSelectorFile = "$FindBin::Bin/../input/parameters/examples/ekstraklasaSelector.xml";
my $correctBookmakerOfferFile = "dataExamples/bookMakersOffer.xml";
my $correctBookmakerEventList = "$FindBin::Bin/../output/example/downloadedEventList.xml";


 
my $selectorFile = 'input/parameters/polandEkstraklasaSelector.xml';
my $outputFile = "output/downloadedPolandEkstraklasa.xml";

#BetExplorerDownloader::updateEventListXMLWithEventDetails('');
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 
my $theBookMakerDownloader =  BetExplorerDownloader->new(); 


(-e $correctBookmakerSelectorFile) or die "File doesn't exist $correctBookmakerSelectorFile\n";
ok($aBookmakerXmlDataParser->isCorectBookmakerDataSelectorFile($correctBookmakerSelectorFile),'BookmakerXmlDataParser->isCorectBookmakerDataSelectorFile') or die;


(-e $correctBookmakerEventList) or die "File doesn't exist $correctBookmakerEventList\n";
ok($aBookmakerXmlDataParser->isCorrectEventListFile($correctBookmakerEventList),'BookmakerXmlDataParser->isCorrectEventListFile') or die;

(-e $correctBookmakerEventList) or die "File doesn't exist $correctBookmakerEventList\n";
ok($aBookmakerXmlDataParser->isCorectBookmakerDataSelectorFile($correctBookmakerEventList),'BookmakerXmlDataParser->isCorectBookmakerDataSelectorFile')or die;


my $isCorectBookmakerDataSelectorFile = $aBookmakerXmlDataParser->isCorectBookmakerDataSelectorFile($selectorFile);
my ($got, $expected, $testname) = ($isCorectBookmakerDataSelectorFile, 1, "Corectness of bookmaker selector file : $outputFile");
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

