#!/usr/bin/perl -wait
use warnings;
use strict;
use XML::LibXML;
use lib '../BookmakerOfferDownloader/';
use BookmakerXmlDataParser;

package ProfibilityCalculator;
use File::Copy;

#########SUB DECLARATION#############
sub new();
sub loadBookmakersOfferFile($);
sub generateOfferProfibilityFile($);
sub initializeOfferProfibilityFile($);
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

sub initializeOfferProfibilityFile($)
{
	my($pathToOfferProfibilityFile) = @_;
	#copy("output/model/emptySurebetsFile.xml", $pathToSurebetFile) or die;
	#copy bookmaker offer file
}

sub addBestOption($)
{
	my ($eventNode) = @_;
    findBestOptions($eventNode);
	#udpate node

};

sub generateOfferProfibilityFile($)
{
	my ($self, $offerProfibilityOutputFilename) = @_;
	
	initializeOfferProfibilityFile($xmlSurebetOutputFilename);
	
	#load file
	
	@eventNode = findnodes("/note/eventList//*//event")
	foreach(@eventNode)
	{
		my $eventNode = $_;
		addBestOption($eventNode);
	
	}
		
};


1