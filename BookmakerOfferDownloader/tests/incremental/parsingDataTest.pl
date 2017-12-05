use strict;
use warnings;
use Test::More tests => 1;
use lib '..';
use BookmakerXmlDataParser;
use WojtekToolbox;

use FindBin;
use File::Copy;

#TODO: parsers should be moved to separated directory outside this module

print "****TEST SUITE PARSING DATA*****\n\n"; 

my $modelSurebetsFile = "$FindBin::Bin/../../../SurebetsFinder/output/model/surebetsPolandEkstraklasa.xml";

my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 


ok($aBookmakerXmlDataParser->isCorrectSurebetsFile($modelSurebetsFile), 
															  "Parsing surebet file\n $modelSurebetsFile\n" );


