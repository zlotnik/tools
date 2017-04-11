package BookmakerXmlDataParser;
use base 'Exporter';
our @EXPORT = qw(isCorectBookmakerOfferFile isCorectBookmakerSelectorFile);
#nice to have; tool to create templates for files .pm, .pl   
#move all parsers to new directory
#think about code coverage
#incorrect inputs should be
##################DECLARATION##################################
sub new();
sub isCorectBookmakerSelectorFile($);
sub isCorectBookmakerOfferFile($);
sub xmlSelectorContainsAllNeededData($);
sub isCorrectBookmakerName($);
sub isCorrectDisciplineName($);
#################DEFINITION####################################
sub new()
{
	my $class = shift;
	my $self = bless {}, $class;
	return $self;
};

sub isCorectBookmakerSelectorFile($)
{
	my $pathToXmlSelector = $_[0];
	my $xmlParser = XML::LibXML->new; 
	my $isCorrectXmlFile = $xmlParser->parse_file($pathToXmlSelector); 
			
	if ( $isCorrectXmlFile and xmlSelectorContainsAllNeededData($pathToXmlSelector) )
	{
		return 1;
	}
	return 0;
};

sub isCorectBookmakerOfferFile($)
{
};

sub isCorrectEventListFile($)
{
	return 0;
};

sub xmlSelectorContainsAllNeededData($)
{
	my $xmlSelector = $_[0];
	return (isOneOrMoreBookmakersSpecifiedInXmlSelector($xmlSelector) and isOneOrMoreDyscyplineSpecified($xmlSelector));

};

sub isOneOrMoreBookmakersSpecifiedInXmlSelector($)
{
	my $xmlDoc = $_[0];
	
	if(countHowManyBookmakerIsChoosedInXmlSelector($xmlDoc) > 0)
	{
		return 1;
	}
	return 0;
		
};

sub countHowManyBookmakerIsChoosedInXmlSelector($)
{
	my $choosenBookmakers = $doc->findnodes("/note/dataSources")->[0];
	
	
	if (not defined($choosenBookmakers))
	{
		return 0 ;
		#'Iam not sure if it is correct formula';
	}

	my $bookmakerCounter = 0;
	foreach($choosenBookmakers->nonBlankChildNodes())
	{
		my $disciplineName = $_;
		if(isCorrectBookmakerName($disciplineName))
		{
			$bookmakerCounter++;			
		}
		else
		{
			return 0; #instead of returning 0 should be parser validating all bookmakers and requirement that all bookmaker name must be 'legal'
		}
	}
	return $bookmakerCounter++;
	
}


sub isCorrectBookmakerName($)
{
	my $bookmakerNamer = $_;
	if( 'betexplorer' eq $bookmakerNamer)
	{
		return 1;
	}
	return 0;
}

sub isCorrectDisciplineName($)
{
	my $disciplineName = $_;
	my @supportedDisciplines = ('soccer'); 
	if ( grep( /^$disciplineName$/, $supportedDisciplines ) )
	{
		return 1;
	}
	return 0;
}

sub isOneOrMoreDyscyplineSpecified($)
{
	my $xmlDoc = $_[0];	
	
	
	if(countHowManyDisciplinesToDownloadIsDefinedInXmlSelector() > 0)
	{
		return 1;
	}
	return 0;	
		
};

sub countHowManyDisciplinesToDownloadIsDefinedInXmlSelector()
{
	my $dataChoosenToDownloadXmlNode = $doc->findnodes("/note/dataChoosenToDownload")->[0];
	
	
	if (not defined($dataChoosenToDownloadXmlNode))
	{
		return 0 ;
		#'Iam not sure if it is correct formula';
	}

	my $bookmakerCounter = 0;
	foreach($dataChoosenToDownloadXmlNode->nonBlankChildNodes())
	{
		my $disciplineName = $_;
		if(isCorrectDisciplineName($disciplineName))
		{
			$bookmakerCounter++;			
		}
		else
		{
			return 0; #instead of returning 0 should be parser validating all disciplnes and requirement that all bookmaker name must be 'legal'
		}
	}
	return $bookmakerCounter++;
}


1;