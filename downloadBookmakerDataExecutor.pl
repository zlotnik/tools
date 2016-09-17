#!/usr/bin/perl
use BookmakerBetDownloader;
use XML::Simple;




my @parserList = ("Marathon", "BetExplorer");
my $theBookmakerBetDownloader = BookmakerBetDownloader->new(@parserList);

#my $thePinnacleParser = PinnacleParser->new();
#my $theMarathonParser = MarathonParser->new();


#$theBookmakerBetDownloader->add($theBookmakerBetDownloaderMarathon);
#$theBookmakerBetDownloader->add($theBookmakerBetDownloaderPinnacle);


my @filter = ("Soccer->Germany",
	      "Soccer->Polland"
	     );


	
my $outXmlFileName = "bets.xml"; 
my $numberOfBetDownload = $theBookmakerBetDownloader->download(@filter);
if ($numberOfBetDownload > 0 );
{
	print $theBookmakerBetDownloader->getXml();
	$theBookmakerBetDownloader->reset();


}

#print XMLout ($events , RootName => "events" );







