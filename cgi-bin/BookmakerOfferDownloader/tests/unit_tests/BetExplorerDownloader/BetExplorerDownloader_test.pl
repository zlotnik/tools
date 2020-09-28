#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;
use Test::File::Contents;
use File::Copy 'cp'; 
use BetExplorerDownloader;
use Test::MockModule;

###############SUB PROTOTYPES############################################
# sub new();
# sub loadSelectorFile($);
# sub getsLinksForAllEventsFromSubCategory($$);
# sub getTableWithEvents($);
# sub getLinksToEventFromTable($);
# sub create_BookmakersOfferFile($);
# sub downloadRawDataOfChoosenOfert(\%);
# sub generateReportLine($);
# sub getRawDataOfEvent($);
# sub checkNumberOfBookmaker($);
# sub convertRawDownloadedDataToHash($);
# sub createEventListXML($$);
# sub getAllSubCategories($$);
# sub updateXmlNodeWithDataFromBookmaker($$);
# sub getRootNode($);
# sub addChildSubcategoryNodeToOfferXml($$$);
# sub addLinkToEventToOfferXml($$$);
# sub updateEventListXMLWithEventDetails($);
# sub add_bookmakerOffers_to_xmlWithSportEvents($);
# sub correctFormatXmlDocument($);
# sub xmlDocumentHasNodeWithoutLineBreaks($);
# sub validateSelectorFile();
# sub isLinkToEvent($);
# sub startCreatingXmlPartWithAnEventDetail($);
# sub pickupLinksFromXml($);
# sub removeEmptyLines(\$);
# sub showUsage();
# sub prepareTemplateFor_SportEventsFile($);
# sub isEventsNodeExists($$);
# sub addEventNodeToXmlEventList($$);
# sub injectBookmakerEventOfferIntoXML($$);
# sub injectBookmakerProductEventOffertIntoXML($$$);
sub add_bookmakerOffers_to_xmlWithSportEvents();
sub create_BookmakersOfferFile();
sub createEventListXML();
sub updateOutputFileWithLeagues();
sub find_countries_xpaths();
sub downloadLeaguesNames();
sub insertLeagues_intoCountryNode();
############################MAIN##############################################
insertLeagues_intoCountryNode();
updateOutputFileWithLeagues();
find_countries_xpaths();
downloadLeaguesNames();
updateOutputFileWithSportEvents();
#add_bookmakerOffers_to_xmlWithSportEvents();
#create_BookmakersOfferFile();
# add_leagues_events();
#createEventListXML();

done_testing();

####################SUB DEFINITIONS############################################

sub downloadLeaguesNames()
{

	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";

	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');

	my @expected = ('super-liga', 'prva-liga');
	my @actual = $a_betExplorerDownloader->downloadLeaguesNames ( '/soccer/Serbia' );
	my $testName = 'fetching leagues list from stubed website';
	
	is_deeply( \@actual, \@expected, $testName );
	#my @actual = $a_betExplorerDownloader->downloadLeaguesNames ( '/note/data/soccer/Poland' )

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
	$a_betExplorerDownloader->createEventListXML('',$bookmakerEventList_actual);
	files_eq $bookmakerEventList_actual , $bookmakerEventList_expected , 'creating the bookmaker offer file';

}

sub add_bookmakerOffers_to_xmlWithSportEvents()
{
	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet'); #isn't readable what to pass especially that real decision is taken to level down
	
	my $path2Xml_with_events = 'soccerEvents.xml';
	$a_betExplorerDownloader->add_bookmakerOffers_to_xmlWithSportEvents($path2Xml_with_events);
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

#responsibility: get selelector file and xpath to country and add leagues
#insertLeagues_intoCountryNode
#so there should be separate class like SportBetsXML -> XML
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

sub insertEvents_intoLeagueNode_mock($\@);
sub insertEvents_intoLeagueNode_mock($\@)
{
        my $self = shift;
        my ( $league_xpath , $event_URLs_ref ) = @_;
        my @eventsURLs = @{$event_URLs_ref};

	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/insertEvents_intoLeagueNode";

        my $outputFileName = $self->get_OutputFile();
        my $sourceFile = "${subroutine_unitTest_directory}/poland_events_list_expected.xml";
        cp $sourceFile, $outputFileName or die "Can't copy file $sourceFile -> $outputFileName";
}

sub downloadEventURLs_mock
{
        return('https://www.betexplorer.com/soccer/Poland/ekstraklasa/korona-kielce-plock/6L7f5jc4/',
               'https://www.betexplorer.com/soccer/Poland/ekstraklasa/jagiellonia-lech-poznan/SU8j6Wsb/');
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
	$betExplorerDownloader_mock->redefine( 'insertEvents_intoLeagueNode', \&insertEvents_intoLeagueNode_mock );
	$betExplorerDownloader_mock->redefine( 'downloadEventURLs', \&downloadEventURLs_mock);

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
