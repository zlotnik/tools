#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;
use Test::File::Contents;
use File::Copy 'cp'; 
use Test::MockModule;
use BookmakerXmlDataParser;


###############SUB PROTOTYPES############################################
sub pickupLinksToEventFromTable();
sub get_subroutineName(); #move it to some external package
sub isCorectDownloadedBookmakerOfferFile();
############################MAIN##############################################

print("\n##Testing module BetexplorerParser##\n\n");
isCorectDownloadedBookmakerOfferFile();
done_testing();

sub isCorectDownloadedBookmakerOfferFile()
{

        my $subroutineName = get_subroutineName();
        print "\nTESTING SUBROUTINE: $subroutineName\n";

        my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/BookmakerXmlDataParser";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

	my $correctBookmakerOfferFile = "${subroutine_unitTest_directory}/bookmakerOfferFile_correct.xml" ;
        
	my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new();
        
        my $actual_result_of_parsing = $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile( $correctBookmakerOfferFile );
        my $testName = "Testing correct bookmaker offer file";
        my $expected_result_of_parsing_file = 1;

        is( $actual_result_of_parsing , $expected_result_of_parsing_file, $testName );

        #TODO some negative cases
}


####################SUB DEFINITIONS############################################

sub get_subroutineName()
{	
	my $calingFunctionName = (caller(1))[3] ;
	$calingFunctionName =~ /main::(.*)/;
	return  $1 ;
}
