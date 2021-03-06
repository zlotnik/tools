#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;
use Test::File::Contents;
use Test::MockModule;
use Data::Dumper;
use File::Copy 'cp'; 
use File::Slurp;
use HTML_EventsTableParser;
use BetexplorerParser_mock;

###############SUB PROTOTYPES############################################
sub giveMeNextEventRow();
############################MAIN##############################################
print("\n##Testing MODULE: SportEvent##\n\n");

#something wrong with name giveMeNextEventRowWithData giveMeNextEventRowWith
giveMeNextEventRow();
done_testing();

####################SUB DEFINITIONS############################################
sub giveMeNextEventRow()
{

	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";

	my $betExplorerParser_mock = Test::MockModule->new('BetexplorerParser');#change capitalization of module
	$betExplorerParser_mock->redefine( 'pickupTableWithEventsFromWeburl', \&BetexplorerParser_mock::pickupTableWithEventsFromWeburl );

        my $webUrl_unused = 'https://www.betexplorer.com/soccer/germany/bundesliga/';  
        my $html_eventsTable = BetexplorerParser::pickupTableWithEventsFromWeburl( $webUrl_unused );

	my $html_eventsTableParser = HTML_EventsTableParser->new( $html_eventsTable ); 
        
        my $actual_firstRow = $html_eventsTableParser->giveMeNextEventRow();

        my $test_data_dir = "$ENV{'BOOKMAKER_OFFER_DOWNLOADER_UNIT_TEST_DIRECTORY'}/HTML_EventsTableParser/$subroutineName";
        my $expected_firstRow = read_file( "${test_data_dir}/firstRow_expected" ); 
 
	
	is( $actual_firstRow , $expected_firstRow, 'Testing if first row is picked up from event table html' );
        
        my $secondRow_actual = $html_eventsTableParser->giveMeNextEventRow();
        my $secondRow_expected = read_file( "${test_data_dir}/secondRow_expected" ); 
	is( $secondRow_actual, $secondRow_expected, 'Testing if second row is picked up from event table html' );

        $html_eventsTableParser->giveMeNextEventRow();
        my $emptyRow_actual = $html_eventsTableParser->giveMeNextEventRow();
        my $emptyRow_expected = '';

	is( $emptyRow_actual, $emptyRow_expected, 'Testing no existing row' );
	#is( $actual_firstRow , $expected_firstRow, 'Testing if second row is picked up from event table html' );
	#check empty row as well

}

sub find_countries_xpaths() 
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";

	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

	my $selectorFile = "${subroutine_unitTest_directory}/surebet_template_file.xml";
	my @expected = ('/note/data/soccer/Poland','/note/data/soccer/Germany','/note/data/soccer/Sweden' ); 
	my $testName = "Testing finding xpath in surebet template file";
#	$a_betExplorerDownloader->{};# here probable should be name of propertie with path to selector
	my @got = $a_betExplorerDownloader->find_countries_xpaths( $selectorFile );
        is_deeply( \@got, \@expected, $testName );
	
} 

sub create_BookmakersOfferFile()
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";
	
	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

	my $examplarySelectorFile = "${subroutine_unitTest_directory}/selectorFile_example.xml";
	my $bookmakerOfferFile_actual = "${subroutine_unitTest_directory}/bookmakerOfferFile_actual.xml" ;
	my $bookmakerOfferFile_expected = "${subroutine_unitTest_directory}/bookmakerOfferFile_expected.xml";
	unlink $bookmakerOfferFile_actual;

	$a_betExplorerDownloader->{mSelectorFile} = $examplarySelectorFile;
	$a_betExplorerDownloader->create_BookmakersOfferFile($bookmakerOfferFile_actual);
	files_eq $bookmakerOfferFile_actual , $bookmakerOfferFile_expected , 'creating the bookmaker offer file';
}

