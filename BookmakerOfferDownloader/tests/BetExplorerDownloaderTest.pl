use strict;
use warnings;
use Test::More tests => 1;
use BetExplorerDownloader;




my $selectorFile = 'input/parameters/polandEkstraklasaSelector.xml';
my $outputFile = "output/downloadedPolandEkstraklasa.xml";

#BetExplorerDownloader::updateEventListXMLWithEventDetails('');


if(-e $outputFile)
{
	unlink $outputFile or  die $?; 
}

my $theBookMakerDownloader =  BetExplorerDownloader->new();  
$theBookMakerDownloader->loadSelectorFile($selectorFile);
$theBookMakerDownloader->generateOutputXML($outputFile);

my $isOutputXmlFileExist = (-e $outputFile);
my ($got, $expected, $testname) = ($isOutputXmlFileExist, 1, "Output Xml File Exist: $outputFile");
ok($got eq $expected, $testname);