#!/usr/bin/perl
use BookmakerBetDownloader;
use XML::Simple;




my @parserList = ("Marathon", "BetExplorer");
my $theBookmakerBetDownloader = BookmakerBetDownloader->new(@parserList);





my @filter = ("Soccer->Germany",
	      "Soccer->Polland"
	     );


	
my $outXmlFileName = "bets.xml"; 
my $numberOfBetDownload = $theBookmakerBetDownloader->downloadOffer(@filter);
if ($numberOfBetDownload > 0 );
{
	print $theBookmakerBetDownloader->getXml();
	$theBookmakerBetDownloader->reset();


}

#print XMLout ($events , RootName => "events" );







