package HTML_EventsTableParser_mock;
use strict;
use warnings;


#our @EXPORT = qw( giveMeNextEventRow );


sub giveMeNextEventRow();
sub get_subroutineName();
sub pickupHtmlEventsTableFromLeagueHtml();


sub giveMeNextEventRow()
{
        return "test abc";
};


sub pickupTableWithEventsFromWeburl($)
{
        my ($leagueGroupEvents_url) = @_; 
        my $sub_name = get_subroutineName(); 
        my $betexplorerParserDir = "$ENV{BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY}/tests/unit_tests/BetexplorerParser";
        my $mockData_file = "${betexplorerParserDir}/${sub_name}/dataForMock";
        my $mockData_fileContent;
        open(FH, '<', $mockData_file) or die "can not open file $mockData_file";

        local $/ = undef;
        $mockData_fileContent = <FH>;
        close FH;
        return $mockData_fileContent;
};

#this should joined as one united as one procedure
sub pickupHtmlEventsTableFromLeagueHtml()
{
        my ($leagueGroupEvents_url) = @_; 
        my $sub_name = get_subroutineName(); 
        my $betexplorerParserDir = "$ENV{BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY}/tests/unit_tests/BetexplorerParser";
        my $mockData_file = "${betexplorerParserDir}/${sub_name}/dataForMock";
        my $mockData_fileContent;
        open(FH, '<', $mockData_file) or die "can not open file $mockData_file";

        local $/ = undef;
        $mockData_fileContent = <FH>;
        close FH;
        return $mockData_fileContent;

}

#should be moved to Toolbox
#rename Toolbox
sub get_subroutineName()
{	
	my $calingFunctionName = (caller(1))[3] ;
	$calingFunctionName =~ /_mock::(.*)/;
	return  $1 ;
}

1;
