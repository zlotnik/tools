use strict;
use warnings;
use Test::More tests => 2;
#use lib '../BookmakerOfferDownloader/';
#use BookmakerXmlDataParser;
use lib '..';
use ProfitabilityCalculator;
use FindBin;
use File::Copy;
use File::Compare;


print "****TEST MOCKED BETEXPLORER DOWNLOADER*****\n\n"; 

#copy .. offer file
#instead of creating advanced surebet parser maybe it is better to create model input and output data and compare their checksum in test(both input and output)
#later create advanced surebet parser   
	
copy "../BookmakerOfferDownloader/output/downloadedPolandEkstraklasa_mockednet.xml", 'input/bookmakersOffers_generatedByMock.xml' or die;
my $pathToBookmakersOfferFile = "$FindBin::Bin/../../input/bookmakersOffers_generatedByMock.xml";
my $offerProfitabilityFile = "$FindBin::Bin/../../output/test/offerProfitability_TestCase1_generated.xml";
my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 

my $theProfitabilityCalculator = ProfitabilityCalculator->new();

$theProfitabilityCalculator->loadBookmakersOfferFile($pathToBookmakersOfferFile);

$theProfitabilityCalculator->generateOfferProfitabilityFile($offerProfitabilityFile);
my $isProfitabilityFileGeneratedCorrectly = $aBookmakerXmlDataParser->isCorrectProfitabilityFile($offerProfitabilityFile);
ok($isProfitabilityFileGeneratedCorrectly, "ProfitabilityCalculator: checking syntax of generated offer profability file");


#here maybe copmparing by some checksum
my $isTheSameFiles = '';
$isTheSameFiles = (compare('output/test/offerProfitability_TestCase1_generated.xml', 
								'output/model/offerProfitability_TestCase1_expected.xml') == 0 );

ok($isTheSameFiles, "ProfitabilityCalculator: checking corectness of offer profitability data");



#todo add postfixes to other test files
