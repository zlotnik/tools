#!/usr/bin/perl -wait
use warnings;
use strict;
use XML::LibXML;
use lib '../BookmakerOfferDownloader/';
use BookmakerXmlDataParser;

package ProfitabilityCalculator;
use File::Copy;

#########SUB DECLARATION#############
sub new();
sub loadBookmakersOfferFile($);
sub generateOfferProfitabilityFile($);
sub initializeOfferProfitabilityFile($);
sub addBestOption($);
sub findBestBetCombination($);
##########SUB DEFININTION############

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

sub initializeOfferProfitabilityFile($)
{
	my($self, $pathToOfferProfitabilityFile) = @_;
	copy $self->{offerFile}, $pathToOfferProfitabilityFile or die;	
}

sub findBestBetCombination($)
{
	my ($eventNode) = @_;
	
	my $allBestOptionsXMLNode;
	foreach(getEachOptionSubNodes($eventNode))
	{
		my $anOptionNode = $_;
		my $bestPriceXMLNode = findBestPrice($anOptionNode);
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

sub generateOfferProfitabilityFile($)
{
	my ($self, $offerProfitabilityOutputFilename) = @_;
	
	$self->initializeOfferProfitabilityFile($offerProfitabilityOutputFilename);
	
	my $xmlParser = XML::LibXML->new; 
	my $xmlParserDoc = $xmlParser->parse_file($offerProfitabilityOutputFilename) or return 0;
		
	my @allEventNodes = $xmlParserDoc->findnodes("/note/eventList//*//event");
	foreach(@allEventNodes)
	{		
		my $eventNode = $_;
		addBestOption($eventNode);	
	}
	#save file
};


1