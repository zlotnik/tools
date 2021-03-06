#!/usr/bin/perl -w
package BetexplorerParser;

use HTML_EventsTableParser;

our @EXPORT = qw(pickupLinksToEventFromTable pickupTableWithEventsFromWeburl);

use strict;
use warnings;
use POSIX ":sys_wait_h"; #isit needed?
use 5.010;
use WojtekToolbox;
############ TODO ###################################
# check if ignoring event links without any bookmaker data works

############ SUB PROTOTYPES ###################################
sub getsLinksForAllEventsFromSubCategory($$);
sub pickupTableWithEventsFromWeburl($);
sub pickupLinksToEventFromTable($);
sub getRawDataOfEvent($);
############# SUBS DEFINITIONS ################################


sub getRawDataOfEvent($)
{
	my $linkToEvent = $_[0];
	createJavaScriptForDownload($linkToEvent);
		
	my $res = 0;
	my $retryIdx = 0; 
	my $toReturn = '';
	
	my $pid = fork();
	if(not $pid)
	{
		my $toReturnInChild = `phantomjs.exe download1x2Data.js`;
		open RAWDATA , ">", 'rawdataevent.txt' or die;
		print RAWDATA $toReturnInChild;
		close RAWDATA or die;
		#print STDOUT "before exit\n";		
		exit(1);
	}
	else
	{
		while($res == 0 and $retryIdx++ < 3)
		{
			sleep(26);
			$res = waitpid($pid, WNOHANG);
			print STDOUT "no answer from $linkToEvent  attemp no $retryIdx\n";					
		}
	}
	
	
	if($res == 0)
	{
		kill 9, $pid;
		print STDOUT "UNABLE TO FETCH $linkToEvent PID $pid RESPONSE $res\n";
	}
	else 
	{
		#print STDOUT "process $pid finished\n";
		open(my $fh, '<', 'rawdataevent.txt') or die "cannot open file rawdataevent.txt";
		{
			local $/;
			$toReturn = <$fh>;;
		}
		close $fh or die;
	
	}
	
	
	
	return $toReturn;
}

sub createJavaScriptForDownload($)
{
	my $linkToReplace = $_[0];
	
	open( TEMPLATE  , "<" , 'download1x2Data_template.js') or die;
	
	open( JAVASCRIPT  , ">" , 'download1x2Data.js') or die;
	
	while(<TEMPLATE>)
	{
		my $line = $_;
		if ($line =~ /(.*)(__URL_TO_FILL__)(.*)/)
		{
			print JAVASCRIPT $1.$linkToReplace.$3."\n"; 
		}
		else
		{
			print JAVASCRIPT $line;
		}
	}
	close(JAVASCRIPT)or die;
	close(TEMPLATE)or die;

}

sub getsLinksForAllEventsFromSubCategory($$)
{
	my $categoryName = $_[0];
	my $subCategoryName = $_[1];
	my $link = 'http://www.betexplorer.com/soccer/' .  $categoryName .'/'. $subCategoryName;
	
	my $content  = tryToGetUrl($link, 3) or die "unable to get $link \n";
        
	
	return pickupLinksToEventFromTable(pickupTableWithEventsFromWeburl($link));
	die "bug: getRelativeLinksToEventFromTable after go through array and ad prefix address "; 

	#print $content;
};

sub pickupLinksToEventFromTable($)
{

	my $tableWithEvents = $_[0];
	my @linksToEvents;	

        #parseEventsTable();
        #getListOfLinksToEvent();
        my $eventTableParser = HTML_EventsTableParser->new( $tableWithEvents );
        my @listOfLinksToEvents = $eventTableParser->giveMe_linksToEvents();

        my @toReturn;
        foreach( @listOfLinksToEvents )
        {
                my $absolutePathToEvent = 'https://www.betexplorer.com' . $_ ; 
                push @toReturn, $absolutePathToEvent;
        }

        return @toReturn;
}
	
			
			

sub eventInLinkAlreadyPlayed($)
{

	my $linkToEvent = $_[0];

}

sub pickupHtmlEventsTableFromLeagueHtml($);
sub pickupHtmlEventsTableFromLeagueHtml($)
{
        my ( $contentOfLeaguePage ) = @_;

        my $htmlTableWithEvents = '';
	my $regexp = '(<table)([\s\S]*?)(<td class=\"table-main__daysign\")([\s\S]*?)(</table>)';
	if( $contentOfLeaguePage =~ m|${regexp}|m )
	{
	        $htmlTableWithEvents = $1.$2.$3.$4.$5;
	}

        return $htmlTableWithEvents;

}

sub pickupTableWithEventsFromWeburl($)
{
	#open OUTPUT, '>', "output.txt" or die "Can't create filehandle: $!";
	#select OUTPUT;
	my $link = $_[0];
	my $htmlPageWithEvents = tryToGetUrl($link, 3) or die " BetexplorerParser: unable to get $link \n";
	
	$htmlPageWithEvents =~ m|(<td class=\"table-main__daysign\")([\s\S]*?)(</table>)|m or die "It hasn't been possible to parse table with events from given URL: $link";	
	return $1.$2.$3;
}

1;




