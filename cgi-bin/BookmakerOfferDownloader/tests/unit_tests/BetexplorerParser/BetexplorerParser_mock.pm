#!/usr/bin/perl -w
package BetexplorerParser_mock;
use strict;
use warnings;


our @EXPORT = qw( pickupLinksToEventFromTable );

sub get_subroutineName();
sub pickupLinksToEventFromTable($)
{
        print "TEST"; 
};

sub pickupTableWithEventsFromWeburl($)
{
        my ($leagueGroupEvents_url) = @_; 
        my $sub_name = get_subroutineName(); 
        my $mockData_file = "${sub_name}/dataForMock";
        my $mockData_fileContent;
        open(FH, '<', $mockData_file) or die "can not open file $mockData_file";

        local $/ = undef;
        $mockData_fileContent = <FH>;
        close FH;
        return $mockData_fileContent;
};

#should be moved to Toolbox
#rename Toolbox
sub get_subroutineName()
{	
	my $calingFunctionName = (caller(1))[3] ;
	$calingFunctionName =~ /_mock::(.*)/;
	return  $1 ;
}

1;
