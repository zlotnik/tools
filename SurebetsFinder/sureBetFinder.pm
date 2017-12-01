#!/usr/bin/perl -wait
use warnings;
use strict;
use XML::LibXML;
use BookmakerXmlDataParser;

package SurebetFinder;

#########SUB DECLARATION#############

sub new();
sub loadBookmakersOfferFile($);
sub generateSurebetsFile($);

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


sub generateSurebetsFile($)
{
	die 'unimplemented yet';

};


1