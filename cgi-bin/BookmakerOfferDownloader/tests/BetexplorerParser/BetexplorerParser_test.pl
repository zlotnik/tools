#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;
use Test::File::Contents;
use File::Copy 'cp'; 
use BetexplorerParser;
use BetexplorerParser_mock;
use Test::MockModule;

###############SUB PROTOTYPES############################################
sub pickupLinksToEventFromTable();
sub get_subroutineName(); #move it to some external package
############################MAIN##############################################
print("\n##Testing module BetexplorerParser##\n\n");
pickupLinksToEventFromTable();

done_testing();


sub testMock($)
{
        my ($firstArgument) = @_;
        print 'aaa'.$firstArgument;
        
}
####################SUB DEFINITIONS############################################
sub pickupLinksToEventFromTable()
{

        my $subroutineName = get_subroutineName();
        print "\nTESTING SUBROUTINE: $subroutineName\n";

        #my $a_betExplorerDownloader = BetExplorerDownloader->new('--mockednet');

        my @expected = ('https://www.betexplorer.com/soccer/World/club-friendly/cracovia-puszcza/jVC8JIMR/',
                        'https://www.betexplorer.com/soccer/World/club-friendly/hlucin-dolni-benesov/h2gDDRYG/',
                        'https://www.betexplorer.com/soccer/World/club-friendly/young-africans-simba/Y3ZjIBD2/',
                        'https://www.betexplorer.com/soccer/World/club-friendly/sonderjyske-odense/ENIWBJAR/',
                        'https://www.betexplorer.com/soccer/World/club-friendly/din-zagreb-mol-fehervar-fc/pGtkj3pQ/',
                        'https://www.betexplorer.com/soccer/World/club-friendly/lok-plovdiv-maritsa-plovdiv/8zwpFesd/'
                        );

        @expected =     (
                        'https://www.betexplorer.com/soccer/World/club-friendly/sonderjyske-odense/ENIWBJAR/',
                        'https://www.betexplorer.com/soccer/World/club-friendly/din-zagreb-mol-fehervar-fc/pGtkj3pQ/',
                        'https://www.betexplorer.com/soccer/World/club-friendly/neftci-baku-keshla/rPynXyiR/'
                        );

	my $betExplorerParser_mock = Test::MockModule->new('BetexplorerParser');#change capitalization of module

	#return pickupLinksToEventFromTable(pickupTableWithEventsFromWeburl($link));
	$betExplorerParser_mock->redefine( 'pickupTableWithEventsFromWeburl', \&BetexplorerParser_mock::pickupTableWithEventsFromWeburl );
        #my $object = BetexplorerParser->new();

        my $unusedArgument = ('https://www.betexplorer.com/soccer/germany/bundesliga/');
        
        my $htmlTableWithSportEvents = BetexplorerParser::pickupTableWithEventsFromWeburl( $unusedArgument );
        
        my @actual = BetexplorerParser::pickupLinksToEventFromTable( $htmlTableWithSportEvents ); 

        my $testName = "Testing pickup links to events with bookmaker offer from html event table";
        is_deeply( \@actual, \@expected, $testName );

}

sub get_subroutineName()
{	
	my $calingFunctionName = (caller(1))[3] ;
	$calingFunctionName =~ /main::(.*)/;
	return  $1 ;
}
