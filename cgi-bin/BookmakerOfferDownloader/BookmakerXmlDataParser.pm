package BookmakerXmlDataParser;
use BookmakersRegexps;
use strict;
use warnings;
use base 'Exporter';
our @EXPORT = qw(isCorrectSurebetsFile isCorectDownloadedBookmakerOfferFile isCorectBookmakerDataSelectorFile 
				 isCorrectEventListFile isEventListFileHasCorrectSyntax isCorrectProfitabilityFile);

use LWP::Simple;
use XML::LibXML;
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
sub isCorrectProfitabilityFile($);
#################DEFINITION####################################
sub new()
{
	my $class = shift;
	my $self = bless {}, $class;
	return $self;
};

sub isCorrectProfitabilityFile($)
{
	
	my ($self, $xmlSelectorPath) = @_;
	
	(-e $xmlSelectorPath) or die "Incorrect path to offer profitability file\n";
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($xmlSelectorPath) or return 0; 

	my $xmlToParse = $xmlParserDoc->toString();

	my $isFileHasCorrectSyntax = ($xmlToParse =~ m{
													^<\?xml.version="1.0".encoding="(UTF|utf)-8"\?>.*
													<note>.*
													<dataSources>.*
													<betexplorer />.*
													</dataSources>.*
													<eventList>.*
													<($disciplineName_re)>.*
													<Events>.*
													<event.url="https://www.betexplorer.com/($disciplineName_re).*".?>.*
													<bestCombinations>.*													
													<profit>-?\d{1,2}\.\d{1,2}</profit>.*
													</bestCombinations>.*
													(</event>).*
													</Events>.*
													</($disciplineName_re)>.*
													</eventList>.*
													</note>
													}sx);
		
	return $isFileHasCorrectSyntax;
};


sub isCorrectSurebetsFile($)
{
	my $self = shift;
	my $xmlSelectorPath = $_[0];
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($xmlSelectorPath) or return 0; 

	my $xmlToParse = $xmlParserDoc->toString();

	my $isFileHasCorrectSyntax = ($xmlToParse =~ m{
													^<\?xml.version="1.0".encoding="(?:UTF|utf)-8"\?>.*
													<note>.*
													<surebetList>.*
													<surebet.url="https://www.betexplorer.com/(?:$disciplineName_re).*".?>.*
													<type>.*</type>.*
													<profit>\d{1,2}\.\d{1,2}</profit>.*
													<bets>.*
													<type>.*</type>.*
													<bookmakerName>.*</bookmakerName>.*
													<price>\d{1,2}\.\d{1,2}</price>.*
													</bets>.*
													</surebet>.*
													</surebetList>.*
													</note>
													}sx);
	return $isFileHasCorrectSyntax;
}


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
													^<\?xml.version="1.0".encoding="(UTF|utf)-8"\?>.*
													<note>.*
													<dataSources>.*
													<betexplorer />.*
													</dataSources>.*
													<eventList>.*
													<($disciplineName_re)>.*
													<Events>.*
													<event.url="https://www.betexplorer.com/($disciplineName_re).*".?>.*
													(</event>).*
													</Events>.*
													</($disciplineName_re)>.*
													</eventList>.*
													</note>
													}sx);
		
	return $isFileHasCorrectSyntax;
};

sub isCorrectEventListFile($)
{
	my $self = shift;
	my $xmlSelectorPath = $_[0];
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($xmlSelectorPath); 
	
	if(not $xmlParserDoc)
	{
		print "BookmakerXmlDataParser::ERROR: file ${xmlSelectorPath} isn't a correct XML file\n";
		return 0;	
	} 
	
	my $downloadedOfferXmlNode = $xmlParserDoc->findnodes("/note/eventList")->[0];
	if(not $downloadedOfferXmlNode)
	{
		print "BookmakerXmlDataParser::ERROR Unable to find node /note/eventList in ${xmlSelectorPath} \n";
		return 0;
	}
	
	my $disciplineXmlNode = $downloadedOfferXmlNode->nonBlankChildNodes->[0];
	my $disciplineName = $disciplineXmlNode->nodeName;

	if(isCorrectDisciplineName($disciplineName))
	{
		my $countryCategoryXmlNode = $disciplineXmlNode->nonBlankChildNodes->[0];
		my $countryCategoryName = $countryCategoryXmlNode->nodeName; 
		isLegalNameOfCountryCategory($countryCategoryName) or return 0;
		my $eventXmlNode = extractFirstEventXmlNodeFromCountryCategoryXmlNode($countryCategoryXmlNode) or return 0;
		if(isCorrectLinkToEventXmlNode($eventXmlNode))
		{
			return 1;
		}
		else
		{
			return 0;	
		} 

	}
	else
	{
		print "BookmakerXmlDataParser::ERROR discipline ${disciplineName} isn't correct discipline name\n";
		return 0;
	}
	
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
	
	my $eventNode = $_[0];
	$eventNode =~ m|event url="(.*)"|;
	my $urlToEvent = $1;
	my $curlQuery = qq(curl -A "Mozilla/5.0" ${urlToEvent} >/dev/null);
	`$curlQuery`;
		
	if($? == 0)
	{
		return 1;
	}
	
	
	$urlToEvent =~ /(.*www.betexplorer.com)(.*)/;
	 
	
	my $pathToMockDataOfEvent = "input/mockedWWW/" . $2 ; 
	if(-e $pathToMockDataOfEvent)
	{
		return 1;
	}
	
	print "BookmakerXmlDataParser ERROR: incorrect link to event: ${urlToEvent}\n";
	return 0;
		
}

#todo add executing all tests before commits or before push in hooks 
	
sub extractFirstEventXmlNodeFromCountryCategoryXmlNode($)
{
	my $countryCategoryXmlNode = $_[0];

	my $groupCategoryXmlNode = $countryCategoryXmlNode->nonBlankChildNodes->[0];
	#$groupCategoryXmlNodeName = $groupCategoryXmlNode->nodeName;
	
	(defined $groupCategoryXmlNode ) or return 0;
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
	my $dataXmlNode = $xmlParserDoc->findnodes("/note/data")->[0];
	
	
	if (not defined($dataXmlNode))
	{
		return 0 ;
		#'Iam not sure if it is correct formula';
	}

	my $dataSource = 0;
	foreach($dataXmlNode->nonBlankChildNodes())
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
