#!/usr/bin/perl -w
package BetExplorerDownloader;
use strict;
use warnings;

use XML::Tidy;
use POSIX ":sys_wait_h";
use 5.010;
use Data::Dumper;
use XML::LibXML;
use CategoryPage;
use File::Copy qw(copy);
use WojtekToolbox;


#($#ARGV +1) == 1 or die 'usage surebet.pl inputFile';

#my $inputFileName = $ARGV[0];

#open(INPUT, "<", $inputFileName) or die "Unable to open file"; 
###############SUB PROTOTYPES############################################
sub new();
sub loadSelectorFile($);
sub getsLinksForAllEventsFromSubCategory($$);
sub getTableWithEvents($);
sub getLinksToEventFromTable($);
sub findTheBestOddInLinkToEvent($);
sub generateOutputXML();
sub downloadRawDataOfChoosenOfert(\%);
sub generateReportLine($);
sub getRawDataOfEvent($);
sub findBestOdds($);
sub calculateProfit(\%);
sub checkNumberOfBookmaker($);
sub convertRawDownloadedDataToHash($);
sub createEventListXML($$$);
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

#findTheBestOddInLinkToEvent('http://www.betexplorer.com/soccer/germany/bundesliga/mainz-schalke/GEcPMEM6/#1x2');

############################MAIN##############################################


my $pathToXmlSelector = $ARGV[0];
$pathToXmlSelector = "input/parameters/polandEkstraklasaSelector.xml";                                       
#generateOutputXML($pathToXmlSelector);



