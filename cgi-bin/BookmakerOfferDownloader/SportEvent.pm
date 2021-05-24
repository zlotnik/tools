package SportEvent;
use strict;
use warnings;
use XML::LibXML; 
use XML::Tidy;
use HTML::Parser;
our @ISA = qw(HTML::Parser); #isit needed?
#use parent 'HT.. ?

sub new($);
sub insertIntoSelectorFile($);
sub downloadEventData();
sub set_useStubNet();
sub isNotEmpty();
sub fillEventData();
sub correctFormatXmlDocument($);
sub insertVisitingTeamIntoEventNode();
sub insertHomeTeamIntoEventNode();


sub isNotEmpty()
{
        return '';
};

sub new($)
{

        my $class = shift;

        my ( $eventDataHtmlRow ) = @_;

        my $self = $class->SUPER::new( api_version => 3, marked_sections => 1 );

        $self->handler(start =>  "start", 'self, tagname, attr, text' );
        $self->handler(end =>  "end", 'self, tagname, text' );
        $self->handler(text =>  "text", 'self, text' );

        $self->{eventDataHtmlRow} = $eventDataHtmlRow;

        $self->{inside_linkToEvent_STATE} = 0;
        $self->{spanIdxInsideLinkToEvent} = 0;
        $self->{insideSpan_STATE} = 1;

        bless $self, $class;

        return $self;
}


sub start
{ 
        my $self = shift; 
	my ($tagname, $attr, $origtext) = @_;

	if ($tagname eq 'a') 
	{
                $self->{inside_linkToEvent_STATE} = 1;
		my $linkToEvent = ${$attr}{'href'}; #relative
                if( $linkToEvent !~ /javascript|myselections\.php|\/bookmaker/ ) #isnt tidy probably mocked data might be corupted however at this point it is easier to do so
                {
                        $self->{linkToEvent} = "http://www.betexplorer.com${linkToEvent}"; #might be written better
                        
                        $linkToEvent =~ m|/(\w+)(/\w+)(/.+?)/|;
                        $self->{relativePathToLeague} = $1.$2.$3;
                }
	}

        if( $tagname eq 'span' and  $self->{inside_linkToEvent_STATE} == 1 )
        {
                $self->{spanIdxInsideLinkToEvent}++;
                $self->{insideSpan_STATE} = 1;
        }

}

sub text
{
        my $self = shift;
	my ($text) = @_;

        if( $self->{inside_linkToEvent_STATE} == 1 and  $self->{insideSpan_STATE} == 1)
        {
                if($self->{spanIdxInsideLinkToEvent} == 1)
                {
                        $self->{homeTeam} = $text;
                }
                if($self->{spanIdxInsideLinkToEvent} == 2)
                {
                        $self->{visitingTeam} = $text;
                }

        }

}

sub end
{
        my $self = shift;
	my ($tagname, $attr, $attrseq, $origtext) = @_;

	if ($tagname eq 'a')
        {
                $self->{inside_linkToEvent_STATE} = 0;
                $self->{spanIdxInsideLinkToEvent} = 0; #number not index
        } 

         
        if( $tagname eq 'span' )
        {
                $self->{insideSpan_STATE} = 0;
        }
}

sub fillEventData()
{
        my $self = shift;
        my $sportEventRow = $self->{eventDataHtmlRow};
        
        $self->parse( $sportEventRow );
}

sub downloadEventData()
{
        my $self = shift;
        my $linkToEvent = $self->{pathToEvent};
	#my $dataWithBets = $self->{m_BookmakerPageCrawler}->getRawDataOfEvent($linkToEvent);
	my $dataWithBets = $self->{m_BookmakerPageCrawler}->get($linkToEvent);
        #print $dataWithBets;
        $self->{homeTeam} = 'wrongTeam';
        #findHomeTeamName()
        #findVisitorName()
}

#do I need that?
sub addNewEventsNode($)
{
        my $self = shift;
        my ( $pathToLeague ) = @_;
        ...;         
}

sub insertIntoSelectorFile($)
{
        my $self = shift;
        my ($selectorFileWithLeague) = @_;

	my $xmlParser = XML::LibXML->new; 
     
	my $document = $xmlParser->parse_file( $selectorFileWithLeague ) or die $?;

        my $xpathToLeague = "/note/data/" . $self->{relativePathToLeague};
        
        my $pathToEventsNode = "${xpathToLeague}/events";
         
        if( not $document->findnodes( $pathToEventsNode )->[0] ) #this part probably can be withdrawned because events node seems to not be needed
        {
                my $newEventsNode = XML::LibXML::Element->new( 'events' );
                my $xpathToLeagueWithoutSlash = $xpathToLeague;
                #chop $xpathToLeagueWithoutSlash;
                my $leagueNode = $document->findnodes( $xpathToLeagueWithoutSlash )->[0]; 
                $leagueNode->addChild( $newEventsNode );
        }

	my $eventsNode = $document->findnodes( $pathToEventsNode )->[0] or die "Can't find xml node specify by xpath:$pathToEventsNode xml\n $document\n";
        
        my $newEventNode = XML::LibXML::Element->new( 'event' );
        $newEventNode->setAttribute( 'url', $self->{linkToEvent} );
        $self->insertHomeTeamIntoEventNode( $newEventNode );
        $self->insertVisitingTeamIntoEventNode( $newEventNode ); #better name

	$eventsNode->addChild( $newEventNode );	

	$document->toFile( $selectorFileWithLeague) or die $?;	
        correctFormatXmlDocument( $selectorFileWithLeague );
}

sub insertVisitingTeamIntoEventNode()
{
        my $self = shift;
        my ($selectorXmlDoc) = @_;

        my $visitingTeamName = $self->{visitingTeam};
        
        my $visitingTeamNode =  XML::LibXML::Element->new( 'visitingTeam' ); 
        $visitingTeamNode->appendText( $visitingTeamName );
        $selectorXmlDoc->addChild( $visitingTeamNode );

}

sub insertHomeTeamIntoEventNode()
{
        my $self = shift;
        my ($selectorXmlDoc) = @_;

        my $homeTeamName = $self->{homeTeam};
        
        my $homeTeamNode =  XML::LibXML::Element->new( 'homeTeam' ); 
        $homeTeamNode->appendText( $homeTeamName );
        $selectorXmlDoc->addChild( $homeTeamNode );

}


#move to a common place
sub correctFormatXmlDocument($) 
{

        my ( $pathToXmlDocumentToCorrect ) = @_;
	my $tidy_obj = XML::Tidy->new('filename' => $pathToXmlDocumentToCorrect);

	$tidy_obj->tidy();
	$tidy_obj->write();
}
1;
