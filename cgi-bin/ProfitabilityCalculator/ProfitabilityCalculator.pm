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
sub generateOfferProfitabilityFile();
sub findBestBetCombination($);
sub leaveInProfitabilityFileOnlyBestPrices();
sub updateEventNodeWithBestCombinations($);
sub splitBestcombinationsNodeToProductsGroupNodes($);
sub splitProductgroupNodeToProductsNodes($);
sub splitEventNodeToBestCombinationNode($);
sub getAllProductNodes($);
sub updateWithProfitabilityData();
sub getAllProductGroupNodes($);
sub createProfitNode($);
sub tidyXml($);
sub calculateProfit(\@);
sub calculateProfitForTwoWaysBet(\@);
sub calculateProfitForThreeWaysBet(\@);
sub moveProductGroupNodePrices2array($);
sub set_OutputFile($);
sub get_OutputFile();
sub insertBestCombinationsNode();
##########SUB DEFININTIONS############
sub new()
{
	my ($class) = @_;
	my $self;
		
	$self = bless { offerFile => undef },$class;
	
	print "Functional module: ProfitabilityCalculator\n";
	return $self; 
};

sub loadBookmakersOfferFile($)
{
	my ($self,$bookmakerOfferFilename) = @_;

	#todo validate $bookmakerOfferFilename
	my $aBookmakerXmlDataParser = BookmakerXmlDataParser->new();
	
	if (! $aBookmakerXmlDataParser->isCorectDownloadedBookmakerOfferFile($bookmakerOfferFilename))
	{
                #this must be fixed
		print "WARNING: incorrect format of bookmaker offer file\n";
	}


	$self->{offerFile} = $bookmakerOfferFilename; 
	
};


sub splitProductgroupNodeToProductsNodes($)
{
	my ($eventOfferForProductGroup) = @_;
	die;
}

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
		#my $bestPriceXMLNode = leaveInProfitabilityFileOnlyBestPrices($eventOfferForProductGroup);
		#apply $bestPriceXMLNode  --> $allBestOptionsXMLNode
	}
	return $allBestOptionsXMLNode;
	
};

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


sub insertBestCombinationsNode()
{
        my $self = shift;
        
        my $bookMakerOfferProfitabilityFilePath = $self->get_OutputFile(); 
		
	my $xmlParser = XML::LibXML->new; #encapsulate it
	my $xmlParserDoc = $xmlParser->parse_file($bookMakerOfferProfitabilityFilePath) or return 0;
	
	my @eventNodes = $xmlParserDoc->findnodes("/note/data/*/*/*/events/event");
    
	foreach(@eventNodes)
	{
		my $eventNode = $_;

                my $bookmakerBetType = $eventNode->nonBlankChildNodes()->get_node(1);
		my $best_combination_node = $xmlParserDoc->createElement("bestCombinations");
		$best_combination_node->addChild($bookmakerBetType);
		$eventNode->addChild($best_combination_node);	
	}
	
	$xmlParserDoc->toFile($bookMakerOfferProfitabilityFilePath) or die;
	
    my $tidy_obj = XML::Tidy->new('filename' => $bookMakerOfferProfitabilityFilePath); #copy paste from betexplorer sub correctFormatXmlDocument($) it will be good to move it into tools

	$tidy_obj->tidy();
	$tidy_obj->write();
};

