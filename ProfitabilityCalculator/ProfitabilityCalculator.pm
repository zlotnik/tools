#!/usr/bin/perl -wait
use warnings;
use strict;
use XML::LibXML;
use XML::Tidy;
use lib '../BookmakerOfferDownloader/';
use BookmakerXmlDataParser;

package ProfitabilityCalculator;
use File::Copy;

#########SUB DECLARATION#############
sub new();
sub loadBookmakersOfferFile($);
sub generateOfferProfitabilityFile($);
sub cloneBookmakerOfferFile($);
sub addBestOption($);
sub findBestBetCombination($);
sub leaveInProfitabilityFileOnlyBestPrices($);
sub updateEventNodeWithBestCombinations($);
sub updateBestOptionNodeWithProfitabilityData($);
sub splitBestcombinationsNodeToProductsGroupNodes($);
sub splitProductgroupNodeToProductsNodes($);
sub splitEventNodeToBestCombinationNode($);
sub leaveInProfitabilityFileOnlyBestPrices($);
sub getAllProductNodes($);
##########SUB DEFININTIONS############

sub new()
{
	my ($class) = @_;
	my $self;
		
	$self = bless { offerFile => undef },$class;
	
	return $self; 
};

sub loadBookmakersOfferFile($)
{
	my ($self,$bookmakerOfferFilename) = @_;

	#todo validate $bookmakerOfferFilename
	my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new();
	
	$aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($bookmakerOfferFilename) or die "Incorrect format of bookmaker offer file";
	
	$self->{offerFile} = $bookmakerOfferFilename; 
	
};

sub cloneBookmakerOfferFile($)
{
	my($self, $pathToOfferProfitabilityFile) = @_;
	copy $self->{offerFile}, $pathToOfferProfitabilityFile or die;	
}

sub splitProductgroupNodeToProductsNodes($)
{
	my ($eventOfferForProductGroup) = @_;
	die;
}

#sub leaveInProfitabilityFileOnlyBestPrices($)
#{
#	my ($eventOfferForProductGroup) = @_;

#	my @products = splitProductgroupNodeToProductsNodes($eventOfferForProductGroup);
	
	
#	foreach(@products)
#	{
#		my $productName = $_;
		
	
#	}
	

#}

sub splitBestcombinationsNodeToProductsGroupNodes($)
{
	my ($eventNode) = @_;
	
	my @productGroupNodes = $eventNode->nonBlankChildNodes();
	print $productGroupNodes[0];
	
	return @productGroupNodes;
	
}

sub splitEventNodeToBestCombinationNode($)
{
	my ($eventNode) = @_;
	return $eventNode->nonBlankChildNodes()->[0];
	
};

sub findBestBetCombination($)
{
	my ($eventNode) = @_;
	
	my $allBestOptionsXMLNode;
	my $bestCombinationNode = splitEventNodeToBestCombinationNode($eventNode); 
	foreach(splitBestcombinationsNodeToProductsGroupNodes($bestCombinationNode))
	{
		my $eventOfferForProductGroup = $_;
		
		 #add Product Group to documentation
		my $bestPriceXMLNode = leaveInProfitabilityFileOnlyBestPrices($eventOfferForProductGroup);
		#apply $bestPriceXMLNode  --> $allBestOptionsXMLNode
	}
	return $allBestOptionsXMLNode;
	
};


sub updateBestOptionNodeWithProfitabilityData($)
{
	my ($bestOptionXMLNode) = @_;

}

sub addBestOption($)
{
	my ($eventNode) = @_;
    my $bestOptionXMLNode = findBestBetCombination($eventNode);
	updateBestOptionNodeWithProfitabilityData($bestOptionXMLNode);
	#apply bestOptionXMLNode to XML 
	#udpate node

};


sub addBestPricesForProduct($) #unused
{
	my ($producNode) = @_;
	#gothrough each child and leave only best


}

sub addBestCombinationsForEventGroup($$) ##unused
{
	my ($productGroupNode, $anProductGroup) = @_;

	#split to product group 
    #@products = findAllProduct($productGroupNode, $anProductGroup)	
	my @products;
	foreach(@products)
	{
		addBestPricesForProduct($productGroupNode);
		#instead of addBest filter best albo leave
	}
}


sub updateEventNodeWithBestCombinations($)
{
	my ($eventNode) = @_;

	#create empty $BestCombinationssNode node by cloning existing node
	#go Throught each product groupt
	my @productGroups ; #how to initialize it??
	foreach(@productGroups)
	{
		my $anProductGroup = $_;
		my $productGroupNode; # = find product group node 
		addBestCombinationsForProductGroup($productGroupNode, $anProductGroup)
		
	}
}


