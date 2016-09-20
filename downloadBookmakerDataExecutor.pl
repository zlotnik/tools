#!/usr/bin/perl
use BookmakerOfferDownloader::BookmakerOfferDownloader;
#use XML::Simple;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/BookmakerOfferDownloader';

my @parserList = ("Marathon", "Betexplorer");
#my $theBookmakerBetDownloader = BookmakerOfferDownloader->new(@parserList);
my $theBookmakerBetDownloader = new BookmakerOfferDownloader(\@parserList);





my @filter = ("Soccer->Germany",
	      "Soccer->Polland"
	     );


	
my $outXmlFileName = "bets.xml"; 
my $numberOfBetDownload = $theBookmakerBetDownloader->downloadOffer(@filter);
if ($numberOfBetDownload > 0 )
{
	print $theBookmakerBetDownloader->getXml();
	$theBookmakerBetDownloader->reset();


}

#print XMLout ($events , RootName => "events" );







