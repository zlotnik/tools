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

sub addBestOption($)
{
	my ($eventNode) = @_;
    findBestOptions($eventNode);
	#udpate node

};

sub generateOfferProfitabilityFile($)
{
	my ($self, $offerProfitabilityOutputFilename) = @_;
	
	initializeOfferProfitabilityFile($xmlSurebetOutputFilename);
	
	#load file
	
	@eventNode = findnodes("/note/eventList//*//event")
	foreach(@eventNode)
	{
		my $eventNode = $_;
		addBestOption($eventNode);
	
	}
		
};


1