package Xpath;
#
#===============================================================================
#
#              FILE: Xpath.pm
#
#  RESPONSIBILITIES: 
#
#             FILES: ---
#              BUGS: ---
#             NOTES: ---
#            AUTHOR: WOJCIECH MARZEC (), marzec.wojciech@gmail.com
#      ORGANIZATION: 
#           CREATED: 09/03/2020 12:28:25 PM
#===============================================================================
use strict;
use warnings;
 
use Exporter;
use parent qw( Exporter );

sub trimBeginning($$);


sub trimBeginning($$)
{
	my ($xpathToDelete ,$wholeXpath ) = @_;
	
	$wholeXpath =~ s|^${xpathToDelete}||;
	return $wholeXpath;
};

1;
