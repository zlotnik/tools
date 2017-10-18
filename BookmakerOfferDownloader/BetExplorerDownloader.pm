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
use Cwd;
use feature 'say';

our @EXPORT = qw(startCreatingXmlPartWithAnEventDetail pickupLinksFromXml pullBookmakersOffer);

#($#ARGV +1) == 1 or die 'usage surebet.pl inputFile';

#my $inputFileName = $ARGV[0];

#would be nice to have something to check some code clean metrics eg. code width, code length, number of sub in class 
#change capitalization of this file
#nice to have time login with every git pull ,git push command for cost measuring purposes
#change capitalization of this file



#open(INPUT, "<", $inputFileName) or die "Unable to open file"; 
###############SUB PROTOTYPES############################################
sub new();
sub loadSelectorFile($);
sub getsLinksForAllEventsFromSubCategory($$);
sub getTableWithEvents($);
sub getLinksToEventFromTable($);
sub pullBookmakersOffer($);
sub downloadRawDataOfChoosenOfert(\%);
sub generateReportLine($);
sub getRawDataOfEvent($);
sub findBestOdds($);
sub calculateProfit(\%);
sub checkNumberOfBookmaker($);
sub convertRawDownloadedDataToHash($);
sub createEventListXML($$);
sub getAllSubCategories($$);
sub updateXmlNodeWithDataFromBookmaker($$);
sub getRootNode($);
sub addChildSubcategoryNodeToOfferXml($$$);
sub addLinkToEventToOfferXml($$$);
sub updateEventListXMLWithEventDetails($);
sub updateEventListXMLWithBookmakerOffer($);
sub correctFormatXmlDocument($);
sub xmlDocumentHasNodeWithoutLineBreaks($);
sub validateSelectorFile();
sub isLinkToEvent($);
sub startCreatingXmlPartWithAnEventDetail($);
sub pickupLinksFromXml($);
sub removeEmptyLines(\$);
sub showUsage();
sub simplifyFormatOfRawdata(\$);
sub leaveOnlyBetsStakesDataInRawdataFile(\$);
sub addBookmakerOfferToEventListXml(\%$$);
sub prepareTemplateForXmlFileWithResults($);
sub isEventsNodeExists($$);
sub addEventNodeToXmlEventList($$);
#################DICTIONARY##############################################
#choosen bookmaker offer - choosen part of bookmakers offer by appling an offert selector eg. all German, soccer, matches  
#offer selector - a xml file used choose which data will be downloadedDataRawText
#offer xml - an output xml generated basis on the offer selector


#################TODO####################################################
# zeby nie pobieral danych zakladu jezeli nie ma zadnego()-96 na outpucie
# dodac statystyki
# filter buchmacher z pliku
# add show usage
# add parse input file
# 'clasify' this script
# #updating nodes like <poland/> seems to not work
# add to validateSelectorFile checking if it is a correct selector file so it means contains all needed data in good format needed by the program  

#getsLinksForAllEventsFromSubCategory('germany','bundesliga');


#open OUTPUT, '>', "output.txt" or die "Can't create filehandle: $!";
#select OUTPUT; 
#$| = 1;  # make unbuffered


############################MAIN##############################################

my $pathToXmlSelector = $ARGV[0];
$pathToXmlSelector = "input/parameters/polandEkstraklasaSelector.xml";                                       
#pullBookmakersOffer($pathToXmlSelector);



####################SUB DEFINITIONS############################################
sub new()
{		
	my ($class, $mockedOrRealWWW_argument) = @_;
	my $self;
		
	$self = bless {
			m_BookmakerPageCrawler => BookmakerPageCrawler->new($mockedOrRealWWW_argument)
		      },$class;
	
	return $self; 
}


sub showUsage()
{
	#implement it
}



sub loadSelectorFile($)
{
	my $self = shift;
	my ($selectorFilePath) = @_;
	$self->{mSelectorFile} = $selectorFilePath;
	$self->validateSelectorFile();
	
}

sub validateSelectorFile()
{
	my $self = shift;
	(-e $self->{mSelectorFile}) or die $?;
	isItCorrectXmlFile($self->{mSelectorFile}) or die "the selector file isn't a correct xml file\n";  
	
	
}

