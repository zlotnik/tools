#!/usr/bin/perl -w
package BetExplorerDownloader;
use strict;
use warnings;
use XML::Tidy;
use XML::Simple;
use Data::Dumper;
use XML::LibXML;
use BookmakerPageCrawler;
use CountryLevelCategoryPage;
use File::Copy qw(copy);
use WojtekToolbox;
use CommonFunctionalities;
use Cwd;
use HTML_1X2_Events_Parser;
use Xpath;
use SportEvent;
use EventNode;


our @EXPORT = qw(startCreatingXmlPartWithAnEventDetail pickupLinksFromXml 
				 create_BookmakersOfferFile add_bookmakerOffer escapeNotLegitXmlNodeName);

###############SUB PROTOTYPES############################################
sub new();
sub escapeNotLegitXmlNodeName($);
sub loadSelectorFile($);
sub getsLinksForAllEventsFromSubCategory($$);
sub getTableWithEvents($);
sub getLinksToEventFromTable($);
sub create_BookmakersOfferFile();
sub downloadRawDataOfChoosenOfert(\%);
sub checkNumberOfBookmaker($);
sub convertRawDownloadedDataToHash($);
sub createEventListXML();
sub getAllSubCategories($$);
sub updateXmlNodeWithDataFromBookmaker($$);
sub addChildSubcategoryNodeToOfferXml($$$);
sub addLinkToEventToOfferXml($$$);
sub updateEventListXMLWithEventDetails($);
sub add_bookmakerOffer();
sub correctFormatXmlDocument();
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
sub updateOutputFileWithLeagues();
sub find_countries_xpaths($);
sub downloadLeaguesNames($);
sub set_OutputFile($);
sub get_OutputFile();
sub insertLeagues_intoCountryNode($\@);
sub updateOutputFileWithSportEvents();
sub find_leagues_xpaths();
sub get_selectorFile();
sub parseFile($);
sub downloadEventsURLs($);
sub downloadSportEvents($);
sub mergeLeagueEventsIntoSelectorFile($);
sub unEscapeNotLegitXmlNodeName($);
sub add_1X2_offer($);
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
	
	if ($mockedOrRealWWW_argument eq '--realnet')
	{
	
		$self->{m_strategyOfObtainingBookmakerData} = WWWBookmakerPage->new();		
	}
	elsif($mockedOrRealWWW_argument eq '--mockednet')
	{
		$self->{m_strategyOfObtainingBookmakerData} = MockedBookmakerPage->new();
	}
	else
	{
		die;
	}

	return $self; 
}

sub loadSelectorFile($)
{	
	my ($self, $selectorFilePath) = @_;
	$self->{mSelectorFile} = $selectorFilePath;
	$self->validateSelectorFile();
}

sub get_selectorFile()
{
        my ($self) = @_;
        return $self->{mSelectorFile};
}

sub validateSelectorFile()
{
	my $self = shift;
	my $selectorFile = $self->{mSelectorFile};
	(-e ${selectorFile}) or die "selector file: ${selectorFile} doesn't exist";
	$self->isItCorrectXmlFile(${selectorFile}) or die "selector file: ${selectorFile} isn't a correct xml file\n";  
		
}

sub isItCorrectXmlFile($)
{
        my $self = shift;        

	my ($pathToXmlSelector) = @_;
	my $xmlParser = XML::LibXML->new; 
	if($self->parseFile($pathToXmlSelector))
	{
		return 1
	}
	else 
	{
		return 0;
	}
}
#above could be moved to parser

sub create_BookmakersOfferFile() 
{
        my $self = shift;

        #this things might be encapsulated
	my $pathToXmlSelector = $self->get_selectorFile();
	defined  $pathToXmlSelector or die "The selector file didn't loaded\n";

        my $outputXmlPath = $self->get_OutputFile();# rename get_OutputFileName ?
           
	$self->{outputXmlDocument} = $self->parseFile( $pathToXmlSelector ); 

	$self->createEventListXML();
	
	updateEventListXMLWithEventDetails($outputXmlPath);#NOT IMPLEMENTED YET, however Iam not sure if I shouldn't move it down into add_bookmakerOffer
	$self->add_bookmakerOffer();

}

sub set_OutputFile($)
{
	my $self = shift;
	my ( $outputFilePath ) = @_;
	$self->{outputFilePath} = $outputFilePath;
}

sub get_OutputFile()
{
	my $self = shift;
	return $self->{outputFilePath}; 
}

sub correctFormatXmlDocument()
{

	my $self = shift;

        my $pathToXmlDocumentToCorrect = $self->get_OutputFile();
	my $tidy_obj = XML::Tidy->new('filename' => $pathToXmlDocumentToCorrect);

	$tidy_obj->tidy();
	$tidy_obj->write();
}

