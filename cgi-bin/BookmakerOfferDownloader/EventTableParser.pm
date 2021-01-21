package EventTableParser;

use strict;
use warnings;

use HTML::Parser;
our @ISA = qw(HTML::Parser);

sub new();

sub append_to_parsingResults($);
sub isInside_tbody();
sub giveMe_linksToEvents($);
sub get_linksToEvents();
sub addLinksToEvent($);

sub get_linksToEvents()
{
        my $self = shift;
        return @{$self->{eventLink_list}};

}

sub addLinksToEvent($)
{
        my $self = shift;
        my ($linkToEvent) = @_;

        push @{$self->{eventLink_list}}, $linkToEvent;

}

sub giveMe_linksToEvents($)
{
        my $self = shift;

        my ($tableOfEvents) = @_;
	$self->parse($tableOfEvents);	
        my @linksToEvents = $self->get_linksToEvents();
        return @linksToEvents; 
}


sub new()
{
	
	my ($class) = @_;
	
	my $self = $class->SUPER::new( api_version => 3, marked_sections => 1 );

        $self->handler(start =>  "start", 'self, tagname, attr, text' );
        $self->handler(end =>  "end", 'self, tagname' );
        $self->handler(text =>  "text", 'self, text' );
        
	#init members
	$self->{numberOfCurrentTableColumn} = 0;
	$self->{inside_td_STATE} = 0;
	$self->{inside_tr_STATE} = 0;
        $self->{eventLink_list} = [];
        $self->{linkToEventInCurrentRow} = '';
        $self->{numberOfBookmakersInCurrentRow} = 0;        

        bless $self, $class; 
        	
        #$self->handler(start =>  "start", 'self, tagname, attr' );
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
	my ($tagname, $attr,  $origtext) = @_;
        

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
		$self->{inside_tr_STATE} = 1;		
	}
        
}

sub end
{
        my $self = shift; 
	my ($tagname, $attr, $attrseq, $origtext) = @_;

	if ($tagname eq 'tr')
	{
		$self->{inside_tr_STATE} = 0;
		$self->{numberOfCurrentTableColumn} = 0;

                if(not $self->{currentEventHasBeenPlayed} and $self->{numberOfBookmakersInCurrentRow} > 0 )
                {
                        $self->addLinksToEvent( $self->{linkToEventInCurrentRow} ); 
                }

                #set default values
                $self->{currentEventHasBeenPlayed} = 0;
                $self->{linkToEventInCurrentRow} = '';
                $self->{numberOfBookmakersInCurrentRow} = 0;        
	}
	
	if ($tagname eq 'td')
        {
                $self->{inside_td_STATE} = 0;
        }

}


1;