sub createEventListXML()
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";
	
	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

	my $examplarySelectorFile = "${subroutine_unitTest_directory}/selectorFile_example.xml";
	my $bookmakerEventList_actual = "${subroutine_unitTest_directory}/sportEventList_actual.xml" ;
	my $bookmakerEventList_expected = "${subroutine_unitTest_directory}/sportEventList_expected.xml";
	unlink $bookmakerEventList_actual;

	$a_betExplorerDownloader->{mSelectorFile} = $examplarySelectorFile;
        $a_betExplorerDownloader->set_OutputFile( $bookmakerEventList_actual );
        cp ( $a_betExplorerDownloader->get_selectorFile, $a_betExplorerDownloader->get_OutputFile() ) or die "Can't load selector file"; 
	$a_betExplorerDownloader->createEventListXML();
	files_eq $bookmakerEventList_actual , $bookmakerEventList_expected , 'creating a sport events file';

}

sub add_bookmakerOffer()
{
	my $subroutineName = get_subroutineName();
        print "\nTESTING SUBROUTINE: $subroutineName\n";
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";
	
	my $path2Xml_with_events = "${subroutine_unitTest_directory}/poland_events_list.xml";
	my $bookmakerOfferFile_expected = "${subroutine_unitTest_directory}/poland_bookmakerOffer_expected.xml";
	my $bookmakerOfferFile_actual = "${subroutine_unitTest_directory}/poland_bookmakerOffer_actual.xml";
        cp ( $path2Xml_with_events, $bookmakerOfferFile_actual ) or die $!;

	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet'); #isn't readable what to pass especially that real decision is taken to level down
	$a_betExplorerDownloader->{mSelectorFile} = $path2Xml_with_events;
        $a_betExplorerDownloader->set_OutputFile( $bookmakerOfferFile_actual );       

	$a_betExplorerDownloader->add_bookmakerOffer(); #this argument should be deleted
	files_eq ( $bookmakerOfferFile_actual, $bookmakerOfferFile_expected , 'creating a sport events file' );

}


sub insertLeagues_intoCountryNode_mock  #todo mock should be in separated module
{
        my $self = shift;
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/insertLeagues_intoCountryNode";

        my $outputFileName = $self->get_OutputFile();
        my $sourceFile = "${subroutine_unitTest_directory}/serbia_leagues_list_expected.xml";
        cp $sourceFile, $outputFileName or die "Can't copy file $sourceFile -> $outputFileName";

}


sub insertLeagues_intoCountryNode()
{
        my $subroutineName = get_subroutineName();
        print "\nTESTING SUBROUTINE: $subroutineName\n";
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";
        
	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');

        my $inputFile = "${subroutine_unitTest_directory}/selector_serbia.xml";
        my $actualXml = "${subroutine_unitTest_directory}/serbia_leagues_list_actual.xml";
        my $expectedXml = "${subroutine_unitTest_directory}/serbia_leagues_list_expected.xml";

        
        cp $inputFile, $actualXml or die;
        $a_betExplorerDownloader->set_OutputFile($actualXml);
        my $countriesXpath = '/note/data/soccer/Serbia'; 
        my @league_list = ('super-liga', 'prva-liga' );

        $a_betExplorerDownloader->insertLeagues_intoCountryNode( $countriesXpath, \@league_list );
        files_eq($actualXml, $expectedXml, "Testing if the output file is updated with league list");

}

sub downloadEventsURLs()
{

        my $subroutineName = get_subroutineName();
        print "\nTESTING SUBROUTINE: $subroutineName\n";

        my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');

        my @expected = ('https://www.betexplorer.com/soccer/Poland/ekstraklasa/korona-kielce-plock/6L7f5jc4/',
                        'https://www.betexplorer.com/soccer/Poland/ekstraklasa/jagiellonia-lech-poznan/SU8j6Wsb/');

        my @actual = $a_betExplorerDownloader->downloadEventsURLs( '/soccer/Poland/ekstraklasa' );

        my $testName = 'fetching event list from stubed website';

        is_deeply( \@actual, \@expected, $testName );

}

