#!/usr/bin/perl
use XML::LibXML;
use strict;

my $filename = "example1.xml";
my $outFilename = "example1_out.xml";

my $parser = XML::LibXML->new();
my $critic_details_document = $parser->parse_file("$filename") or die;

my $resultNode  = $critic_details_document->findnodes("book_reviewers/results")->[0];

my $node = XML::LibXML::Element->new("reviewer");

$resultNode->addChild($node);

#print $critic_details_document;

#$critic_details_document

my $state = $critic_details_document->toFile($outFilename);