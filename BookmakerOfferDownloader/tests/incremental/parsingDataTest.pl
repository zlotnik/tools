use strict;
use warnings;
use Test::More tests => 1;
use lib '..';
use BetExplorerDownloader;
use BookmakerXmlDataParser;
use DataDownloader; #needed??

use FindBin;
use File::Copy;


print "****TEST SUITE PARSING DATA*****\n\n"; 

my $correctDownloadedBookmakerOfferFile = "$FindBin::Bin/../../output/example/downloadedBookMakersOffer.xml";

my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new(); 


(-e $correctDownloadedBookmakerOfferFile) or die "File doesn't exist $correctDownloadedBookmakerOfferFile\n";
ok($aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($correctDownloadedBookmakerOfferFile),
															   "Parsing bookmaker downloaded offert file\n $correctDownloadedBookmakerOfferFile\n")or die;


