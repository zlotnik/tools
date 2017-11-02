#!/usr/bin/perl
use Surebets;

	
my $filePathToXmlWith = shift;
my $xmlResultFile = "surebet.xml"


my $surebets = Surebets->new();

my $surebets->loadEvents($filePathToXmlWith);

$surebets->find();
$surebets->dumpToXml();