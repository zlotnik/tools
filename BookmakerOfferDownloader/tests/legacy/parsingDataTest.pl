use strict;
use warnings;
use Test::More tests => 6;
use lib '..';
use BookmakerXmlDataParser;
use WojtekToolbox;

use FindBin;
use File::Copy;

#TODO: parsers should be moved to separated directory outside this module

print "****TEST SUITE PARSING DATA*****\n\n"; 
my $correctBookmakerSelectorFile = "$FindBin::Bin/../../input/parameters/examples/ekstraklasaSelector.xml";
my $correctDownloadedBookmakerOfferFile = "$FindBin::Bin/../../output/example/downloadedBookMakersOffer.xml";
my $correctBookmakerEventList = "$FindBin::Bin/../../output/example/downloadedEventList.xml";
my $mockedRawDataPath = "$FindBin::Bin/../../tmp/rawDataMockFile";
my $modelSurebetsFile = "$FindBin::Bin/../../../ProfitabilityCalculator/output/model/surebetsPolandEkstraklasa.xml";

my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 

ok($aBookmakerXmlDataParser->isCorrectRawDataFile($mockedRawDataPath), 
															  "Parsing raw data file\n $mockedRawDataPath\n" ) or die;

ok($aBookmakerXmlDataParser->isCorectBookmakerDataSelectorFile($correctBookmakerSelectorFile),
															  "Parsing selector file\n $correctBookmakerSelectorFile\n") or die;

ok($aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($correctDownloadedBookmakerOfferFile),
															   "Parsing bookmaker downloaded offert file\n $correctDownloadedBookmakerOfferFile\n")or die;

ok($aBookmakerXmlDataParser->isCorrectRawDataFile($mockedRawDataPath), 
															  "Parsing raw data file\n $mockedRawDataPath\n" ) or die;
															   
if(isConnectedToInternet())
{
	ok($aBookmakerXmlDataParser->isCorrectEventListFile($correctBookmakerEventList),"Parsing event list file\n $correctBookmakerEventList\n");
}
else
{
	print "Parsing event list file SKIPPED: NO INTERNET CONNECTION\n"
}

ok($aBookmakerXmlDataParser->isCorrectSurebetsFile($modelSurebetsFile), 
															  "Parsing surebet file\n $modelSurebetsFile\n" );
