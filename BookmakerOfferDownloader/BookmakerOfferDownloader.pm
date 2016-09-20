package BookmakerOfferDownloader;

use MarathonParser;
use BetexplorerParser;



sub new
{
	my $class = shift;
	my $self = {
			m_parsersList => undef,
			m_downloadedOffer => undef
	
		   };


	my @listOfParser = @{(shift)};
	
#	print "\$class $class \n";
#	print @listOfParser ;

	bless $self, $class;
	$self->initialize(\@listOfParser);

	return $self;

}

sub initialize(@)
{
	my $self = $_[0];
	my @listOfParser = @{$_[1]};


	$self->{m_parsersList} = []; 

	for(@listOfParser)
	{
		my $parser = $_;
		if( $parser eq 'Marathon')
		{
			push  @{$self->{m_parsersList}},  MarathonParser->new() ; 
		}
		elsif( $parser eq 'Betexplorer')
		{
			
			push  @{$self->{m_parsersList}},  BetexplorerParser->new() ; 
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

	for(@{$self->{m_parsersList}}) 
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
