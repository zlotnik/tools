#!/usr/bin/perl -w
package BetExplorerDownloader;
use strict;
use warnings;
use XML::Tidy;
use XML::Simple;
use Data::Dumper;
use POSIX ":sys_wait_h";
use 5.010;
use Data::Dumper;
use XML::LibXML;
use BookmakerPageCrawler;
use File::Copy qw(copy);
use WojtekToolbox;
use CommonFunctionalities;
use Cwd;
use HTML_1X2_Events_Parser;


our @EXPORT = qw(startCreatingXmlPartWithAnEventDetail pickupLinksFromXml create_BookmakersOfferFile add_bookmakerOffers_to_xmlWithSportEvents);

###############SUB PROTOTYPES############################################
sub new();
sub loadSelectorFile($);
sub getsLinksForAllEventsFromSubCategory($$);
sub getTableWithEvents($);
sub getLinksToEventFromTable($);
sub create_BookmakersOfferFile($);
sub downloadRawDataOfChoosenOfert(\%);
sub checkNumberOfBookmaker($);
sub convertRawDownloadedDataToHash($);
sub createEventListXML($$);
sub getAllSubCategories($$);
sub updateXmlNodeWithDataFromBookmaker($$);
sub getRootNode($);
sub addChildSubcategoryNodeToOfferXml($$$);
sub addLinkToEventToOfferXml($$$);
sub updateEventListXMLWithEventDetails($);
sub add_bookmakerOffers_to_xmlWithSportEvents($);
sub correctFormatXmlDocument($);
sub xmlDocumentHasNodeWithoutLineBreaks($);
sub validateSelectorFile();
sub isLinkToEvent($);
sub startCreatingXmlPartWithAnEventDetail($);
sub pickupLinksFromXml($);
sub removeEmptyLines(\$);
sub prepareTemplateFor_SportEventsFile($);
sub isEventsNodeExists($$);
sub addEventNodeToXmlEventList($$);
sub injectBookmakerEventOfferIntoXML($$);
sub injectBookmakerProductEventOffertIntoXML($$$);
sub add_UnderOver_offers($);
sub add_1X2_offers($);
#################DICTIONARY##############################################


#################TODO####################################################
# zeby nie pobieral danych zakladu jezeli nie ma zadnego()-96 na outpucie
# dodac statystyki
# filter buchmacher z pliku
# add show usage
# add parse input file
# #updating nodes like <poland/> seems to not work
# add to validateSelectorFile checking if it is a correct selector file so it means contains all needed data in good format needed by the program  

#handling cases when event list is empty
#in this situation parser dies instead of retruning false


############################MAIN##############################################

my $pathToXmlSelector = $ARGV[0];


####################SUB DEFINITIONS############################################
sub new()
{		
	print "Functional module BookmakerOfferDownloader\n";
	my ($class, $mockedOrRealWWW_argument) = @_;
	my $self;
		
	$self = bless {
			m_BookmakerPageCrawler => BookmakerPageCrawler->new($mockedOrRealWWW_argument)
		      },$class;
	
	return $self; 
}

sub loadSelectorFile($)
{	
	my ($self, $selectorFilePath) = @_;
	$self->{mSelectorFile} = $selectorFilePath;
	$self->validateSelectorFile();
}

sub validateSelectorFile()
{
	my $self = shift;
	my $selectorFile = $self->{mSelectorFile};
	(-e ${selectorFile}) or die "selector file: ${selectorFile} doesn't exist";
	isItCorrectXmlFile(${selectorFile}) or die "selector file: ${selectorFile} isn't a correct xml file\n";  
		
}

sub isItCorrectXmlFile($)
{
	my ($pathToXmlSelector) = @_;
	my $xmlParser = XML::LibXML->new; 
	if($xmlParser->parse_file($pathToXmlSelector))
	{
		return 1
	}
	else 
	{
		return 0;
	}
}
#above could be moved to parser


