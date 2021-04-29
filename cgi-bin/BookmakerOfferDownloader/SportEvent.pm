package SportEvent;
use strict;
use warnings;
#use BookmakerPageCrawler;

sub new($);
sub insertIntoSelectorFile($);
sub downloadEventData();
sub set_useStubNet();
sub isNotEmpty();



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

sub set_useStubNet()
{
        my $self = shift;

        my $mockedOrRealWWW_argument = '--mockednet';
        $self->{m_BookmakerPageCrawler} = BookmakerPageCrawler->new($mockedOrRealWWW_argument);

}

sub fillEventData();
sub fillEventData()
{
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

sub insertIntoSelectorFile($);
sub insertIntoSelectorFile($)
{
        my $self = shift;
        my ($selectorFileWithLeague) = @_;
}

1;
