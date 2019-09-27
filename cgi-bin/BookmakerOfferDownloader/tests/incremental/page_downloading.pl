use LWP::Simple;
use strict;
use warnings;

my $page_to_download = 'http://www.betexplorer.com//soccer/England/national-league-south/';

my $result = LWP::Simple::get('$page_to_download');  
my $result1 = LWP::Simple::get('http://www.interia.pl');  


