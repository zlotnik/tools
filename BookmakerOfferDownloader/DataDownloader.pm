package DataDownloader
use strict;
use warnings;

our @EXPORT = qw(getRawDataOfEvent);


sub getRawDataOfEvent($);
sub new();


sub new()
{		
	my $class = shift;
	my $self = bless {}, $class;
	return $self; 
}











1;