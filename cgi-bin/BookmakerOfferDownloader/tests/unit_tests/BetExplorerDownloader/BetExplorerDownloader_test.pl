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

############################MAIN##############################################

downloadLeaguesNames();
updateOutputFileWithLeagues();
exit;
find_countries_xpaths();

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

sub updateOutputFileWithLeagues()
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";

	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/BetExplorerDownloader";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

	my $selectorFile = "${subroutine_unitTest_directory}/sport_event_list_template.xml";
	my $bookMakerOfferFile_actual = "${subroutine_unitTest_directory}/sport_event_leagues_list_actual.xml" ;
	my $bookMakerOfferFile_expected = "${subroutine_unitTest_directory}/sport_event_leagues_list_expected.xml";

#	cp ( $selectorFile, $bookMakerOfferFile_actual ) or die $!;
#		
	$a_betExplorerDownloader->loadSelectorFile( $selectorFile );
	$a_betExplorerDownloader->updateOutputFileWithLeagues( $bookMakerOfferFile_actual );
	files_eq $bookMakerOfferFile_actual , $bookMakerOfferFile_expected , 'basic test selector file => bookmaker offer file';

	#unlink $bookMakerOfferFile_actual;

}

sub get_subroutineName()
{	
	my $calingFunctionName = (caller(1))[3] ;
	$calingFunctionName =~ /main::(.*)/;
	return  $1 ;
}
