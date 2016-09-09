#!/usr/bin/perl
use strict;
use LWP::UserAgent;

my $url = "http://en.wikipedia.org/wiki/Stack_overflow";
$url = 'https://www.marathonsportsbook.com/pl/betting/Football/';
$url = 'http://www.pinnaclesports.com/pl/odds/match/soccer/gibraltar/gibraltar---premier-division';

my $ua = LWP::UserAgent->new();
$ua->agent("Mozilla/8.0"); # pretend we are very capable browser;
my $res = $ua->get($url);

open OUTPUT, '>', "Pinnacle.html" or die "Can't create filehandle: $!";

print OUTPUT $res->content;


close OUTPUT or die;