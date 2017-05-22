package MockedDataDownloader;
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
	my $modelRawDataPath = "input/data/examples/modelRawData";
	my $modelRawDataFileHandler;
	
	open ($modelRawDataFileHandler, "<" , $modelRawDataPath) or die $!;
	
	{
		$/ = undef;
		my $rawData = <$modelRawDataFileHandler>;
		close $modelRawDataFileHandler or die;
		return $rawData;
	}
	
	
}
;

1;