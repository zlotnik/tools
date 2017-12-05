use strict;
use warnings;
use Test::More tests => 2;
#use lib '../BookmakerOfferDownloader/';
#use BookmakerXmlDataParser;
use lib '..';
use SurebetFinder;
use FindBin;



print "****TEST MOCKED BETEXPLORER DOWNLOADER*****\n\n"; 

#copy .. offer file
#instead of creating advanced surebet parser maybe it is better to create model input and output data and compare their checksum in test(both input and output)

#later create advanced surebet parser   


my $pathToBookmakersOffeerFile = "$FindBin::Bin/../../input/bookmakersOffers_generatedByMock.xml";
my $surebetsOutputFile = "$FindBin::Bin/../../output/test/surebetsPolandEkstraklasa.xml";
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 

my $theSurebetFinder = SurebetFinder->new();

$theSurebetFinder->loadBookmakersOfferFile($pathToBookmakersOffeerFile);

my $amountOfSurebetsFound = $theSurebetFinder->generateSurebetsFile($surebetsOutputFile);
my $isSurebtsFileGeneratedCorrectly = $aBookmakerXmlDataParser->isCorrectSurebetsFile($surebetsOutputFile);
ok($isSurebtsFileGeneratedCorrectly, "SurebetFinder: checking syntax of generated surebets file") or die;
ok($amountOfSurebetsFound == 3, "SurebetFinder: checking amount of generated surebets");

#maybe test files should have _test postfix




