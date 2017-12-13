#!/usr/bin/perl -wait
use warnings;
use strict;
use XML::LibXML;
use lib '../BookmakerOfferDownloader/';
use BookmakerXmlDataParser;

package SurebetFinder;
use File::Copy;


#########SUB DECLARATION#############

sub new();
sub loadBookmakersOfferFile($);
sub generateSurebetsFile($);
sub addSurebetsToSurebetFile($$);
sub pullSurebetsFromOffer($);
sub getNOfferOfferFromBookmakerofferFile($);
sub getAmountOfOffersInBookmakerOfferFile();
sub initializeXMLSurebetFile($);
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

sub getNOfferOfferFromBookmakerofferFile($)
{
	my ($self, $idx ) = @_;
	
	open my $bookmaker_fh, "<" , $self->{offerFile} or die;


	close $bookmaker_fh or die;
}

sub getAmountOfOffersInBookmakerOfferFile()
{
	my ($self) = @_;

}

sub pullSurebetsFromOffer($)
{
	my ($offerXmlNode) = @_;

}

sub addSurebetsToSurebetFile($$)
{
	my($idx) = @_;

}


sub initializeXMLSurebetFile($)
{
	my($pathToSurebetFile) = @_;
	copy("output/model/emptySurebetsFile.xml", $pathToSurebetFile) or die;
	
}

sub generateSurebetsFile($)
{
	my ($self, $xmlSurebetOutputFilename) = @_;
	
	
	initializeXMLSurebetFile($xmlSurebetOutputFilename);

	my $idx = 0;
	while($idx < $self->getAmountOfOffersInBookmakerOfferFile())
	{
		my $anOffer = $self->getNOfferOfferFromBookmakerofferFile( $idx);
		 
		my $surebetsXmlNodes;
		if ($surebetsXmlNodes = pullSurebetsFromOffer($anOffer))
		{
			addSurebetsToSurebetFile($surebetsXmlNodes, $xmlSurebetOutputFilename);		
		}
		$idx++;
	}
	#
	
};


1