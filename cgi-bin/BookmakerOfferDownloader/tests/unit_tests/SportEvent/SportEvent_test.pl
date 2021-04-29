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
sub downloadEventData();
############################MAIN##############################################
print("\n##Testing module SportEvent##\n\n");

fillEventData();
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
        
	my $sportEvent = SportEvent->new( $eventRowFromMock ); 


        my %expected = ( pathToEvent => 'https://www.betexplorer.com/soccer/Poland/ekstraklasa/jagiellonia-cracovia/fslbChRk/',
                         homeTeam => 'Jagiellonia',
                         visitingTeam => 'Cracovia'
                        );
	#my @actual = $a_betExplorerDownloader->downloadLeaguesNames ( '/soccer/Serbia' );
	#my $testName = 'fetching leagues list from stubed website';
	
	is_deeply( $a_SportEvent , \%expected, 'Test if details of SportEvent are filled' );

}

sub find_countries_xpaths_mock
{
	return('/note/data/soccer/Serbia'); 
}


sub find_leagues_xpaths_mock
{
        return('/note/data/soccer/Poland/ekstraklasa'); 
}

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

sub downloadEventsURLs_mock
{
        return('https://www.betexplorer.com/soccer/Poland/ekstraklasa/korona-kielce-plock/6L7f5jc4/',
               'https://www.betexplorer.com/soccer/Poland/ekstraklasa/jagiellonia-lech-poznan/SU8j6Wsb/');
}

sub get_subroutineName()
{	
	my $calingFunctionName = (caller(1))[3] ;
	$calingFunctionName =~ /main::(.*)/;
	return  $1 ;
}
