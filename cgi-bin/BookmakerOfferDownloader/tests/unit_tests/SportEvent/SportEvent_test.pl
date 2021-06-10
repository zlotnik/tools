#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;
use Test::File::Contents;
use File::Copy 'cp'; 
use SportEvent;
use HTML_EventsTableParser_mock;
use Test::MockModule;
use Data::Dumper;

###############SUB PROTOTYPES############################################
sub fillEventData();
sub insertIntoSelectorFile();
sub escapeNotLegitXmlNodeNameInXpath();
############################MAIN##############################################
print("\n##Testing module SportEvent##\n\n");

escapeNotLegitXmlNodeNameInXpath();
fillEventData();
insertIntoSelectorFile();
#addNewEventsNode();
done_testing();

####################SUB DEFINITIONS############################################

sub escapeNotLegitXmlNodeNameInXpath()
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";

        my $incorectXpath = "/note/data/soccer/Germany/2-bundesliga";

        my $expected = "/note/data/soccer/Germany/__2-bundesliga";

        SportEvent::escapeNotLegitXmlNodeNameInXpath($incorectXpath);
        my $actual = $incorectXpath;

	is( $actual , $expected, 'Test escaping illegal node part from xpath' );

}

sub fillEventData()
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";
         
        my  $html_EventsTableParser_mock = Test::MockModule->new('HTML_EventsTableParser');
        $html_EventsTableParser_mock->redefine( 'giveMeNextEventRow', \&HTML_EventsTableParser_mock::giveMeNextEventRow );
        my $eventTableParser = HTML_EventsTableParser->new('');
        my $eventRowFromMock = $eventTableParser->giveMeNextEventRow();
        
        
        #my $sportEventMock = Test::MockModule->new('SportEvent')->redefine( new => sub{});
	my $sportEvent = SportEvent->new( 'unused argument' ); 
        $sportEvent->{eventDataHtmlRow} = $eventRowFromMock;
        $sportEvent->fillEventData();


        my $homeTeam_expected = 'Sonderjyske';	
	is( $sportEvent->{homeTeam} , $homeTeam_expected, 'Test if home team is filled' );

        my $visitingTeam_expected = 'Odense';
	is( $sportEvent->{visitingTeam} , $visitingTeam_expected, 'Test if visiting team is filled' );

        my $linkToEvent_expected = 'http://www.betexplorer.com/soccer/World/club-friendly/sonderjyske-odense/ENIWBJAR/';
	is( $sportEvent->{linkToEvent} , $linkToEvent_expected, 'Test if link to event is filled' );

        my $relativePathToLeague_expected = 'soccer/World/club-friendly';
	is( $sportEvent->{relativePathToLeague} , $relativePathToLeague_expected, 'Test if relative path to the league to event is filled' );
}

sub insertIntoSelectorFile()
{
	my $subroutineName = get_subroutineName();
	print "\nTESTING SUBROUTINE: $subroutineName\n";
        
        my $unit_testDirectory = "$ENV{BACKEND_ROOT_DIRECTORY}/BookmakerOfferDownloader/tests/unit_tests/SportEvent";
	my $subroutine_unitTest_directory = "${unit_testDirectory}/$subroutineName";

        my $sportEventMock = Test::MockModule->new('SportEvent')->redefine( new => sub{return bless{},'SportEvent'; });
	my $sportEvent = SportEvent->new( 'unused argument' ); 

        #better as just one assingnemnt
        $sportEvent->{homeTeam} = 'Slask Wroclaw';
        $sportEvent->{visitingTeam} = 'Zaglebie Lubin';
        $sportEvent->{linkToEvent} = 'https://www.betexplorer.com/soccer/Poland/ekstraklasa/slask-zaglebie/rtrqQVel/';
        $sportEvent->{relativePathToLeague} = 'soccer/Poland/ekstraklasa/';
       
        my $selectorFile = "${subroutine_unitTest_directory}/selector_with_events_node_poland.xml";
        my $sportEventsFile_actual = "${subroutine_unitTest_directory}/sportEventsPoland_actual.xml";
        my $sportEventsFile_expected = "${subroutine_unitTest_directory}/sportEventsPoland_expected.xml";
        
        cp( $selectorFile, $sportEventsFile_actual ) or die $!;

        $sportEvent->insertIntoSelectorFile( $sportEventsFile_actual );

        files_eq( $sportEventsFile_actual , $sportEventsFile_expected , "Testing inserting event into selector file" );


        $sportEvent->{homeTeam} = 'Hamburger SV';
        $sportEvent->{visitingTeam} = 'Karlsruher SC';
        $sportEvent->{linkToEvent} = 'https://www.betexplorer.com/soccer/germany/2-bundesliga/hamburger-karlsruher/KII7KkM6/';
        $sportEvent->{relativePathToLeague} = '/soccer/germany/2-bundesliga/';

        $selectorFile = "${subroutine_unitTest_directory}/selector_with_events_node_germany.xml";
        $sportEventsFile_actual = "${subroutine_unitTest_directory}/sportEventsGermany_actual.xml";
        $sportEventsFile_expected = "${subroutine_unitTest_directory}/sportEventsGermany_expected.xml";
        
        cp( $selectorFile, $sportEventsFile_actual ) or die $!;
        $sportEvent->insertIntoSelectorFile( $sportEventsFile_actual );

        files_eq( $sportEventsFile_actual , $sportEventsFile_expected , "Testing inserting event into selector for Germany (contains escaped node name: 2_bundesliga) " );
} 

sub addNewEventsNode()
{
        ...;
}

sub get_subroutineName()
{	
	my $calingFunctionName = (caller(1))[3] ;
	$calingFunctionName =~ /main::(.*)/;
	return  $1 ;
}

