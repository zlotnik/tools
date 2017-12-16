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

my $offerProfitabilityFilePath = "$FindBin::Bin/../../../ProfitabilityCalculator/output/model/bookmakerOfferProfitabilityFile.xml"; 

my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 


ok($aBookmakerXmlDataParser->isCorrectProfitabilityFile($offerProfitabilityFilePath), 
															"Parsing offer profitability file\n $offerProfitabilityFilePath\n" ) or die;