sub create_BookmakersOfferFile($) 
{
	my ($self, $outputXmlPath) = @_;
	
	defined  $self->{mSelectorFile} or die "The selector file didn't loaded\n";
	my $pathToXmlSelector = $self->{mSelectorFile};

	my $xpath = ""; 
	$self->createEventListXML($xpath, $outputXmlPath);
	
	updateEventListXMLWithEventDetails($outputXmlPath);
	$self->add_bookmakerOffers_to_xmlWithSportEvents($outputXmlPath);

	# 1.  sport events selector
	# 2.  xml with sport events
	# 3.  xml with bookmaker offer
	# 4.  profitability xml


}

sub correctFormatXmlDocument($)
{

	my $pathToXmlDocumentToCorrect = shift;
	my $tidy_obj = XML::Tidy->new('filename' => $pathToXmlDocumentToCorrect);

	$tidy_obj->tidy();
	$tidy_obj->write();
}

sub updateEventListXMLWithEventDetails($)
{
	my ($pathToXmlWithEventsLinks) = @_;
	my @eventsLinks = pickupLinksFromXml($pathToXmlWithEventsLinks);
	
	my @fileNamesWithAnEventDetails;  
	
	for(@eventsLinks) 	
	{
		my $anEventLink = $_;
		my $anFileNameWithEventDetails = startCreatingXmlPartWithAnEventDetail($anEventLink);
		push @fileNamesWithAnEventDetails, $anFileNameWithEventDetails ;
		die "TODO: merging xml element with main xml";
		die "TODO: if there are more than 10 process wait";
	}
		
		
}

sub pickupLinksFromXml($)
{
	#I am not sure but I suppose that isn't most important functionality so could be implemented later

}

sub injectBookmakerProductEventOffertIntoXML($$$)
{
	my($xmlNodePointOfInjection, $bookmakerName, $price) = @_;
	my $bookMakerXMLNode = XML::LibXML::Element->new("_${bookmakerName}");
	my $bookmakerEventProductPriceXMLNode = XML::LibXML::Text->new($price);
	$bookMakerXMLNode->addChild($bookmakerEventProductPriceXMLNode);
	$xmlNodePointOfInjection->addChild($bookMakerXMLNode);
}


sub injectBookmakerEventOfferIntoXML($$)
{
	my ($dataWithBets, $nodeThatNeedUpdated) = @_;
	
	$nodeThatNeedUpdated->addChild( my $xmlNode_1 = XML::LibXML::Element->new("_1"));
	$nodeThatNeedUpdated->addChild( my $xmlNode_X = XML::LibXML::Element->new("_X"));
	$nodeThatNeedUpdated->addChild( my $xmlNode_2 = XML::LibXML::Element->new("_2"));
	
	foreach(split("\n",$dataWithBets))
	{
		my $lineWithBetData = $_;
		my ($bookmakerName, $price_1, $price_X, $price_2);
			
		if($lineWithBetData =~ m|(\w*) (\d?\d\.\d\d) (\d?\d\.\d\d) (\d?\d\.\d\d)| )
		{
			($bookmakerName, $price_1, $price_X, $price_2) = ($1, $2, $3,$4 );
			
			injectBookmakerProductEventOffertIntoXML($xmlNode_1, $bookmakerName,  $price_1);
			injectBookmakerProductEventOffertIntoXML($xmlNode_X, $bookmakerName,  $price_X);
			injectBookmakerProductEventOffertIntoXML($xmlNode_2, $bookmakerName,  $price_2);
		}	
	}
		
};


sub add_UnderOver_offers($)
{

}

sub add_1X2_offers($)
{

}