sub getAllProductNodes($)
{
	my ($rootNode) = @_;

	my @allProductNodes = $rootNode->findnodes("/note/data/*/*/*/events/event/bestCombinations/*/*");
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
			unless($bookMakerOfferForProduct =~ /<(.*)>(-?\d{1,2}\.\d\d)</)
                        {
                                die "Can not match bookmaker offer: $bookMakerOfferForProduct\n";
                        }

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
			($bookMakerOfferForProduct =~ /<(.*)>(-?\d{1,2}\.\d\d)</) or die;
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
sub leaveInProfitabilityFileOnlyBestPrices()
{
        my $self = shift;
        my $offerProfitabilityOutputFilename = $self->get_OutputFile();
	
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($offerProfitabilityOutputFilename) or return 0;
        my @allProductNodes = getAllProductNodes($xmlParserDoc);
	
	foreach(@allProductNodes)
	{
		my $productNode = $_;
		leaveInProductNodeOnlyBestPrices($productNode);
		
	};
	
	$xmlParserDoc->toFile($offerProfitabilityOutputFilename);
	tidyXml($offerProfitabilityOutputFilename);
	#getAllProductNodes()
	#splitEventNodeToBestCombinationNode();
	

}

sub tidyXml($)
{
	my ($pathToXml) = @_;
	my $tidy_obj = XML::Tidy->new('filename' => $pathToXml); #copy paste from betexplorer sub correctFormatXmlDocument($) it will be good to move it into tools

	$tidy_obj->tidy();
	$tidy_obj->write();

}

sub getAllProductGroupNodes($)
{

	my ($rootNode) = @_;

	my @allProductNodes = $rootNode->findnodes("/note/data/*/*/*/events/event/bestCombinations/*");
	return @allProductNodes;

}

sub createProfitNode($)
{
	my ($productGroupNode) = @_; 
	my $xmlParser = XML::LibXML->new;
	
	
	my $profitNode = XML::LibXML::Element->new( 'profit' );
	
	
	my @prices = moveProductGroupNodePrices2array($productGroupNode);
	
	my $profit = calculateProfit(@prices);
		
    $profitNode->appendText($profit);
	return $profitNode;
	
}

sub calculateProfitForThreeWaysBet(\@)
{
	my ($prices) = @_;
	my ($optionA, $optionB, $optionC) = @{$prices};
	
	my $profit1 = $optionA * 100;  
	my $betX  = $profit1 / $optionB;  
	my $bet2  = $profit1 / $optionC;
	
	my $profit  =  ($optionA * 100) - (100 + $betX + $bet2) ;
	my $profitPercent = ($profit / (100 + $betX + $bet2)) * 100;
	return sprintf("%.2f",$profitPercent);
	
		
};

sub calculateProfitForTwoWaysBet(\@)
{
	my ($prices) = @_;
	my ($optionA, $optionB) = @{$prices};
	die 'unimplemented yet!';
}

sub calculateProfit(\@) 
{
	my ($pricesListRef) = @_;
	my @pricesList = @{$pricesListRef};
	my $numberOfPrices = $#pricesList+1;
	if($numberOfPrices == 3)
	{
		return calculateProfitForThreeWaysBet(@pricesList);
	}
	elsif($numberOfPrices == 2)
	{
		return calculateProfitForTwoWaysBet(@pricesList);
	}
	else
	{
		print "WARNING: stake list is empty\n";	
	}
}

sub moveProductGroupNodePrices2array($)
{
	my ($productGroupNode) = @_;
	my @allProductNodes = $productGroupNode->findnodes("*");
	my @toReturn; 
	
	foreach(@allProductNodes)
	{
		my $productNode = $_; 
		my $bookmakerProductOffer =  $productNode->nonBlankChildNodes()->[0];
		if (defined $bookmakerProductOffer )
		{
			my $bookmakerProductOfferPrice =   $bookmakerProductOffer->textContent;
			push(@toReturn, $bookmakerProductOfferPrice);
		}
		else
		{
			print "WARNING: There is no bookmaker offer for $productNode\n";
		}
	}
	return @toReturn;
	
}

sub updateWithProfitabilityData()
{
	
        my $self = shift;
	
        my $bookMakerOfferProfitabilityFilePath = $self->get_OutputFile();
	my $xmlParser = XML::LibXML->new; 
	my $offerProfitabilityDoc = $xmlParser->parse_file($bookMakerOfferProfitabilityFilePath) or return 0;
	
	my @productGroupNodes = getAllProductGroupNodes($offerProfitabilityDoc);
	
	foreach(@productGroupNodes)
	{
		my $productGroupNode = $_;
		my $profitNode = createProfitNode($productGroupNode);
		$productGroupNode->insertBefore($profitNode, $productGroupNode->getFirstChild());		
		#add profitNode		
	}
	
	$offerProfitabilityDoc->toFile($bookMakerOfferProfitabilityFilePath) or die;
	tidyXml($bookMakerOfferProfitabilityFilePath);
	
}

sub get_OutputFile()
{
	my $self = shift;
	return $self->{outputFilePath}; 

}
sub set_OutputFile($)
{
	my $self = shift;
	my ( $outputFilePath ) = @_;
	$self->{outputFilePath} = $outputFilePath;
}

#todo maybe remove some  xml::tidy invokes in order to  improve efficiency   
sub generateOfferProfitabilityFile()
{
        
	my $self = shift;
        my $offerProfitabilityOutputFilename = $self->get_OutputFile();
       
        if( $self->{offerFile} ne $offerProfitabilityOutputFilename ) 
        {
                copy( $self->{offerFile}, $offerProfitabilityOutputFilename ) or die;
        }
	
        #use self instead of arguments
	$self->insertBestCombinationsNode();
	$self->leaveInProfitabilityFileOnlyBestPrices();
        $self->updateWithProfitabilityData();
	
};


1;
