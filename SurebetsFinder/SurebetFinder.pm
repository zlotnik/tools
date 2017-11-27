#!/usr/bin/perl -wait
use warnings;
use strict;
use XML::LibXML;

package SurebetFinder;

#########SUB DECLARATION#############

sub new();
sub loadBookmakersOfferFile($);
sub generateSurebetsFile($);
sub isValidBookOfferFile($);
sub isItCorrectXmlFile($);

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
	if (!isValidBookOfferFile($bookmakerOfferFilename))
	{
		die;
	}
	$self->{offerFile} = $bookmakerOfferFilename; 
	
};

sub isValidBookOfferFile($)
{
	my ($bookmakerOfferFilename) = @_;
	(-e $bookmakerOfferFilename) or die "File doesn't exist";
    
	isItCorrectXmlFile($bookmakerOfferFilename) or die;
	
	#TODO check if it is correct surebet file;
	
	die "finished here";
	return 1;
} 


sub isItCorrectXmlFile($)
{
	my ($pathToXmlSelector) = @_;
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
#above should be moved to parser


sub generateSurebetsFile($)
{
	die 'unimplemented yet';

};


1