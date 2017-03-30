package BookmakerOfferDownloader;

use MarathonParser;
use BetexplorerParser;
use BookmakerXmlDataParser;


sub new
{
	my $class = shift;
	my $self = {
			m_BookmakerParsersList => undef,
			m_downloadedOffer => undef
	
		   };
		   
	my @listOfParser = @{(shift)};
	
	bless $self, $class;
	$self->initialize(\@listOfParser);

	return $self;

}

sub initialize(@)
{
	my $self = $_[0];
	my @listOfParser = @{$_[1]};


	$self->{m_BookmakerParsersList} = []; 
	$self->{m_BookmakerXmlDataParser} = BookmakerXmlDataParser->new();  
	
	for(@listOfParser)
	{
		my $parser = $_;
		if( $parser eq 'Marathon')
		{
			push  @{$self->{m_BookmakerParsersList}},  MarathonParser->new() ; 
		}
		elsif( $parser eq 'Betexplorer')
		{
			
			push  @{$self->{m_BookmakerParsersList}},  BetexplorerParser->new() ; 
		}
		else
		{
			die "Unsupported parser $parser"
		}
	
	}

}

sub downloadOffer(@)
{
	
	my $self = $_[0];

	for(@{$self->{m_BookmakerParsersList}}) 
	{
		my $currentParser = $_;
		$currentParser->downloadOffer();

		#$downloadOffer .= $m_parsers->downloadOffer();
	}
	#mergeXml();

};

sub mergeXml()
{


}

1;
