use strict;
use warnings;
use Test::More tests => 2;
#use lib '../BookmakerOfferDownloader/';
#use BookmakerXmlDataParser;
use lib '..';
use ProfitabilityCalculator;
use FindBin;
use File::Copy;


print "****TEST MOCKED BETEXPLORER DOWNLOADER*****\n\n"; 

#copy .. offer file
#instead of creating advanced surebet parser maybe it is better to create model input and output data and compare their checksum in test(both input and output)
#later create advanced surebet parser   
	
copy "../BookmakerOfferDownloader/output/downloadedPolandEkstraklasa_mockednet.xml", 'input/bookmakersOffers_generatedByMock.xml' or die;
my $pathToBookmakersOfferFile = "$FindBin::Bin/../../input/bookmakersOffers_generatedByMock.xml";
my $offerProfitabilityFile = "$FindBin::Bin/../../output/test/offerProfitability_PolandEkstraklasa.xml";
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 

my $theProfitabilityCalculator = ProfitabilityCalculator->new();

$theProfitabilityCalculator->loadBookmakersOfferFile($pathToBookmakersOfferFile);

$theProfitabilityCalculator->generateOfferProfitabilityFile($offerProfitabilityFile);
my $isProfitabilityFileGeneratedCorrectly = $aBookmakerXmlDataParser->isCorrectProfitabilityFile($offerProfitabilityFile);
ok($isProfitabilityFileGeneratedCorrectly, "ProfitabilityCalculator: checking syntax of generated offer profability file");


#here maybe copmparing by some checksum
my $isTheSameFiles = '';
#$isTheSameFiles = compareFiles('output/offerProfitability_Example1_generated.xml', 'output/model/offerProfitability_Example1_expected.xml');
ok($isTheSameFiles, "ProfitabilityCalculator: checking corectness of offer profitability data");




