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

        my @expected = ('a',
                        'q');

	my $betExplorerParser_mock = Test::MockModule->new('BetexplorerParser');#change capitalization of module

	#return pickupLinksToEventFromTable(pickupTableWithEventsFromWeburl($link));
	$betExplorerParser_mock->redefine( 'pickupTableWithEventsFromWeburl', \&BetexplorerParser_mock::pickupTableWithEventsFromWeburl );
	$betExplorerParser_mock->define( 'pi', \&testMock);
        my $object = BetexplorerParser->new();
        BetexplorerParser::pickupTableWithEventsFromWeburl('i'); 
        #$object->pi('');
        BetexplorerParser::pi('sssss');

        #my @actual = $a_betExplorerDownloader->downloadEventURLs( '/soccer/Poland/ekstraklasa' );
        #my $testName = 'fetching event list from stubed website';

        #is_deeply( \@actual, \@expected, $testName );

}

sub get_subroutineName()
{	
	my $calingFunctionName = (caller(1))[3] ;
	$calingFunctionName =~ /main::(.*)/;
	return  $1 ;
}