sub add_bookmakerOffers_to_xmlWithSportEvents($)
{
		
	my ($self, $pathToEventListXML) = @_;
	my $xmlParser = XML::LibXML->new; 
	my $xmlDoc = $xmlParser->parse_file($pathToEventListXML) or die $?;
	my @allEventXml = $xmlDoc->findnodes('/note/eventList//*//event'); 
	
	for(@allEventXml)
	{		
		my $eventNode = $_;

		# add_1X2_offers($eventNode);#not implemented just draft 

		# add_UnderOver_offers($eventNode);

		my $nodeThatNeedUpdated = XML::LibXML::Element->new("_1X2"); 
		$eventNode->addChild( $nodeThatNeedUpdated );
		
		$eventNode =~ m{event url="(.*\/)((&quot.*")|("))} or die;
		my $linkToEvent = $1;
		
		print "downloading $linkToEvent \n";
		my $dataWithBets = $self->{m_BookmakerPageCrawler}->getRawDataOfEvent($linkToEvent); #raw data doesn't correspont to its functionality anymore because it download data in html form
			
		my $eventParser = HTML_1X2_Events_Parser->new();		

		$dataWithBets = $eventParser->parse($dataWithBets);

		injectBookmakerEventOfferIntoXML($dataWithBets, $nodeThatNeedUpdated);
	}
		
	open XML, ">$pathToEventListXML" or die;
	print XML $xmlDoc->toString();
	close XML;
	
	correctFormatXmlDocument($pathToEventListXML);
		
}

sub removeEmptyLines(\$)
{
	my $dataWithBets = ${$_[0]};
	my $theResult;
	
	foreach(split("\n",$dataWithBets))
	{
		my $lineWithBetData = $_;
		if( $lineWithBetData =~ /^(\s*\d\.\d\d)|([a-zA-Z \d]+)$/)
		{
			$theResult .= $lineWithBetData . "\n";
		}	
	}
	
	${$_[0]} = $theResult
	
}


sub updateXmlNodeWithDataFromBookmaker($$) #todo use better name
{
	
	my ($self,$xsubPath, $pathToXmlSelector) = @_;  
	
	my $xmlParser = XML::LibXML->new; 
	my $xmlDoc = $xmlParser->parse_file($pathToXmlSelector) or die "Can't parse xmlFile";
	
	my $betsDataXmlNode = seekBetsDataInXmlEventFile($xmlDoc); #maybe this method isn't needed and its name could be not adequate
		
	for($self->getAllSubCategories($betsDataXmlNode, $xsubPath))
	{
		my $subCategoryName = $_;
		my $xpathToNewChildNode = "${xsubPath}/${subCategoryName}";
		
		if(isLinkToEvent($subCategoryName))
		{
			addLinkToEventToOfferXml($xsubPath,  $subCategoryName, $pathToXmlSelector);
		}
		else
		{
			addChildSubcategoryNodeToOfferXml($xsubPath,  $subCategoryName, $pathToXmlSelector);
		}
		$self->updateXmlNodeWithDataFromBookmaker($xpathToNewChildNode,$pathToXmlSelector);
	}
}
	
sub isLinkToEvent($)
{
	my $stringToCheck = $_[0];
	return ($stringToCheck =~ m|https://|);
	
}

sub getRootNode($) #doesn't used anymore?
{
	my $pathToXmlSelector = shift;
	
	my $xmlParser = XML::LibXML->new;
	my $doc = $xmlParser->parse_file($pathToXmlSelector) or die $?;
	my @rootXmlNode = $doc->findnodes("/");#$doc->findnodes("/")->[0];
	return $rootXmlNode[0];
}

sub seekBetsDataInXmlEventFile($)
{
	my $wholeXmlDocument = shift;		
	
	my $betsDataXmlNode = $wholeXmlDocument->findnodes("/note/eventList")->[0];#->nonBlankChildNodes()->[0];
	return $betsDataXmlNode;
}

sub addEventNodeToXmlEventList($$)
{
	my ($relativeXpathToUpdate, $outputXmlFilePath) = @_;
	
	my $absolutePathToNodeNeededUpdate =  '/note/eventList' . $relativeXpathToUpdate ;
	
	my $xmlParser = XML::LibXML->new;
	my $document = $xmlParser->parse_file($outputXmlFilePath) or die $?;
	
	my $parentNodeToUpdate = $document->findnodes($absolutePathToNodeNeededUpdate)->[0] ;
	
	$parentNodeToUpdate->addNewChild('','Events');
	
	$document->toFile($outputXmlFilePath) or die $?;
}

sub isEventsNodeExists($$)
{
	my ($relativeXpathToParent, $outputXmlFilePath) = @_;
	my $xmlParser = XML::LibXML->new;
	my $document = $xmlParser->parse_file($outputXmlFilePath) or die $?;
	my $absolutePathTo_EventsNode =  '/note/eventList' . $relativeXpathToParent. '/Events' ;
	
	my $parentNodeToUpdate = $document->findnodes($absolutePathTo_EventsNode)->[0] ;
	
	if (defined $parentNodeToUpdate)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

sub addLinkToEventToOfferXml($$$)
{
	
	my ($relativeXpathToParent, $linkToEvent, $outputXmlFilePath) = @_;
	my $absolutePathToNodeNeededUpdate =  '/note/eventList' . $relativeXpathToParent . '/Events';
	
	my $xmlParser = XML::LibXML->new;
	my $document = $xmlParser->parse_file($outputXmlFilePath) or die $?;
	
	if(not isEventsNodeExists($relativeXpathToParent,$outputXmlFilePath ))
	{
		addEventNodeToXmlEventList($relativeXpathToParent, $outputXmlFilePath);
		$document = $xmlParser->parse_file($outputXmlFilePath) or die $?;
	}
	
	
	my $parentNodeToUpdate = $document->findnodes($absolutePathToNodeNeededUpdate)->[0] or die; 	
				
	my $newNode = XML::LibXML::Element->new('event');
	$newNode->setAttribute('url',$linkToEvent);
	
	$parentNodeToUpdate->addChild($newNode);	
	$document->toFile($outputXmlFilePath) or die $?;	

};

sub addChildSubcategoryNodeToOfferXml($$$)
{
	my ($relativeXpathToParent, $nameOfNewChildNode, $outputXmlFilePath) = @_;
	my $absolutePathToNodeNeededUpdate =  '/note/eventList' . $relativeXpathToParent; 
	
	my $xmlParser = XML::LibXML->new;
	my $document = $xmlParser->parse_file($outputXmlFilePath) or die $?;
	my $parentNodeToUpdate = $document->findnodes($absolutePathToNodeNeededUpdate)->[0] or die "Can't find xml node specify by xpath:$absolutePathToNodeNeededUpdate in xml\n $document\n";
	my $newNode = XML::LibXML::Element->new($nameOfNewChildNode);
	my $lineBreakTextNode = XML::LibXML::Text->new("\n");	
	$parentNodeToUpdate->addChild($newNode);	
	$document->toFile($outputXmlFilePath) or die $?;	
}
		
	

sub prepareTemplateFor_SportEventsFile($)
{
	
	my ($self,$outputXmlPath) = @_;
	copy $self->{mSelectorFile}, $outputXmlPath or die "Can't load selector file $self->{mSelectorFile}";
	my $xmlParser = XML::LibXML->new;		
	my $xmlNode = $xmlParser->parse_file($outputXmlPath) or die;
	
	my $nodeToRename = $xmlNode->findnodes('/note/dataChoosenToDownload')->[0];
	$nodeToRename->setNodeName('eventList');
	$xmlNode->toFile($outputXmlPath) or die $?; 
		
}	
	
sub createEventListXML($$)
{
	my ($self, $xpath, $outputXmlPath) = @_;
	
	if(not $xpath) #temporary solution until recurency will be removed
	{
		$self->prepareTemplateFor_SportEventsFile($outputXmlPath);
	}
	
	my $xmlParser = XML::LibXML->new;		
	my $xmlNode = $xmlParser->parse_file($outputXmlPath) or die;	
		
	my $rootPathToEventXMLNode = '/note/eventList';
	my $absolutePathToNode = "$rootPathToEventXMLNode${xpath}";
	
	$xmlNode = $xmlNode->findnodes($absolutePathToNode)->[0];
	
	if(defined $xmlNode) 
	{
		foreach ($xmlNode->nonBlankChildNodes())
		{
			my $node = $_;						
			my $nodeName = $node->nodeName;
				
			if($node->hasChildNodes() ) #[bug]because it returns true also for <poland></poland> 
			{
				my $childNode = $_;
				$self->createEventListXML("$xpath/$nodeName", $outputXmlPath);
				#enclose in some sub like seekXmlNodeWithDataTofetch or something better ...  
			}
			else
			{
				$self->updateXmlNodeWithDataFromBookmaker("${xpath}/${nodeName}", $outputXmlPath);				
			}
		}	
	}
	


	# add_country_leagues($xmlFile);
	# add_league_events($xmlFile);
	correctFormatXmlDocument($outputXmlPath);

};


sub getAllSubCategories($$)
{
	#IN:  "soccer/Portugal"
	#Out array: ["LaLiga","LaLiga", "and so on"];
	my ($self, $xmlNode, $subCategoryXpath) = @_;
		
	my @subCategories = $self->{m_BookmakerPageCrawler}->getAllSubCategories($subCategoryXpath);
	
	return @subCategories;
}
	

sub convertRawDownloadedDataToHash($)
{
	my $downloadedDataRawText = $_[0];
	print $downloadedDataRawText;
	die;

};

sub downloadRawDataOfChoosenOfert(\%)
{
	my %category = %{$_[0]};
	my $nation = $category{'nation'};
	my $league = $category{'league'};
	my @allLinksToEventInSubCategory = getsLinksForAllEventsFromSubCategory($nation, $league);
	
	foreach(@allLinksToEventInSubCategory)
	{

		my $linkToEvent = $_;
		my $rowDataForReport = getRawDataOfEvent($linkToEvent);
		print "### $rowDataForReport  ###";
		die;
	}
};

sub createJavaScriptForDownload($)
{
	my $linkToReplace = $_[0];
	
	open( TEMPLATE  , "<" , 'download1x2Data_template.js') or die;
	
	open( JAVASCRIPT  , ">" , 'tmp/download1x2Data.js') or die;
	
	while(<TEMPLATE>)
	{
		my $line = $_;
		if ($line =~ /(.*)(__URL_TO_FILL__)(.*)/)
		{
			print JAVASCRIPT $1.$linkToReplace.$3."\n"; 
		}
		else
		{
			print JAVASCRIPT $line;
		}
	}
	close(JAVASCRIPT)or die;
	close(TEMPLATE)or die;

}

sub getsLinksForAllEventsFromSubCategory($$)
{
	my $categoryName = $_[0];
	my $subCategoryName = $_[1];
	my $link = 'http://www.betexplorer.com/soccer/' .  $categoryName .'/'. $subCategoryName;
	
	my $content  = tryToGetUrl($link,3) or die "unable to get $link \n";

	
	return getLinksToEventFromTable(getTableWithEvents($content))
	
	#print $content;
};

sub getLinksToEventFromTable($)
{
	my $tableWithEvents = $_[0];
	my @linksToEvents;
	foreach (split("\n",$tableWithEvents))
	{
		my $lineWithData = $_;
		if($lineWithData =~ /a href="(.*?)" class="in-match"/)
		{
			my $linkToEvent = "http://www.betexplorer.com$1";
			push @linksToEvents, "http://www.betexplorer.com$1";			
			
		} 
	}
	return @linksToEvents;
}

sub eventInLinkAlreadyPlayed($)
{

	my $linkToEvent = $_[0];

}

sub checkNumberOfBookmaker($)
{
	my $rowToAnalize = $_[0];
	
	if($rowToAnalize =~ /td class="bs">(\d?\d)/)
	{
		return $1;
	}

	return 0;

}

sub getTableWithEvents($)
{
	my $htmlPageWithEvents = $_[0];
	$htmlPageWithEvents =~ /(<table class=\"table\-main)([\s\S]*?)(table>)/m;
	
	(defined $1 and defined $1 and defined $1) or die "BetExplorerParser: Isn't possible to parse the table with events "; 
	return $1.$2.$3;
}

1;