sub updateEventListXMLWithEventDetails($)
{
	my ($pathToXmlWithEventsLinks) = @_;
	my @eventsLinks = pickupLinksFromXml($pathToXmlWithEventsLinks); #NIY not implemented yet
	
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

sub unEscapeNotLegitXmlNodeName($)
{
        my $nodeName = $_[0];
        $nodeName =~ s/__//g; 
        return $nodeName;

};

sub escapeNotLegitXmlNodeName($)
{
        my $nodeName = $_[0];


        if( $nodeName =~ /^(\d\S*)/ )
        {
                return "__".$1; 
        }
        else
        {
                return $nodeName;
        }
        

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

sub parseFile($)
{
        my $self = shift;
        my ( $pathToXml ) = @_;
 
	my $xmlParser = XML::LibXML->new; 
	my $xmlDoc = $xmlParser->parse_file( $pathToXml ) or die $?;
        return $xmlDoc;
}

sub add_bookmakerOffer()
{
		
	my ( $self ) = @_;
        
        my $pathToEventListXML = $self->get_OutputFile();

	my $xmlDoc = $self->{outputXmlDocument}; 

	my @allEventXml = $xmlDoc->findnodes('/note/data/*/*/*/events/event'); 
	
	for(@allEventXml)
	{		
		my $eventNode = $_;
	
		$eventNode =~ m{event url="(.*\/)((&quot.*")|("))} or die;
		my $linkToEvent = $1;
		
		print "downloading $linkToEvent \n";
		my $dataWithBets = $self->{m_BookmakerPageCrawler}->getRawDataOfEvent($linkToEvent); #raw data doesn't correspont to its functionality anymore because it download data in html form
			
		my $eventParser = HTML_1X2_Events_Parser->new();		

		$dataWithBets = $eventParser->parse($dataWithBets);

        	my $newOfferNode = XML::LibXML::Element->new("_1X2"); 
		$eventNode->addChild( $newOfferNode );
		injectBookmakerEventOfferIntoXML($dataWithBets, $newOfferNode);
	}

        for( @allEventXml )
        {
                next;
		my $xmlEventNode = $_;

               $self->add_1X2_offer( $xmlEventNode );#might be encapsuleted more; can be delegated to some new class like EventNode
               #$self->add_UnderOver_offer( $eventNode );

               #my $eventNode  = EventNode->new( $eventNode );

               #my $bookmakerOfferData = $eventNode->download_1X2_offers(); #raw form of offer
               #
               

               #newEventNode = $self->addOfferNode('1X2');
    	       #injectBookmaker_1X2_EventOfferIntoXML($bookmakerOffer, $newOfferNode);

        }
		
	open XML, ">$pathToEventListXML" or die;
	print XML $xmlDoc->toString();
	close XML;
	
	$self->correctFormatXmlDocument();
		
}


sub add_1X2_offer($)
{
        my $self = shift;
        
        my ( $xmlEventNode ) = @_;          

        my $eventNode  = EventNode->new( $xmlEventNode );

        my $bookmakerOfferHtml = $eventNode->download_1X2_offers(); #raw form of offer
        #

	my $eventParser = HTML_1X2_Events_Parser->new();		
	my $dataWithBetsRawText = $eventParser->parse( $bookmakerOfferHtml );

        #newEventNode = $self->addOfferNode('1X2');
        #or
        #newEventNode = $self->addOfferNodes('1X2');
        #
        #
        #injectBookmaker_1X2_EventOfferIntoXML($bookmakerOffer, $newOfferNode);

        ...
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
	
sub isLinkToEvent($)
{
	my $stringToCheck = $_[0];
	return ($stringToCheck =~ m|https://|);
}

sub createEventListXML()
{
	my ( $self ) = shift;

	$self->updateOutputFileWithLeagues();
	$self->updateOutputFileWithSportEvents();
	$self->correctFormatXmlDocument(); 
};

sub find_leagues_xpaths()
{
	my $self = shift;

	my $xmlDoc = $self->{outputXmlDocument};

	my $countriesXpath = '/note/data/*/*/*';
	my @allLeagues = $xmlDoc->findnodes( $countriesXpath );
	my @toReturn;

	foreach(@allLeagues)
	{
		my $aLeagueNode = $_;
		my $aLeagueXPath = $aLeagueNode->nodePath();
                
		push @toReturn, $aLeagueXPath;
	}
	return @toReturn;

}

sub downloadEventsURLs($)
{
	
	my ($self, $leagueXpath ) = @_;
	
	my $linkToLeague = 'https://www.betexplorer.com/' . $leagueXpath . "/";	
	
	my $contentOfLeaguePage  = $self->{m_strategyOfObtainingBookmakerData}->get($linkToLeague);
	my @toReturn;
 
        my $htmlTableWithEvents = BetexplorerParser::pickupHtmlEventsTableFromLeagueHtml( $contentOfLeaguePage );
        @toReturn = BetexplorerParser::pickupLinksToEventFromTable($htmlTableWithEvents);	

	return @toReturn;
	
}

sub updateOutputFileWithSportEvents()
{
	my $self = shift;
        my $selectorFileWithLeagues  = $self->get_OutputFile();

	my @leagues_xpaths = $self->find_leagues_xpaths();
        
	foreach( @leagues_xpaths )
	{
		my $league_xpath = $_;
                my $league_URL_path = $_;
                $league_URL_path =~ s|/note/data||g;
		my @event_URLs = $self->downloadEventsURLs( $league_URL_path );

                my @sportEvents = $self->downloadSportEvents( $league_xpath );

                #there is no tests for mergeLeagueEventsIntoSelectorFile
                $self->mergeLeagueEventsIntoSelectorFile( \@sportEvents );#TODO in the future merging will be done on xml object not file
	}

        $self->{outputXmlDocument} = $self->parseFile( $self->get_OutputFile() ); 
}

sub mergeLeagueEventsIntoSelectorFile($)
{

	my $self = shift;

        my $selectorFileWithLeagues  = $self->get_OutputFile();
        
	my ( $sportEvents_ref ) = @_;
	my @sportEvents = @{$sportEvents_ref}; 

        foreach( @sportEvents )
        {
                my $sportEvent = $_;
                $sportEvent->insertIntoSelectorFile( $selectorFileWithLeagues );
        }

}

sub downloadSportEvents($)
{

        my $self = shift;
	my ( $leagueXpath ) = @_;

        my @toReturn;

        $leagueXpath = unEscapeNotLegitXmlNodeName( $leagueXpath );
        my $league_URL_path = $leagueXpath;
        $league_URL_path =~ s|/note/data||g;
	
	my $linkToLeague = 'https://www.betexplorer.com/' . $league_URL_path . "/";	
	
	my $contentOfLeaguePage  = $self->{m_strategyOfObtainingBookmakerData}->get($linkToLeague);

        my $htmlTableWithEvents = BetexplorerParser::pickupHtmlEventsTableFromLeagueHtml( $contentOfLeaguePage );
        
        my $eventTableParser = HTML_EventsTableParser->new( $htmlTableWithEvents );
        while(my $htmlEventRow = $eventTableParser->giveMeNextEventRow() )
        {
                my $sportEvent = SportEvent->new( $htmlEventRow );
                $sportEvent->fillEventData();
                push @toReturn, $sportEvent ; 
        }

	return @toReturn;

}

sub updateOutputFileWithLeagues()
{
	my $self = shift;
        my $selectorFileWithCountries  = $self->get_OutputFile();

	my @countries_xpaths = $self->find_countries_xpaths( $selectorFileWithCountries ); #here problem $selectorFileWithCountries doesn't exists should be used mSelectorFile instead
	
	foreach( @countries_xpaths )
	{
		my $country_xpath = $_;
		my @leagues_names = $self->downloadLeaguesNames( $country_xpath ); #to mock with league name
		$self->insertLeagues_intoCountryNode( $country_xpath , \@leagues_names );
	}
}

sub insertLeagues_intoCountryNode($\@)
{
	my $self = shift;
	my ( $country_xpath, $leagues_names_ref )  = @_;
	my @leagues_list = @{$leagues_names_ref}; 
        my $outputFileName  = $self->get_OutputFile();
	my $document = $self->{outputXmlDocument};

	my $countryNode = $document->findnodes( $country_xpath )->[0] or die "Can't find xml node specify by xpath:$country_xpath in xml\n $document\n";
        
        foreach( @leagues_list )
        {
                my $leagueName = $_;
                $leagueName = escapeNotLegitXmlNodeName($leagueName); #here a problem
	        my $newChildNode = XML::LibXML::Element->new( $leagueName );
	        $countryNode->addChild( $newChildNode );	
        }

	$document->toFile( $outputFileName ) or die $?;	
        $self->correctFormatXmlDocument();

}

sub downloadLeaguesNames($)
{
	my $self = shift;
	my ( $xpathToCountry ) = @_;
	my @toReturn;

        if( $xpathToCountry =~ /Germany/)
        {
                @toReturn = ( 'bundesliga' )
        }
        elsif( $xpathToCountry =~ /England/ )
        {
                @toReturn = ('premier-league')
        }

#	my $path2country_onWebsite = Xpath::trimBeginning( '/note/data', $xpathToCountry );
#	my $countryLevelCategoryPage = CountryLevelCategoryPage->new( $self->{m_strategyOfObtainingBookmakerData} );	 

#	@toReturn = $countryLevelCategoryPage->downloadSoccerLeagueNames( $path2country_onWebsite ); #here name of arg isn adequate

	return @toReturn;
}

sub find_countries_xpaths($)
{
	my $self = shift;
	my ($templateFile) = @_; 
	my $xmlDoc = $self->{outputXmlDocument}; 
	my $countriesXpath = '/note/data/*/*';
	my @allLeagues = $xmlDoc->findnodes( $countriesXpath );
	my @toReturn;

	foreach(@allLeagues)
	{
		my $aLeagueNode = $_;
		my $aLeagueXPath = $aLeagueNode->nodePath();
		push @toReturn, $aLeagueXPath;
	}
	return @toReturn;

}

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
