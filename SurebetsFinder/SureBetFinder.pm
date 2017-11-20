#!/usr/bin/perl -wait
use warnings;
use strict;

package SureBetFinder;

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
	my ($self,$bookmakerOfferFilename);

	#todo validate $bookmakerOfferFilename  
	$self->{offerFile} = $bookmakerOfferFilename; 
	
};
sub generateSurebetsFile($)
{
	die 'unimplemented yet';

};


1