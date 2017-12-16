use strict;
use warnings;
use Test::More tests => 2;
#use lib '../BookmakerOfferDownloader/';
#use BookmakerXmlDataParser;
use lib '..';
use SurebetFinder;
use FindBin;
use File::Copy;


print "****TEST MOCKED BETEXPLORER DOWNLOADER*****\n\n"; 

#copy .. offer file
#instead of creating advanced surebet parser maybe it is better to create model input and output data and compare their checksum in test(both input and output)
#later create advanced surebet parser   
	
copy "../BookmakerOfferDownloader/output/downloadedPolandEkstraklasa_mockednet.xml", 'input/bookmakersOffers_generatedByMock.xml' or die;
my $pathToBookmakersOfferFile = "$FindBin::Bin/../../input/bookmakersOffers_generatedByMock.xml";
my $surebetsOutputFile = "$FindBin::Bin/../../output/test/offerProfitability_PolandEkstraklasa.xml";
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 

my $theProfitabilityCalculator = ProfitabilityCalculator->new();

$theProfitabilityCalculator->loadBookmakersOfferFile($pathToBookmakersOfferFile);

$theProfitabilityCalculator->generateOfferProfitabilityFile($surebetsOutputFile);
my $isProfitabilityFileGeneratedCorrectly = $aBookmakerXmlDataParser->isCorrectProfitabilityFile($surebetsOutputFile);
ok($isProfitabilityFileGeneratedCorrectly, "ProfitabilityCalculator: checking syntax of generated surebets file");


#here maybe copmparing by some checksum
#ok($amountOfSurebetsFound == 3, "ProfitabilityCalculator: checking amount of generated surebets");




