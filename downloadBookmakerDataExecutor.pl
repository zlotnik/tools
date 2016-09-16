#!/usr/bin/perl
use BookmakerBetDownloader;
use XML::Simple;




my $theBookmakerBetDownloader = BookmakerBetDownloader->new();

my $thePinnacleParser = PinnacleParser->new();
my $theMarathonParser = MarathonParser->new();

$theBookmakerBetDownloader->add($theBookmakerBetDownloaderMarathon);
$theBookmakerBetDownloader->add($theBookmakerBetDownloaderPinnacle);


my $outXmlFileName = "bets.xml"; 
my $numberOfBetDownload = $theBookmakerBetDownloader->download();
if ($numberOfBetDownload > 0 );
{
	$theBookmakerBetDownloader->saveToXml();
	$theBookmakerBetDownloader->reset();


}

#print XMLout ($events , RootName => "events" );







