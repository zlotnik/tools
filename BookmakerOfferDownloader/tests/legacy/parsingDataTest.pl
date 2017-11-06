use strict;
use warnings;
use Test::More tests => 4;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
use DataDownloader; #needed??
use WojtekToolbox;

use FindBin;
use File::Copy;


print "****TEST SUITE PARSING DATA*****\n\n"; 
my $correctBookmakerSelectorFile = "$FindBin::Bin/../../input/parameters/examples/ekstraklasaSelector.xml";
my $correctDownloadedBookmakerOfferFile = "$FindBin::Bin/../../output/example/downloadedBookMakersOffer.xml";
my $correctBookmakerEventList = "$FindBin::Bin/../../output/example/downloadedEventList.xml";
my $mockedRawDataPath = "$FindBin::Bin/../../tmp/rawDataMockFile";

my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 

(-e $mockedRawDataPath) or die "File doesn't exist $mockedRawDataPath\n";
ok($aBookmakerXmlDataParser->isCorrectRawDataFile($mockedRawDataPath), 
															  "Parsing raw data file\n $mockedRawDataPath\n" ) or die;

(-e $correctBookmakerSelectorFile) or die "File doesn't exist $correctBookmakerSelectorFile\n";
ok($aBookmakerXmlDataParser->isCorectBookmakerDataSelectorFile($correctBookmakerSelectorFile),
															  "Parsing selector file\n $correctBookmakerSelectorFile\n") or die;

(-e $correctDownloadedBookmakerOfferFile) or die "File doesn't exist $correctDownloadedBookmakerOfferFile\n";
ok($aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($correctDownloadedBookmakerOfferFile),
															   "Parsing bookmaker downloaded offert file\n $correctDownloadedBookmakerOfferFile\n")or die;

(-e $correctBookmakerEventList) or die "File doesn't exist $correctBookmakerEventList\n";

if(isConnectedToInternet())
{
	ok($aBookmakerXmlDataParser->isCorrectEventListFile($correctBookmakerEventList),"Parsing event list file\n $correctBookmakerEventList\n");
}
else
{
	print "Parsing event list file SKIPPED: NO INTERNET CONNECTION\n"
}

