#!/usr/bin/perl
use strict;
use warnings;
use BookMakerDownloader;

#################BACKLOG        #######################################################
# the one BookMakerDownloader which will be filled with other classes basis on the selector file
#
#################DICTIONARY     #######################################################
#the selector file - an xml file used to specify what kind of data data will be dowloaded eg: discipline, country, league, time, bookmaker 
#################SUB PROTOTYPES #######################################################

#################MAIN           #######################################################

my $selectorFile = 'input/parameters/ekstraklasaSelector.xml';
$theBookMakerDownloader =  betExplorerDownloader->new();  
$theBookMakerDownloader->loadSelectorFile($selectorFile);

#################SUB DEFINITIONS #######################################################