sub injectBestCombinationsNodeAfterEventNodes($)
{
	my ($bookMakerOfferProfitabilityFilePath) = @_; 
	
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($bookMakerOfferProfitabilityFilePath) or return 0;
	
	
	my @eventNodes = $xmlParserDoc->findnodes("/note/eventList//*//event/*");
    
	foreach(@eventNodes)
	{
		my $eventNode = $_;
		my $new_parent= $xmlParserDoc->createElement("bestCombinations");
		my $old_parent = $eventNode->parentNode;
	
		$new_parent->addChild($eventNode);
		$old_parent->addChild($new_parent);	
	}
	
	$xmlParserDoc->toFile($bookMakerOfferProfitabilityFilePath) or die;
	
    my $tidy_obj = XML::Tidy->new('filename' => $bookMakerOfferProfitabilityFilePath); #copy paste from betexplorer sub correctFormatXmlDocument($) it will be good to move it into tools

	$tidy_obj->tidy();
	$tidy_obj->write();
};

sub getAllProductNodes($)
{
	my ($rootNode) = @_;

	my @allProductNodes = $rootNode->findnodes("/note/eventList//*//bestCombinations/*/*");
	return @allProductNodes;
	#create empty $BestCombinationssNode node by cloning existing node
	#go Throught each product groupt
	

}

sub leaveInProductNodeOnlyBestPrices($)
{
		my ($productNode) = @_;
		my $maximumPrice = 0;
		
		foreach($productNode->nonBlankChildNodes())#better to encapsulate to some sub like findBestPrice
		{
			my $bookMakerOfferForProduct = $_;
			($bookMakerOfferForProduct =~ /<(.*)>(\d{1,2}\.\d\d)</) or die;
			my $bookMakerName = $1;
			my $bookMakerOfferForProductPrice = $2;
			if ($bookMakerOfferForProductPrice > $maximumPrice)
			{
				$maximumPrice = $bookMakerOfferForProductPrice;
			}
		}

		foreach($productNode->nonBlankChildNodes())
		{
			my $bookMakerOfferForProduct = $_;
			($bookMakerOfferForProduct =~ /<(.*)>(\d{1,2}\.\d\d)</) or die;
			my $bookMakerName = $1;
			my $bookMakerOfferForProductPrice = $2;
			if($bookMakerOfferForProductPrice < $maximumPrice)
			{
				$productNode->removeChild($bookMakerOfferForProduct);
			}
					
		}
		print "";
		
}


#todo remove unused subs
sub leaveInProfitabilityFileOnlyBestPrices($)
{
	my ($offerProfitabilityOutputFilename) = @_;
	
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($offerProfitabilityOutputFilename) or return 0;
    my @allProductNodes = getAllProductNodes($xmlParserDoc);
	
	foreach(@allProductNodes)
	{
		my $productNode = $_;
		leaveInProductNodeOnlyBestPrices($productNode);
		
	};
	
	$xmlParserDoc->toFile($offerProfitabilityOutputFilename);
	my $tidy_obj = XML::Tidy->new('filename' => $offerProfitabilityOutputFilename); #copy paste from betexplorer sub correctFormatXmlDocument($) it will be good to move it into tools

	$tidy_obj->tidy();
	$tidy_obj->write();
	#getAllProductNodes()
	#splitEventNodeToBestCombinationNode();
	

}

sub generateOfferProfitabilityFile($)
{
	my ($self, $offerProfitabilityOutputFilename) = @_;
	
	$self->cloneBookmakerOfferFile($offerProfitabilityOutputFilename);
			
	
	#my $xmlParser = XML::LibXML->new; 
	#my $xmlParserDoc = $xmlParser->parse_file($offerProfitabilityOutputFilename) or return 0;
	
	#my @allEventNodes = $xmlParserDoc->findnodes("/note/eventList//*//event");
	
	
	injectBestCombinationsNodeAfterEventNodes($offerProfitabilityOutputFilename);
	leaveInProfitabilityFileOnlyBestPrices($offerProfitabilityOutputFilename);
	#updateWithProfitabilityData();
	
	die;
	
	
	#to removeVVV left just to know which sub remove
	#foreach(@allEventNodes)
	{		
	#	my $eventNode = $_;
			
	#	addBestOption($eventNode);	
		#
	#	updateEventNodeWithBestCombinations($eventNode)
		#
	}
	#save file
};


1;
