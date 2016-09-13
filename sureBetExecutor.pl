#!/usr/bin/perl
use Surebets;






#out xml 
	
my $filePathToXmlWith = shift;
my $xmlResultFile = "surebet.xml"


my $surebets = Surebets->new();


my $surebets->loadEvents($filePathToXmlWith);

$surebets->find();
$surebets->dumpToXml()



