use strict;
use warnings;
use HTML_1X2_Events_Parser;

my $filePath_WithEventHTML = "exampleOfOut.html";
my $eventParser = HTML_1X2_Events_Parser->new();

print $eventParser->parse($filePath_WithEventHTML);