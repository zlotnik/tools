package SportEvent;
use strict;
use warnings;
use XML::LibXML; 
use XML::Tidy;

sub new($);
sub insertIntoSelectorFile($);
sub downloadEventData();
sub set_useStubNet();
sub isNotEmpty();
sub fillEventData();
sub insertIntoSelectorFile($);

sub isNotEmpty()
{
        return '';
};

sub new($)
{

        my $class = shift;

        my ( $eventDataHtmlRow ) = @_;
        my $self = bless {}, $class;
        
        $self->{eventDataHtmlRow} = $eventDataHtmlRow;

        #$self->{pathToEvent} = $pathToEvent;
	#my $mockedOrRealWWW_argument = '--realnet';
        #$self->{m_BookmakerPageCrawler} = BookmakerPageCrawler->new($mockedOrRealWWW_argument);

        #$self->downloadEventData();
        return $self;
}


sub fillEventData()
{
        ...
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

sub addNewEventsNode($)
{
        my $self = shift;
        my ( $pathToLeague ) = @_;
        ...;         
}

sub correctFormatXmlDocument($);
sub insertVisitingTeamIntoEventNode();
sub insertHomeTeamIntoEventNode();

sub insertIntoSelectorFile($)
{
        my $self = shift;
        my ($selectorFileWithLeague) = @_;

	my $xmlParser = XML::LibXML->new; 
     
	my $document = $xmlParser->parse_file( $selectorFileWithLeague ) or die $?;

        my $xpathToLeague = "/note/data/" . $self->{relativePathToLeague};
        
        #check if events node exists # maybe events node wouldn't be needed
        #$self->addNewEventsNode( $xpathToLeague );
        
        my $pathToEventsNode = "${xpathToLeague}/events";
         
	my $eventsNode = $document->findnodes( $pathToEventsNode )->[0] or die "Can't find xml node specify by xpath:$pathToEventsNode xml\n $document\n";
        
        my $newEventNode = XML::LibXML::Element->new( 'event' );
        $newEventNode->setAttribute( 'url', $self->{pathToEvent} );
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
