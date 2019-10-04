#!/usr/bin/perl
#
#
use strict;
use warnings;
use XML::LibXML;


sub showAllSurrebetsInDirectory($);
sub showMySureBets($);

defined $ARGV[0] or die "You must specify a path to directory with bookmaker offer files"; 


my $bookMakerOfferFiles_Directory = $ARGV[0];


print showAllSurrebetsInDirectory($bookMakerOfferFiles_Directory);


sub showMySureBets($)
{
	my($bookMakerOffer_xml) = @_;
	my $xpathSelectionPattern = "//event[./bestCombinations/_1X2/profit > 0 ]";
	
	my @sureBets_nodes = $bookMakerOffer_xml->findnodes($xpathSelectionPattern);

	my $toReturn = '';
	foreach(@sureBets_nodes)
	{
		my $surebet_node = $_;
		$surebet_node =~ /(http.*?)\"/;
		my $event_url = $1;

		$surebet_node =~ /\<profit\>(.*?)\</;				
		my $profit = $1;

		$surebet_node =~ /(http.*)\/(.*?)(\/.*?\/)\"/;
		my $event_name = $2;

		$toReturn = "EventName: $event_name PROFIT: $profit \n";
	}

	return $toReturn;
}

sub showAllSurrebetsInDirectory($)
{	
	my( $directoryPathWith_bookmakerOfferFiles ) = @_;


	#my $bookMakerOffer_filePatern = $pathWith_bookmakerOfferFiles . "/" .'*.xml';
	#my @bookmakerOfferFiles = <$bookMakerOffer_filePatern>;

	opendir( BOOKMAKER_OFFER_DIR, $directoryPathWith_bookmakerOfferFiles ) or die "Isn't possible to open directory $directoryPathWith_bookmakerOfferFiles \n" ;
	my @bookmakerOfferFiles = grep( /\.xml$/ , readdir(BOOKMAKER_OFFER_DIR) );

	my $allSurebets = "Sb:\n";
	foreach( @bookmakerOfferFiles )
	{
		my $bookMakerOfferFilePath = $directoryPathWith_bookmakerOfferFiles . "/"  .  $_;

		my $xmlWith_bookmakerOffer = XML::LibXML->new();		
		if( $xmlWith_bookmakerOffer =  $xmlWith_bookmakerOffer->parse_file($bookMakerOfferFilePath ) )
		{
			$allSurebets .= showMySureBets($xmlWith_bookmakerOffer); 	
		}
		else
		{
			print "WARNING: File $bookMakerOfferFilePath isn't correct xml file\n";
		}
	}
	return $allSurebets;
}
	 
