3use strict;
use warnings;
use Test::More tests => 2;
use lib '..';
use BookmakerXmlDataParser;
use FindBin;
use File::Copy;

print "****TEST MOCKED BETEXPLORER DOWNLOADER*****\n\n"; 

my $pathToBookmakersOffeerFile = ''#
my $surebetsOutputFile = '';#
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 
#copy .. offer file

my $theSurebetFinder = SurebetFinder->new();


$theSurebetFinder->loadBookmakersOfferFile($pathToBookmakersOffeerFile);
my $amountOfSurebetsFound = $theSurebetFinder->generateSurebetsFile($surebetsOutputFile);
my $isSurebtsFileGeneratedCorrectly = $aBookmakerXmlDataParser->isCorrectSurebetsFile($surebetsOutputFile);
ok($isSurebtsFileGeneratedCorrectly, "SurebetFinder: checking syntax of generated surebets file") or die;
ok($amountOfSurebetsFound == 3, "SurebetFinder: checking amount of generated surebets");




