package BookmakerXmlDataParser;
use strict;
use warnings;
use base 'Exporter';
our @EXPORT = qw(isCorectDownloadedBookmakerOfferFile isCorectBookmakerDataSelectorFile isCorrectEventListFile isEventListFileHasCorrectSyntax);

use LWP::Simple;
#nice to have; tool to create templates for files .pm, .pl   
#move all parsers to new directory
#think about code coverage
#incorrect inputs should be
##################DECLARATION##################################
sub new();
sub isCorectBookmakerDataSelectorFile($);
sub isCorectDownloadedBookmakerOfferFile($);
sub xmlSelectorContainsAllNeededData($);
sub isCorrectBookmakerDataSourceName($);
sub isCorrectDisciplineName($);
sub isLegalNameOfCountryCategory($);
sub isCorrectEventXmlNode($);
sub xmlNodeContainsAllNeededData($);
sub extractFirstEventXmlNodeFromCountryCategoryXmlNode($);
sub isCorrectEventListFile($);
sub isCorrectLinkToEventXmlNode($);
sub isCorrectRawDataFile($);
sub isEventListFileHasCorrectSyntax($);
#################DEFINITION####################################
sub new()
{
	my $class = shift;
	my $self = bless {}, $class;
	return $self;
};

sub isCorrectRawDataFile($)
{
	my ($self,$rawDataPath ) = @_;
	my $rawDataFileContent ;
	
	{
		local $/ = undef;
		open (my $rawDataFilehandler, "<", $rawDataPath) or die "$! $rawDataPath" ; 
		$rawDataFileContent = <$rawDataFilehandler>;
		close $rawDataFilehandler or die;
	}
	
	if($rawDataFileContent =~ m|Show:[\s\S]*My Bookmakers \(settings\)[\s\S]*Bookmakers: \d[\s\S]*?\d\.\d\d|m)
	{
		return 1;
	}
	else
	{
		return 0;
	};
	

}

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

sub isCorectDownloadedBookmakerOfferFile($)
{
	my $self = shift;
	my $xmlSelectorPath = $_[0];
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($xmlSelectorPath) or return 0; 

	my $xmlToParse = $xmlParserDoc->toString();

	my $isFileHasCorrectSyntax = ($xmlToParse =~ m{
													^(<\?xml.version).*
													(<note>.*
													<dataSources>.*
													<betexplorer />.*
													</dataSources>.*
													<eventList>.*
													</eventList>.*
													</note>)
													}sx);
	print $1;
	
	return $isFileHasCorrectSyntax;
	
	
	my $downloadedOfferXmlNode = $xmlParserDoc->findnodes("downloadedOffer")->[0] or return 0;
	my $disciplineXmlNode = $downloadedOfferXmlNode->nonBlankChildNodes->[0];
	
	if(isCorrectDisciplineName($disciplineXmlNode->nodeName))
	{
		my $countryCategoryXmlNode = $disciplineXmlNode->nonBlankChildNodes->[0];
		my $countryCategoryName = $countryCategoryXmlNode->nodeName; 
		isLegalNameOfCountryCategory($countryCategoryName) or return 0;
		my $eventXmlNode = extractFirstEventXmlNodeFromCountryCategoryXmlNode($countryCategoryXmlNode) or return 0;
		if(isCorrectEventXmlNode($eventXmlNode))
		{
			return 1;
		}
	}
	
	return 0;
};

sub isCorrectEventListFile($)
{
	my $self = shift;
	my $xmlSelectorPath = $_[0];
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($xmlSelectorPath) or return 0; 
	my $downloadedOfferXmlNode = $xmlParserDoc->findnodes("/note/eventList")->[0] or return 0;
	my $disciplineXmlNode = $downloadedOfferXmlNode->nonBlankChildNodes->[0];
	
	if(isCorrectDisciplineName($disciplineXmlNode->nodeName))
	{
		my $countryCategoryXmlNode = $disciplineXmlNode->nonBlankChildNodes->[0];
		my $countryCategoryName = $countryCategoryXmlNode->nodeName; 
		isLegalNameOfCountryCategory($countryCategoryName) or return 0;
		my $eventXmlNode = extractFirstEventXmlNodeFromCountryCategoryXmlNode($countryCategoryXmlNode) or return 0;
		if(isCorrectLinkToEventXmlNode($eventXmlNode))
		{
			return 1;
		}
	}
	
	return 0;
};

sub isEventListFileHasCorrectSyntax($)
{
	my $self = shift;
	my $xmlSelectorPath = $_[0];
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($xmlSelectorPath) or return 0; 
	my $downloadedOfferXmlNode = $xmlParserDoc->findnodes("/note/eventList")->[0] or return 0;
	my $disciplineXmlNode = $downloadedOfferXmlNode->nonBlankChildNodes->[0];
	
	if(isCorrectDisciplineName($disciplineXmlNode->nodeName))
	{
		my $countryCategoryXmlNode = $disciplineXmlNode->nonBlankChildNodes->[0];
		my $countryCategoryName = $countryCategoryXmlNode->nodeName; 
		isLegalNameOfCountryCategory($countryCategoryName) or return 0;
		my $eventXmlNode = extractFirstEventXmlNodeFromCountryCategoryXmlNode($countryCategoryXmlNode) or return 0;
		return 1;		
	}
	
	return 0;

}

sub isCorrectLinkToEventXmlNode($)
{
	# c BookmakerXmlDataParser::isCorrectLinkToEventXmlNode
	my $eventNode = $_[0];
	$eventNode =~ m|event url="(.*)"|;
	my $urlToEvent = $1; 
	my $htmlContent = get($urlToEvent);
	if(defined $htmlContent)
	{
		return 1;
	}
	
	#http://www.betexplorer.com/soccer/argentina/superliga/lanus-union-de-santa-fe/fcQZl3E2/
	$urlToEvent =~ /(.*www.betexplorer.com)(.*)/;
	 
	#input/mockedWWW/soccer//soccer/Poland/ekstraklasa/korona-kielce-plock/6L7f5jc4/
	my $pathToMockDataOfEvent = "input/mockedWWW/" . $2 ; 
	if(-e $pathToMockDataOfEvent)
	{
		return 1;
	}
	
	return 0;
		
}
	
sub extractFirstEventXmlNodeFromCountryCategoryXmlNode($)
{
	my $countryCategoryXmlNode = $_[0];

	my $groupCategoryXmlNode = $countryCategoryXmlNode->nonBlankChildNodes->[0];
	#$groupCategoryXmlNodeName = $groupCategoryXmlNode->nodeName;
	my $eventsList = $groupCategoryXmlNode->nonBlankChildNodes->[0];
	
	if($eventsList->nodeName eq "Events")
	{
		my $eventXmlNode = $eventsList->nonBlankChildNodes->[0];
		if($eventXmlNode->nodeName eq "event")
		{
			return $eventXmlNode; 
		}
	}
}

sub isCorrectEventXmlNode($)
{
	my $eventXmlNode = $_[0];
	my $eventXmlNodeName = $eventXmlNode->nodeName;
	$eventXmlNodeName eq 'event' or return 0;
	
	if(xmlNodeContainsAllNeededData($eventXmlNodeName))
	{
		return 1;
	}
	return 0;
}

sub xmlNodeContainsAllNeededData($)
{
	return 1; #missing implementation
}

sub isLegalNameOfCountryCategory($)
{
	return 1;	#missing implementation
}

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