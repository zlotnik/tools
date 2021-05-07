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
############################MAIN##############################################
print("\n##Testing module SportEvent##\n\n");

fillEventData();
insertIntoSelectorFile();
#addNewEventsNode();
done_testing();

####################SUB DEFINITIONS############################################

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
        $sportEvent->{pathToEvent} = 'https://www.betexplorer.com/soccer/Poland/ekstraklasa/slask-zaglebie/rtrqQVel/';
        $sportEvent->{relativePathToLeague} = 'soccer/Poland/ekstraklasa/';
       
        my $selectorFile = "${subroutine_unitTest_directory}/selector_with_events_node_poland.xml";
        my $sportEventsFile_actual = "${subroutine_unitTest_directory}/sportEvents_actual.xml";
        my $sportEventsFile_expected = "${subroutine_unitTest_directory}/sportEvents_expected.xml";
        
        cp( $selectorFile, $sportEventsFile_actual ) or die $!;

        $sportEvent->insertIntoSelectorFile( $sportEventsFile_actual );

        files_eq( $sportEventsFile_actual , $sportEventsFile_expected , "Testing inserting event into selector file" );
        
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

