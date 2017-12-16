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
	my($pathToOfferProfitabilityFile) = @_;
	#copy("output/model/emptySurebetsFile.xml", $pathToSurebetFile) or die;
	#copy bookmaker offer file
}

sub findBestBetCombination($)
{

};

sub addBestOption($)
{
	my ($eventNode) = @_;
    findBestBetCombination($eventNode);
	#udpate node

};

sub generateOfferProfitabilityFile($)
{
	my ($self, $offerProfitabilityOutputFilename) = @_;
	
	initializeOfferProfitabilityFile($offerProfitabilityOutputFilename);
	
	#load file
	
	#my @allEventNodes = findnodes("/note/eventList//*//event");
	#foreach(@allEventNodes)
	{
		my $eventNode = $_;
		addBestOption($eventNode);	
	}
	#save file
};


1