#above could be moved to parser
sub isItCorrectXmlFile($)
{
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



sub pullBookmakersOffer($) 
{
	my ($self, $outputXmlPath) = @_;
	
	defined  $self->{mSelectorFile} or die "The selector file didn't loaded\n";
	my $pathToXmlSelector = $self->{mSelectorFile};
	
	my $xmlParser = XML::LibXML->new;
	unlink $outputXmlPath or die; #does it needed?
	
	#below  name isn't adequate and Iam not sure if the fike isn't doubled somewhere
	copy $pathToXmlSelector, $outputXmlPath or die "Can't copy file $pathToXmlSelector => $outputXmlPath current directory: ". getcwd() . "ERR: $!" ; 
	my $doc = $xmlParser->parse_file($pathToXmlSelector);
	my $xpath = "";
	my @rootXmlNode = $doc->findnodes("/");	
	#my $rootXmlNode = $doc->findnodes("/")[0] or ->[0]; maybe this is better	
	
	$self->prepareTemplateForXmlFileWithResults($outputXmlPath);
	$self->createEventListXML($xpath, $outputXmlPath);
	
	updateEventListXMLWithEventDetails($outputXmlPath);
	$self->updateEventListXMLWithBookmakerOffer($outputXmlPath);
	
}

sub correctFormatXmlDocument($)
{

   my $pathToXmlDocumentToCorrect = shift;
   my $tidy_obj = XML::Tidy->new('filename' => $pathToXmlDocumentToCorrect);

  # Tidy up the indenting
     $tidy_obj->tidy();

  # Write out changes back to MainFile.xml
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
	#??

}


sub updateEventListXMLWithBookmakerOffer($)
{
	#c BetExplorerDownloader::updateEventListXMLWithBookmakerOffer
	
	my ($self, $pathToEventListXML) = @_;
	my $xmlParser = XML::LibXML->new; #parser in properties will improve optimalization
	my $xmlDoc = $xmlParser->parse_file($pathToEventListXML) or die $?;
	my @allEventXml = $xmlDoc->findnodes('/note/eventList//*//event'); 
	my %eventXmlBetsData ;
	my $target_xpath; #todo
	for(@allEventXml)
	{
		my $eventNode = $_;
		
		$eventNode =~ m{event url="(.*\/)((&quot.*")|("))} or die;
		my $linkToEvent = $1;
		
		my $dataWithBets = $self->{m_BookmakerPageCrawler}->getRawDataOfEvent($linkToEvent);		
		simplifyFormatOfRawdata($dataWithBets);
		
		
		my $isLineWithNumberOfBookmakersOccured = 0;
		foreach(split("\n",$dataWithBets))
		{
			my $lineWithBetData = $_;
			my ($bookmakerName, $price_1, $price_X, $price_2);
			#$lineWithBetData =~ s/[^\w\.]/#/g;
			print $lineWithBetData ." NEXT LINE\n"; 
			if($lineWithBetData =~ m|(\w*) (\d?\d\.\d\d) (\d?\d\.\d\d) (\d?\d\.\d\d)| )
			{
				($bookmakerName, $price_1, $price_X, $price_2) = ($1, $2, $3,$4 );
				$eventXmlBetsData{$bookmakerName}{'stake_1'} = $price_1;
				$eventXmlBetsData{$bookmakerName}{'stake_X'} = $price_X;
				$eventXmlBetsData{$bookmakerName}{'stake_2'} = $price_2;				
			}	
		}
		
		my $xpathToFindEventNodeExpression = qq(//*[\@url='$linkToEvent']);
		print "xxxx".$xpathToFindEventNodeExpression; 
		die "finished here ";
		#$xmlDoc->findnodes(qq|| );
		#//*[@url= 'http://www.betexplorer.com/soccer/Poland/ekstraklasa/korona-kielce-plock/6L7f5jc4/']
		addBookmakerOfferToEventListXml(%eventXmlBetsData,$pathToEventListXML, $target_xpath);	
		
	}
	#print Dumper %eventXmlBetsData;die;
	#die "above todo";	
}


sub addBookmakerOfferToEventListXml(\%$$)
{
	my ($bookmakersBetDataRef, $eventListXmlFilePath)  = @_; 
		
	#print BOOKMAKEROFFERDATA_FILEHANDLER XMLout($_[0], RootName => "books" );
	my $eventList_hashref =  XMLin($eventListXmlFilePath) or die;
	#BetExplorerDownloader::addBookmakerOfferToEventListXml

	#${$eventList_hashref}{'Events'} =  %{$bookmakersBetDataRef};

	#my %hash = ('abc' => 123, 'def' => [4,5,6]);
	#print Dumper(\%hash);
	
	print Dumper($eventList_hashref);
	die;
	#push ${$eventList_hashref}{'Events'}, %{$bookmakersBetDataRef};
	
	#below check 
	open BOOKMAKEROFFERDATA_FILEHANDLER , ">", "tmp/bookmakerOffert.xml" or die $! ;
	print BOOKMAKEROFFERDATA_FILEHANDLER XMLout($eventList_hashref );
		
	close BOOKMAKEROFFERDATA_FILEHANDLER or die;
	
};	



sub removeEmptyLines(\$)#move to toolbox
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
	#$dataWithBets = $theResult;
	${$_[0]} = $theResult
	
}


sub updateXmlNodeWithDataFromBookmaker($$)
{
	
	my ($self,$xsubPath, $pathToXmlSelector) = @_;  
	
	my $xmlParser = XML::LibXML->new; #global parser would improve optimalization
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
	return ($stringToCheck =~ m|http://|);
	
	#print "stringToParse $stringToParse\n";
	#die "unimplemented yet";

}

sub getRootNode($) #doesn't used anymore?
{
	my $pathToXmlSelector = shift;
	
	my $xmlParser = XML::LibXML->new;
	my $doc = $xmlParser->parse_file($pathToXmlSelector) or die $?;
	my @rootXmlNode = $doc->findnodes("/");#$doc->findnodes("/")->[0];
	return $rootXmlNode[0];
}
#coverity test
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



sub addLinkToEventToOfferXml($$$)# this sub must refactorized because it can be reached using less amount of code lines 
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
		
	

sub prepareTemplateForXmlFileWithResults($)
{
	#c BetExplorerDownloader::prepareTemplateForXmlFileWithResults
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

	#copy $self->{mSelectorFile}, $outputXmlPath or die "Can't load selector file $self->{mSelectorFile}";
	
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
				
			if($node->hasChildNodes() )
			{
				my $childNode = $_;
				$self->createEventListXML("$xpath/$nodeName", $outputXmlPath);
				#enclose in some sub like seekXmlNodeWithDataTofetch or something better ...  
			}
			else
			{
				#create a 'verbosity' switch
				#print "END OF RECURENCE $xpath/$nodeName\n"; #move to some trace function
				#updateXmlNodeWithDataFromBookmaker($node, "${xpath}/${nodeName}", $outputXmlPath);
				$self->updateXmlNodeWithDataFromBookmaker("${xpath}/${nodeName}", $outputXmlPath);				
			}
		}	
	}
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
	

sub generateReportLine($)
{	
	my $linkToEvent = $_[0];
	my $resultLine = '';
	my $rowDataForReport = getRawDataOfEvent($linkToEvent);
	
	if($rowDataForReport)
	{
		my %bestOdds  = findBestOdds($rowDataForReport);	
		my $profit = calculateProfit(%bestOdds);
			
		$resultLine = $linkToEvent . ' ' . $bestOdds{'1'} .' ' . $bestOdds{'X'} .' ' . $bestOdds{'2'}  .' ' . $profit."\n"; 	
		print STDOUT $resultLine; 	
		if($profit > 0)
		{
			return $resultLine;
		}
		else
		{
			return '';
		}
	}
	return '';
}

sub calculateProfit(\%)
{
	my %bestOdds = %{$_[0]};

	my $best1  = $bestOdds{'1'};
	my $bestX  = $bestOdds{'X'};
	my $best2  = $bestOdds{'2'};
	
	my $profit1 = $best1 * 100;  
	my $betX  = $profit1 / $bestX;  
	my $bet2  = $profit1 / $best2;
	
	my $profit  =  ($best1 * 100) - (100 + $betX + $bet2) ;
	my $profitPercent = ($profit / (100 + $betX + $bet2)) * 100;
	return $profitPercent;
}
	


sub findBestOdds($)
{
	my $dataWithBets  = $_[0];
	#print $dataWithBets; die;
	my %bestOdds; 
	$bestOdds{'1'}  = 0.1;
	$bestOdds{'X'}  = 0.1;
	$bestOdds{'2'}  = 0.1;
	
	foreach(split("\n",$dataWithBets))
	{
		my $lineWithBetData = $_;
		$lineWithBetData =~ s/[^\w\.]/#/g;
		
		if($lineWithBetData =~/(\w+)#{0,2}(\d?\d\.\d\d)(\d?\d\.\d\d)(\d?\d\.\d\d)/ )
		{
			if ($1 eq 'Interwetten')
			{
				#print STDOUT "ignoring== $lineWithBetData\n";
				next;			
			}
			if($2 gt $bestOdds{'1'})
			{
				$bestOdds{'1'}  = $2;
			}
			if($3 gt $bestOdds{'X'})
			{
				$bestOdds{'X'}  = $3;
			}
			if($4 gt $bestOdds{'2'})
			{
				$bestOdds{'2'}  = $4;
			}
		}
	}
	#die;
	return %bestOdds;

};

#tod refactor getRawDataOfEvent 
sub getRawDataOfEvent($)# todo create synchronous-mocked version
{
	my $linkToEvent = $_[0];
	createJavaScriptForDownload($linkToEvent);
		
	my $isProcessFinished = 0;
	my $retryIdx = 0; 
	my $rawDataToReturn = '';
	my $rawDataPath = 'tmp/rawdataevent.txt';
	
	my $pid = fork();
	my $isParrentProcess = ($pid == 0); 
	if($isParrentProcess)
	{
		my $limitOfAttempts = 3;
		sleep(1);
		$isProcessFinished = (waitpid($pid, WNOHANG) > 0);
		$retryIdx++;
		while($isProcessFinished == 0 and $retryIdx++ < $limitOfAttempts)
		{
			sleep(26);			
			$isProcessFinished = (waitpid($pid, WNOHANG) > 0);
			print STDOUT "no answer from $linkToEvent  attemp no $retryIdx/$limitOfAttempts\n";					
		}
	}	
	else
	{
		my $toReturnInChild = `phantomjs.exe tmp/download1x2Data.js`;
		open RAWDATA , ">", $rawDataPath or die;
		print RAWDATA $toReturnInChild;
		close RAWDATA or die;		
		exit(1);
	}
	
	if($isProcessFinished)
	{
		open(my $fh, '<', $rawDataPath) or die "cannot open file $rawDataPath";
		{
			local $/;
			$rawDataToReturn = <$fh>;#doesn't needed
		}
		close $fh or die;	
	}	
	else 
	{
		kill 9, $pid;
		print STDOUT "UNABLE TO FETCH $linkToEvent PID $pid \n";
	}
	
	#simplifyFormatOfRawdata($rawDataPath); #i think better would be do it on file or before creation file	
	open(my $fh, '<', $rawDataPath) or die ;
	$rawDataToReturn = $fh;
	close $fh or die;
	
	return $rawDataToReturn;
}

sub simplifyFormatOfRawdata(\$)
{
	my $rawDataContent = ${$_[0]};
	
	removeEmptyLines($rawDataContent);
	leaveOnlyBetsStakesDataInRawdataFile($rawDataContent);
	${$_[0]} = $rawDataContent; 
	
	
}

#todo: mock net 

sub leaveOnlyBetsStakesDataInRawdataFile(\$)
{
	my $rawDataContent = ${$_[0]};
	
	
	$rawDataContent =~ m#(Bookmakers:[\s\S]*?)Average odds#m or die;
	
	
	my $rawDataContentFilteredOut;
	foreach(split("\n",$rawDataContent))
	{

		my $lineOfRawData  = $_;
		if($lineOfRawData =~ m|(\d{1,2}\.\d{2})|)
		{
			$rawDataContentFilteredOut .=  " ".$1 ; 
		}
		elsif($lineOfRawData =~ /([A-Za-z0-9].*)/)
		{
			chomp($1);			
			$rawDataContentFilteredOut = $rawDataContentFilteredOut . "\n$1"  ; 
		
		}
		elsif($lineOfRawData =~ /^(Bookmakers:.*)/)
		{
			$rawDataContentFilteredOut = $rawDataContentFilteredOut . "$1\n";
		}	
	}
	
	${$_[0]} = $rawDataContentFilteredOut;	

}


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

#maybe something more advanced for parsing files

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
	#open OUTPUT, '>', "output.txt" or die "Can't create filehandle: $!";
	#select OUTPUT;
	my @linksToEvents;
	foreach (split("\n",$tableWithEvents))
	{
		my $lineWithData = $_;
		if($lineWithData =~ /a href="(.*?)" class="in-match"/)
		{
			my $linkToEvent = "http://www.betexplorer.com$1";
			#if(checkNumberOfBookmaker($lineWithData) > 0) #doesn't used anymore propably it was used to check how many bookmaker link contains
			#{
			push @linksToEvents, "http://www.betexplorer.com$1";			
			#	print STDOUT "after link==$1 \n";
			#}
			#print STDOUT 'no of bookmakers ' . checkNumberOfBookmaker($lineWithData) ."\n";
			
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
