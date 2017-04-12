package BookmakerXmlDataParser;
use base 'Exporter';
our @EXPORT = qw(isCorectBookmakersOfferFile isCorectBookmakerDataSelectorFile);
#nice to have; tool to create templates for files .pm, .pl   
#move all parsers to new directory
#think about code coverage
#incorrect inputs should be
##################DECLARATION##################################
sub new();
sub isCorectBookmakerDataSelectorFile($);
sub isCorectBookmakersOfferFile($);
sub xmlSelectorContainsAllNeededData($);
sub isCorrectBookmakerDataSourceName($);
sub isCorrectDisciplineName($);
#################DEFINITION####################################
sub new()
{
	my $class = shift;
	my $self = bless {}, $class;
	return $self;
};

sub isCorectBookmakerDataSelectorFile($)
{
	my $self = shift;
	my $pathToXmlSelector = $_[0];
	my $xmlParser = XML::LibXML->new; 
	my $isCorrectXmlFile = $xmlParser->parse_file($pathToXmlSelector); 
	
	#$self->xmlSelectorContainsAllNeededData($pathToXmlSelector) #instead of invoking classs without reference to object
	if ( $isCorrectXmlFile and xmlSelectorContainsAllNeededData($pathToXmlSelector) )
	{
		return 1;
	}
	return 0;
};

sub isCorectBookmakersOfferFile($)
{
	my $self = shift;
};

sub isCorrectEventListFile($)
{
	my $self = shift;
	return 0;
};

sub xmlSelectorContainsAllNeededData($)
{
	#my $self = shift;
	my $xmlSelectorPath = $_[0];
	return (isOneOrMoreBookmakersSpecifiedInXmlSelector($xmlSelectorPath) and isOneOrMoreDyscyplineSpecified($xmlSelectorPath));

};

sub isOneOrMoreBookmakersSpecifiedInXmlSelector($)
{
	#my $self = shift;
	my $xmlSelectorPath = $_[0];
		
	if(countHowManyBookmakerIsChoosedInXmlSelector($xmlSelectorPath) > 0)
	{
		return 1;
	}
	return 0;
		
};

sub countHowManyBookmakerIsChoosedInXmlSelector($)
{
	#my $self = shift;
	
	my $pathToXmlSelector = $_[0];
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($pathToXmlSelector); 
	
	
	my $choosenBookmakers = $xmlParserDoc->findnodes("/note/dataSources")->[0];
	
	
	if (not defined($choosenBookmakers))
	{
		return 0 ;
		#'Iam not sure if it is correct formula';
	}

	my $dataSource = 0;
	foreach($choosenBookmakers->nonBlankChildNodes())
	{
		
		my $dataSourceNameXmlNode = $_;
		my $dataSourceName = $dataSourceNameXmlNode->nodeName;
		if(isCorrectBookmakerDataSourceName($dataSourceName))
		{
			$dataSource++;			
		}
		else
		{
			return 0; #instead of returning 0 should be parser validating all bookmakers and requirement that all bookmaker name must be 'legal'
		}
	}
	return $dataSource;
}

sub isCorrectBookmakerDataSourceName($)
{
	#my $self = shift;
	my $bookmakerNamer = $_[0];
	if( 'betexplorer' eq $bookmakerNamer)
	{
		return 1;
	}
	return 0;
}
	


sub isCorrectDisciplineName($)
{
	#my $self = shift;
	
	my $disciplineName = $_[0];
	my @supportedDisciplines = ('soccer'); 
	if ( grep( /^$disciplineName$/, @supportedDisciplines ) )
	{
		return 1;
	}
	return 0;
}

sub isOneOrMoreDyscyplineSpecified($)
{
	#my $self = shift;
	my $pathToXmlSelector = $_[0];
	#my $xmlParser = XML::LibXML->new; 
	#my $xmlParserDoc = $xmlParser->parse_file($pathToXmlSelector); 
	
	
	if(countHowManyDisciplinesToDownloadIsDefinedInXmlSelector($pathToXmlSelector) > 0)
	{
		return 1;
	}
	return 0;	
		
};

sub countHowManyDisciplinesToDownloadIsDefinedInXmlSelector()
{
	#my $self = shift;
	my $pathToXmlSelector = $_[0];
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($pathToXmlSelector); 
	my $dataChoosenToDownloadXmlNode = $xmlParserDoc->findnodes("/note/dataChoosenToDownload")->[0];
	
	
	if (not defined($dataChoosenToDownloadXmlNode))
	{
		return 0 ;
		#'Iam not sure if it is correct formula';
	}

	my $dataSource = 0;
	foreach($dataChoosenToDownloadXmlNode->nonBlankChildNodes())
	{
		
		my $dataSourceNameXmlNode = $_;
		my $disciplineName = $dataSourceNameXmlNode->nodeName;
		
		if(isCorrectDisciplineName($disciplineName))
		{
			$dataSource++;			
		}
		else
		{
			return 0; #instead of returning 0 should be parser validating all disciplnes and requirement that all bookmaker name must be 'legal'
		}
	}
	return $dataSource++;
}

1;