sub downloadLeaguesNames_mock()
{
        return ('super-liga', 'prva-liga' );

}

sub find_countries_xpaths_mock
{
	return('/note/data/soccer/Serbia'); 
}

sub updateOutputFileWithLeagues()
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";

	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

	my $selectorFile = "${subroutine_unitTest_directory}/selector_serbia.xml";

	my $bookMakerOfferFile_actual = "${subroutine_unitTest_directory}/selector_serbia_leagues_list_actual.xml" ;
	my $bookMakerOfferFile_expected = "${subroutine_unitTest_directory}/selector_serbia_leagues_list_expected.xml";
        $a_betExplorerDownloader->set_OutputFile( $bookMakerOfferFile_actual );        

        cp $selectorFile, $bookMakerOfferFile_actual or die;
	my $betExplorerDownloader_mock = Test::MockModule->new('BetExplorerDownloader');

	$betExplorerDownloader_mock->redefine( 'find_countries_xpaths', \&find_countries_xpaths_mock );
	$betExplorerDownloader_mock->redefine( 'insertLeagues_intoCountryNode', \&insertLeagues_intoCountryNode_mock );
	$betExplorerDownloader_mock->redefine( 'downloadLeaguesNames', \&downloadLeaguesNames_mock);

	$a_betExplorerDownloader->loadSelectorFile( $selectorFile );
	$a_betExplorerDownloader->updateOutputFileWithLeagues();
	files_eq $bookMakerOfferFile_actual , $bookMakerOfferFile_expected , 'Testing if output file is updated with leagues list';
}


sub find_leagues_xpaths_mock
{
        return('/note/data/soccer/Poland/ekstraklasa'); 
}


sub downloadEventsURLs_mock
{
        return('https://www.betexplorer.com/soccer/Poland/ekstraklasa/korona-kielce-plock/6L7f5jc4/',
               'https://www.betexplorer.com/soccer/Poland/ekstraklasa/jagiellonia-lech-poznan/SU8j6Wsb/');
}

sub find_leagues_xpaths()
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";

	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

	my $selectorFile = "${subroutine_unitTest_directory}/serbia_leagues_list_actual.xml";
	my @expected = ('/note/data/soccer/Serbia/super-liga','/note/data/soccer/Serbia/prva-liga' ); 

	my $testName = "Testing finding leagues xpath in surebet template file";

	my @got = $a_betExplorerDownloader->find_leagues_xpaths( $selectorFile );
        is_deeply( \@got, \@expected, $testName );
	
}

sub updateOutputFileWithSportEvents()
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";

	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

	my $selectorFile = "${subroutine_unitTest_directory}/selector_poland_leagues_list.xml";

	my $selector_events_list_actual = "${subroutine_unitTest_directory}/selector_poland_events_list_actual.xml" ;
	my $selector_event_list_expected = "${subroutine_unitTest_directory}/selector_poland_events_list_expected.xml";
        $a_betExplorerDownloader->set_OutputFile( $selector_events_list_actual );        

        cp $selectorFile, $selector_events_list_actual or die;
	my $betExplorerDownloader_mock = Test::MockModule->new('BetExplorerDownloader');

	$betExplorerDownloader_mock->redefine( 'find_leagues_xpaths', \&find_leagues_xpaths_mock );
	$betExplorerDownloader_mock->redefine( 'downloadEventsURLs', \&downloadEventsURLs_mock);

	$a_betExplorerDownloader->loadSelectorFile( $selectorFile );
	$a_betExplorerDownloader->updateOutputFileWithSportEvents();
	files_eq $selector_events_list_actual , $selector_event_list_expected , 'Testing if output file is updated with events list';

}

sub get_subroutineName()
{	
	my $calingFunctionName = (caller(1))[3] ;
	$calingFunctionName =~ /main::(.*)/;
	return  $1 ;
}
