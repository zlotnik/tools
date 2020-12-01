use strict;
use warnings;
use Test::More tests => 2;
use lib '..';
use ProfitabilityCalculator;
use FindBin;
use File::Copy;
use File::Compare;
use File::Slurp;


 

#copy .. offer file
#instead of creating advanced surebet parser maybe it is better to create model input and output data and compare their checksum in test(both input and output)
#later create advanced surebet parser   
	
#copy "../BookmakerOfferDownloader/output/downloadedPolandEkstraklasa_mockednet.xml", 'input/bookmakersOffers_generatedByMock.xml' or die;
my $pathToBookmakersOfferFile = $ENV{PROFITABILITY_MODULE_DIRECTORY}."/input/bookmakersOffers_generatedByMock.xml";
my $offerProfitabilityFile_actual = $ENV{PROFITABILITY_MODULE_DIRECTORY}."/output/test/offerProfitability_TestCase1_generated.xml";
my $expectedProfitabiltyFile = $ENV{PROFITABILITY_MODULE_DIRECTORY}."/output/model/offerProfitability_TestCase1_expected.xml";

print "****TEST MOCKED BETEXPLORER DOWNLOADER: Testing generating profitability file based on input file: $pathToBookmakersOfferFile*****\n\n";

my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 

my $theProfitabilityCalculator = ProfitabilityCalculator->new();

$theProfitabilityCalculator->loadBookmakersOfferFile($pathToBookmakersOfferFile);

unlink $offerProfitabilityFile_actual;
$theProfitabilityCalculator->generateOfferProfitabilityFile($offerProfitabilityFile_actual);
my $isProfitabilityFileGeneratedCorrectly = $aBookmakerXmlDataParser->isCorrectProfitabilityFile($offerProfitabilityFile_actual);
ok($isProfitabilityFileGeneratedCorrectly, "ProfitabilityCalculator: checking syntax of generated offer profability file: $offerProfitabilityFile_actual");


my $isTheSameFiles = '';
$isTheSameFiles = (compare($offerProfitabilityFile_actual, $expectedProfitabiltyFile) == 0 );

my $actual_profibility_xml_FD;
my $expected_profitability_xml_FD;


my $offerProfitabilityText_actual = read_file($offerProfitabilityFile_actual) or die;
my $offerProfitabilityText_expected = read_file($expectedProfitabiltyFile) or die;

my $testName = "ProfitabilityCalculator: checking corectness of offer profitability data";
my $testOK = is($offerProfitabilityText_actual, $offerProfitabilityText_expected, $testName	);

if (! $testOK)
{
	print "Test $testName failed: result xml: $offerProfitabilityFile_actual isn't the same that expected: $expectedProfitabiltyFile\n";
} 


#todo add postfixes to other test files
