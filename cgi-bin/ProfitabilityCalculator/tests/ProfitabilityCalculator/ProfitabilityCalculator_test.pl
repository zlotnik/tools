use strict;
use warnings;
use Test::More tests => 2;
use lib '..';
use ProfitabilityCalculator;
use FindBin;
use File::Copy;
use File::Compare;
use File::Slurp;
use Test::File::Contents;


sub generateOfferProfitabilityFile(); 


generateOfferProfitabilityFile();


sub generateOfferProfitabilityFile()
{
                

        my $pathToSubTestingDirectory = $ENV{PROFITABILITY_MODULE_DIRECTORY}."/tests/ProfitabilityCalculator/generateOfferProfitabilityFile" ;
        my $pathToBookmakersOfferFile = "${pathToSubTestingDirectory}/bookmakerOfferFile.xml";
 
        my $offerProfitabilityFile_actual = "${pathToSubTestingDirectory}/profitabilityFile_actual.xml";
        my $offerProfitabilityFile_expected = "${pathToSubTestingDirectory}/profitabilityFile_expected.xml";

        print "****TEST MOCKED BETEXPLORER DOWNLOADER: Testing generating profitability file based on input file: $pathToBookmakersOfferFile*****\n\n";

        my $theProfitabilityCalculator = ProfitabilityCalculator->new();

        unlink $offerProfitabilityFile_actual;
        
        $theProfitabilityCalculator->loadBookmakersOfferFile( $pathToBookmakersOfferFile );
        $theProfitabilityCalculator->set_OutputFile( $offerProfitabilityFile_actual );

        $theProfitabilityCalculator->generateOfferProfitabilityFile($offerProfitabilityFile_actual);
        
        files_eq($offerProfitabilityFile_actual, $offerProfitabilityFile_expected , 'Checking if profitability file looks as expected');

}

