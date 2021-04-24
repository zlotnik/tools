package HTML_EventsTableParser;

use strict;
use warnings;

use HTML::Parser;
our @ISA = qw(HTML::Parser);

sub new();
sub append_to_parsingResults($);
sub isInside_tbody();
sub giveMe_linksToEvents();
sub get_linksToEvents();
sub addLinksToEvent($);
sub giveMeNextEventRow();
sub addEventRow($);


sub addEventRow($)
{
        my $self = shift;
        my ($eventRow) = @_;
        
        push @{$self->{eventRow_list}}, $eventRow;
}

sub get_linksToEvents()
{
        my $self = shift;
        return @{$self->{eventLink_list}};
}

sub giveMeNextEventRow()
{
        my $self = shift;

        my $tableOfEvents = $self->{htmlTableWithEvents}; 
         
        my $rowNumberToGet = $self->{lastFetchedRowNumber} + 1;

        if( defined  ${$self->{eventRow_list}}[$rowNumberToGet] )
        {
                $self->{lastFetchedRowNumber} = $rowNumberToGet;
                return ${$self->{eventRow_list}}[$rowNumberToGet];
        }
        else
        {
                return '';
        }
} 

sub addLinksToEvent($)
{
        my $self = shift;
        my ($linkToEvent) = @_;
        
        push @{$self->{eventLink_list}}, $linkToEvent;

}

sub giveMe_linksToEvents()
{
        my $self = shift;

        my $tableOfEvents = $self->{htmlTableWithEvents}; 

        my @linksToEvents = $self->get_linksToEvents();
        return @linksToEvents; 
}


sub new()
{
	
	my ($class, $eventTable_html) = @_;
	
	my $self = $class->SUPER::new( api_version => 3, marked_sections => 1 );

        $self->handler(start =>  "start", 'self, tagname, attr, text' );
        $self->handler(end =>  "end", 'self, tagname, text' );
        $self->handler(text =>  "text", 'self, text' );
        
	#init members
	$self->{numberOfCurrentTableColumn} = 0;
	$self->{inside_td_STATE} = 0;
	$self->{inside_tr_STATE} = 0;
        $self->{eventLink_list} = [];
        $self->{eventRow_list} = [];
        $self->{linkToEventInCurrentRow} = '';
        $self->{numberOfBookmakersInCurrentRow} = 0;        
        $self->{currentRowNumber} = 0;        
        $self->{currentRowContent} = '';
        $self->{lastFetchedRowNumber} = -1;

        bless $self, $class; 
            	
        $self->{htmlTableWithEvents} = $eventTable_html; 
	$self->parse( $eventTable_html );	

	return $self;
}

sub text
{

        my $self = shift; 
        
	my ($text) = @_;

        if ($self->isItResultCell() )
        {

                if ( $text ) #text length
                {
                     $self->{currentEventHasBeenPlayed} = 1;
                }
                else
                {
                     $self->{currentEventHasBeenPlayed} = 0;
                }
        }

        if ( $self->isItNumberOfBookmakersCell() )
        {
                if($text =~ /^\d+$/ )
                {
                        $self->{numberOfBookmakersInCurrentRow} = int($text);        
                }

        }

        if ($self->{inside_tr_STATE})
        {
               $self->{currentRowContent} .= $text;
        }
}


sub isItResultCell();
sub isItResultCell()
{
        my $self = shift; 
        if( $self->{numberOfCurrentTableColumn} == 10 and $self->{inside_td_STATE}  )
        {
                return 1;
        }
        return 0;
}

sub isItNumberOfBookmakersCell()
{
        my $self = shift; 
        if( $self->{numberOfCurrentTableColumn} == 5 and $self->{inside_td_STATE}  )
        {
                return 1;
        }
        return 0;
}

sub start 
{ 
        my $self = shift; 
	my ($tagname, $attr, $origtext) = @_;
        

	if ($tagname eq 'a') 
	{
                if( $self->{numberOfCurrentTableColumn} == 2 ) #this could be encapsulate
                {
		    my $linkToEvent = ${$attr}{'href'};
                    $self->{linkToEventInCurrentRow} = $linkToEvent;
                }
	}

	if ($tagname eq 'td') 
	{
	        $self->{numberOfCurrentTableColumn}++;
                $self->{inside_td_STATE} = 1;
	}

	if ($tagname eq 'tr') 
	{		
                $self->{currentRowNumber}++;
		$self->{inside_tr_STATE} = 1;		
	}
        
        if ($self->{inside_tr_STATE})
        {
               $self->{currentRowContent} .= $origtext;
        }
       
}

sub end
{
        my $self = shift; 
	my ($tagname, $origtext) = @_;

	if ($tagname eq 'tr')
	{
		$self->{inside_tr_STATE} = 0;
		$self->{numberOfCurrentTableColumn} = 0;
                $self->{currentRowContent} .= "${origtext}\n";

                if(not $self->{currentEventHasBeenPlayed} and $self->{numberOfBookmakersInCurrentRow} > 0 )
                {
                        $self->addLinksToEvent( $self->{linkToEventInCurrentRow} ); 
                        $self->addEventRow( $self->{currentRowContent} );
                        
                }

                #set default values
                $self->{currentEventHasBeenPlayed} = 0;
                $self->{linkToEventInCurrentRow} = '';
                $self->{numberOfBookmakersInCurrentRow} = 0;        
                $self->{currentRowContent} = '';
	}
	
	if ($tagname eq 'td')
        {
                $self->{inside_td_STATE} = 0;
        }

	if ($tagname ne 'tr' and $self->{inside_tr_STATE} )
        {
                $self->{currentRowContent} .= $origtext;
        }
}


1;
