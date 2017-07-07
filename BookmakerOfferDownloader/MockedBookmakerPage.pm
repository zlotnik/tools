package MockedBookmakerPage;
use strict;
use warnings;
use Class::Interface;
&implements( 'BookmakerPageIf' );

our @EXPORT = qw(getRawDataOfEvent new);

sub getRawDataOfEvent($);
sub new();


sub new()
{		
	my $class = shift;
	
	my $self = bless {}, $class;
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