####################SUB DEFINITIONS############################################
sub new()
{
		
	my $class = shift;
	my $self = bless {}, $class;
	return $self; 
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

sub findTheBestOddInLinkToEvent($)
{
	open OUTPUT, '>', "output.html" or die "Can't create filehandle: $!";
	select OUTPUT; 
	my $linkToEvent = $_[0];
	my $content  = tryToGetUrl($linkToEvent,3) or die "BetExplorerDownloader: unable to get $linkToEvent \n";
	my $best1odd;
	
	#$content =~ /td class="course best-betrate arrow-up" data-odd=(.)/m;
	#$content =~ /course best-betra(te)/m;
	print $content;
}


sub generateOutputXML()
{
	my $self = shift;
	
	
	defined  $self->{mSelectorFile} or die "The selector file didn't loaded\n";
	my $pathToXmlSelector = $self->{mSelectorFile};
	
	my $xmlParser = XML::LibXML->new; 
	my $outputXmlPath = "output/fetchedData.xml";
	copy $pathToXmlSelector, $outputXmlPath or die $?; 
	my $doc = $xmlParser->parse_file($pathToXmlSelector);
	my $xpath = "/dataChoosenToDownload";
	$xpath = "/note/dataChoosenToDownload";
	$xpath = "";
	my @rootXmlNode = $doc->findnodes("/");
	
	
	createEventListXML($rootXmlNode[0], $xpath, $outputXmlPath);
	correctFormatXmlDocument($outputXmlPath);
	updateEventListXMLWithEventDetails($outputXmlPath);
	updateEventListXMLWithBookmakerOffer($outputXmlPath);
	
}

sub correctFormatXmlDocument($)
{

	my $pathToXmlDocumentToCorrect = shift;
 # create new   XML::Tidy object from         MainFile.xml
  my $tidy_obj = XML::Tidy->new('filename' => $pathToXmlDocumentToCorrect);

  # Tidy up the indenting
     $tidy_obj->tidy();

  # Write out changes back to MainFile.xml
     $tidy_obj->write();
    
}



sub updateEventListXMLWithEventDetails($)
{
	die "updateEventListXMLWithEventDetails: Not implemented yet\n"

}


sub updateEventListXMLWithBookmakerOffer($)
{
	die "updateEventListXMLWithBookmakerOffer: Not implemented yet\n"

}


sub updateXmlNodeWithDataFromBookmaker($$)
{
	#my $currentlyUpdatedNode = $_[0]; # not sure if it is needed maybe better to load every time from $outputXmlPath
	my ($xsubPath, $outputXmlPath) = @_; 
	
		
	my $rootNode = getRootNode($outputXmlPath); 
	for(getAllSubCategories($rootNode, $xsubPath))
	{
		my $subCategoryName = $_;
		my $xpathToNewChildNode = "${xsubPath}/${subCategoryName}";
		
		if(isLinkToEvent($subCategoryName))
		{
			addLinkToEventToOfferXml($xsubPath,  $subCategoryName, $outputXmlPath);
		}
		else
		{
			addChildSubcategoryNodeToOfferXml($xsubPath,  $subCategoryName, $outputXmlPath);
		}
		updateXmlNodeWithDataFromBookmaker($xpathToNewChildNode,$outputXmlPath);
	}
	
}
	
sub isLinkToEvent($)
{
	my $stringToCheck = $_[0];
	return ($stringToCheck =~ m|http://|);
	
	#print "stringToParse $stringToParse\n";
	#die "unimplemented yet";

}
sub getRootNode($)
{
	my $pathToXmlSelector = shift;
	
	my $xmlParser = XML::LibXML->new;
	my $doc = $xmlParser->parse_file($pathToXmlSelector) or die $?;
	my @rootXmlNode = $doc->findnodes("/");#$doc->findnodes("/")->[0];
	return $rootXmlNode[0];
}

sub addLinkToEventToOfferXml($$$)
{
	my ($xpathToParent, $linkToEvent, $outputXmlFilePath) = @_;
	
	my $xmlParser = XML::LibXML->new;
	my $document = $xmlParser->parse_file($outputXmlFilePath) or die $?;
	my $parentNodeToUpdate = $document->findnodes($xpathToParent)->[0] or die $?;
	
	my $newNode = XML::LibXML::Element->new('event');
	$newNode->setAttribute('url',$linkToEvent);
	#my $lineBreakTextNode = XML::LibXML::Text->new("\n");
	
	$parentNodeToUpdate->addChild($newNode);	
	$document->toFile($outputXmlFilePath) or die $?;	


};

sub addChildSubcategoryNodeToOfferXml($$$)
{

	my ($xpathToParent, $nameOfNewChildNode, $outputXmlFilePath) = @_;
	
	my $xmlParser = XML::LibXML->new;
	my $document = $xmlParser->parse_file($outputXmlFilePath) or die $?;
	my $parentNodeToUpdate = $document->findnodes($xpathToParent)->[0] or die $?;
	my $newNode = XML::LibXML::Element->new($nameOfNewChildNode);
	my $lineBreakTextNode = XML::LibXML::Text->new("\n");	
	$parentNodeToUpdate->addChild($newNode);	
	$document->toFile($outputXmlFilePath) or die $?;	
}
		
		
sub createEventListXML($$$)
{
	my $xmlNode = $_[0];
	my $xpath = $_[1];
	my $outputXmlPath = $_[2];
	
	#foreach (getAllSubCategories($xmlDoc, $xpath))
	foreach ($xmlNode->nonBlankChildNodes())
	{
		my $node = $_;				
		
		my $nodeName = $node->nodeName;
			
		if($node->hasChildNodes() )
		{
			my $childNode = $_;
			createEventListXML($node,"$xpath/$nodeName", $outputXmlPath);
		}
		else
		{
			print "END OF RECURENCE $xpath/$nodeName\n";
			#updateXmlNodeWithDataFromBookmaker($node, "${xpath}/${nodeName}", $outputXmlPath);
			updateXmlNodeWithDataFromBookmaker("${xpath}/${nodeName}", $outputXmlPath);				
		}
		
	
		#print "END OF RECURENCE 2 $xpath\n"
	}
			

};


sub getAllSubCategories($$)
{
	#IN:  "soccer/Portugal"
	#Out arra: ["LaLiga","LaLiga", "and so on"];
	my $xmlNode = $_[0];
	my $subCategoryXpath = $_[1];
	
	my $categoryPage = CategoryPage->makeCategoryPageObject($subCategoryXpath);
	
	my @subCategories  = $categoryPage->getAllSubCategories();
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

sub getRawDataOfEvent($)
{
	my $linkToEvent = $_[0];
	createJavaScriptForDownload($linkToEvent);
		
	my $res = 0;
	my $retryIdx = 0; 
	my $toReturn = '';
	
	my $pid = fork();
	if(not $pid)
	{
		my $toReturnInChild = `phantomjs.exe download1x2Data.js`;
		open RAWDATA , ">", 'rawdataevent.txt' or die;
		print RAWDATA $toReturnInChild;
		close RAWDATA or die;
		#print STDOUT "before exit\n";		
		exit(1);
	}
	else
	{
		my $numberOfAttempts = 3;
		while($res == 0 and $retryIdx++ < $numberOfAttempts)
		{
			sleep(26);
			$res = waitpid($pid, WNOHANG);
			print STDOUT "no answer from $linkToEvent  attemp no $retryIdx/$numberOfAttempts\n";					
		}
	}
	
	
	if($res == 0)
	{
		kill 9, $pid;
		print STDOUT "UNABLE TO FETCH $linkToEvent PID $pid RESPONSE $res\n";
	}
	else 
	{
		#print STDOUT "process $pid finished\n";
		open(my $fh, '<', 'rawdataevent.txt') or die "cannot open file rawdataevent.txt";
		{
			local $/;
			$toReturn = <$fh>;;
		}
		close $fh or die;
	
	}
	
	
	
	return $toReturn;
}

sub createJavaScriptForDownload($)
{
	my $linkToReplace = $_[0];
	
	open( TEMPLATE  , "<" , 'download1x2Data_template.js') or die;
	
	open( JAVASCRIPT  , ">" , 'download1x2Data.js') or die;
	
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