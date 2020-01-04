#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;
use Test::File::Contents;
use BetExplorerDownloader;

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
############################MAIN##############################################

#add_bookmakerOffers_to_xmlWithSportEvents();
create_BookmakersOfferFile();
done_testing();

####################SUB DEFINITIONS############################################

sub add_bookmakerOffers_to_xmlWithSportEvents()
{
	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet'); #isn't readable what to pass especially that real decision is taken to level down
	
	my $path2Xml_with_events = 'soccerEvents.xml';
	$a_betExplorerDownloader->add_bookmakerOffers_to_xmlWithSportEvents($path2Xml_with_events);
}

sub create_BookmakersOfferFile()
{
	my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');
	my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests";
	my $subroutineName = 'create_BookmakersOfferFile'; #there should be subroutine to determine subroutine name  
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

	my $examplarySelectorFile = "${subroutine_unitTest_directory}/selectorFile_example.xml";
	my $bookMakerOfferFile_actual = "${subroutine_unitTest_directory}/bookmakerOfferFile_actual.xml" ;
	my $bookMakerOfferFile_expected = "${subroutine_unitTest_directory}/bookmakerOfferFile_expected.xml";

	$a_betExplorerDownloader->{mSelectorFile} = $examplarySelectorFile;
	$a_betExplorerDownloader->create_BookmakersOfferFile($bookMakerOfferFile_actual);
	files_eq $bookMakerOfferFile_actual , $bookMakerOfferFile_expected , 'basic test selector file => bookmaker offer file';
	unlink $bookMakerOfferFile_actual or die;

}
