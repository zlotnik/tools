package MockedDataDownloader
use strict;
use warnings;

use DataDownloader;

our @EXPORT = qw(getRawDataOfEvent);
our @ISA = qw(DataDownloader);

sub getRawDataOfEvent($);
sub new();


sub new()
{		
	my $class = shift;
	
	my $self = $class->SUPER::new();
	return $self; 
}

sub getRawDataOfEvent($)
{
	my $modelRawDataPath = "input/data/modelRawData";

	open ($modelRawDataFileHandle, "<" , $modelRawDataPath) or die
	
	{
		$/ = undef;
		return $modelRawDataFileHandle;
	}
	close $modelRawDataFileHandle or die;
	
	
}
;

1;