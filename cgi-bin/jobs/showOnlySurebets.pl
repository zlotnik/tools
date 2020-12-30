#!/usr/bin/perl
#
#
use strict;
use warnings;
use XML::LibXML;
use XML::Simple;


sub showAllSurrebetsInDirectory($);
sub showMySureBets($);
sub fetch_EventName_fromEventBestCombinationNode($);
sub fetch_1_Price_fromEventBestCombinationNode($);
sub fetch_X_Price_fromEventBestCombinationNode($);
sub fetch_2_Price_fromEventBestCombinationNode($);
sub fetch_BookmakerName_1_fromEventBestCombinationNode($);
sub fetch_BookmakerName_X_fromEventBestCombinationNode($);
sub fetch_BookmakerName_2_fromEventBestCombinationNode($);
sub fetch_profit_fromEventBestCombinationNode($);
sub fetch_Price_fromEventBestCombinationNode($$);
sub fetch_BookmakerName_fromEventBestCombinationNode($$);
sub remove_ampersandPart_ofURL($);

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
	

		my $profit = fetch_profit_fromEventBestCombinationNode($surebet_node);
		if($profit != 1) #temporary workaround untill issue with empty nodes will be solved in backend functionality
		{			
			my $event_name = fetch_EventName_fromEventBestCombinationNode($surebet_node);
			my $price_1 = fetch_1_Price_fromEventBestCombinationNode($surebet_node);
			my $price_X = fetch_X_Price_fromEventBestCombinationNode($surebet_node);
			my $price_2 = fetch_2_Price_fromEventBestCombinationNode($surebet_node);
			my $bookmaker_1 = fetch_BookmakerName_1_fromEventBestCombinationNode($surebet_node);
			my $bookmaker_X = fetch_BookmakerName_X_fromEventBestCombinationNode($surebet_node);
			my $bookmaker_2 = fetch_BookmakerName_2_fromEventBestCombinationNode($surebet_node);			
			$toReturn .= "EventName: $event_name PROFIT: $profit ";
			$toReturn .= "bookmaker_1 $bookmaker_1 bookmaker_x $bookmaker_X bookmaker_2 $bookmaker_2 ";
			$toReturn .= "price_1 $price_1 price_X $price_X price_2 $price_2\n";
		}		
	}

	return $toReturn;
}

sub fetch_profit_fromEventBestCombinationNode($)
{
	my ($surebet_node) = @_;
	$surebet_node =~ /\<profit\>(.*?)\</;				
	my $profit = $1;
	return $profit;

}

sub remove_ampersandPart_ofURL($)
{
	my ($url) = @_;

	if($url =~ /(\S*)(\&\S*)/)
	{
		return $1;
	}
	else
	{
		return $url;
	}
}

sub fetch_EventName_fromEventBestCombinationNode($)
{
	my ($surebet_node ) = @_;

	$surebet_node =~ /(https.*?)\"/;
	my $event_url = $1;
	my $event_name;

	$event_url = remove_ampersandPart_ofURL($event_url); #this should be done earlier at downloading stage

	if ($event_url =~ /(https:\/\/www.betexplorer.com.*)\/(.*?)(\/.*?\/)/)
	{
		$event_name = $2;	
	}
	
	return $event_name

};


sub fetch_Price_fromEventBestCombinationNode($$)
{
	my ($surebet_node, $betOption) = @_;
	my $offerNode = $surebet_node->findnodes("bestCombinations/_1X2/_${betOption}/*[1]");
	return $offerNode;
}

sub fetch_1_Price_fromEventBestCombinationNode($)
{
	my ($surebet_node) = @_;

	return fetch_Price_fromEventBestCombinationNode($surebet_node, '1')
	
};

sub fetch_X_Price_fromEventBestCombinationNode($)
{
	my ($surebet_node) = @_;

	return fetch_Price_fromEventBestCombinationNode($surebet_node, 'X');
};

sub fetch_2_Price_fromEventBestCombinationNode($)
{
	my ($surebet_node) = @_;

	return fetch_Price_fromEventBestCombinationNode($surebet_node, '2');
	
};

sub fetch_BookmakerName_1_fromEventBestCombinationNode($)
{
	my ($surebet_node) = @_;
	my $betOption = '1';

	return fetch_BookmakerName_fromEventBestCombinationNode($surebet_node, $betOption);
	
};

sub fetch_BookmakerName_X_fromEventBestCombinationNode($)
{
	my ($surebet_node) = @_;
	my $betOption = 'X';

	return fetch_BookmakerName_fromEventBestCombinationNode($surebet_node, $betOption);
};

sub fetch_BookmakerName_2_fromEventBestCombinationNode($)
{
	my ($surebet_node) = @_;
	my $betOption = '2';

	return fetch_BookmakerName_fromEventBestCombinationNode($surebet_node, $betOption);
};

sub showAllSurrebetsInDirectory($)
{	
	my( $directoryPathWith_bookmakerOfferFiles ) = @_;


	#my $bookMakerOffer_filePatern = $pathWith_bookmakerOfferFiles . "/" .'*.xml';
	#my @bookmakerOfferFiles = <$bookMakerOffer_filePatern>;

	opendir( BOOKMAKER_OFFER_DIR, $directoryPathWith_bookmakerOfferFiles ) or die "Isn't possible to open directory $directoryPathWith_bookmakerOfferFiles \n" ;
	my @bookmakerOfferFiles = grep( /\.xml$/ , readdir(BOOKMAKER_OFFER_DIR) );

	my $allSurebets = "";
	foreach( @bookmakerOfferFiles )
	{
		my $bookMakerOfferFilePath = $directoryPathWith_bookmakerOfferFiles . "/"  .  $_;

                my $xmlOK =  eval {XMLin($bookMakerOfferFilePath)};

		if( $xmlOK )
		{
		        my $xmlWith_bookmakerOffer = XML::LibXML->new();		
                        $xmlWith_bookmakerOffer = $xmlWith_bookmakerOffer->parse_file($bookMakerOfferFilePath);
			$allSurebets .= showMySureBets($xmlWith_bookmakerOffer); 	
		}
		else
		{
			print STDERR "WARNING: File $bookMakerOfferFilePath isn't correct xml file\n";
		}
	}
	return $allSurebets;
}
	 
sub fetch_BookmakerName_fromEventBestCombinationNode($$)
{
	my ($surebet_node, $betOption) = @_;

	my @offerNode = $surebet_node->findnodes("bestCombinations/_1X2/_${betOption}/*");	
	$offerNode[0] =~ /\<_(\w+)\>/;	
	return $1;	
}
