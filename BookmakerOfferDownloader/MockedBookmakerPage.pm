package MockedBookmakerPage;
use strict;
use warnings;
use Class::Interface;
use SourceOfBookmakerPage;

our @ISA = qw(SourceOfBookmakerPage);
our @EXPORT = qw(getRawDataOfEvent new);

sub getRawDataOfEvent($);
sub new();
sub get($);

sub new()
{		
	my $class = shift;
	
	my $self = bless {}, $class;
	return $self; 
}


sub get($)
{
	my ($class, $pathToDownload) = @_;
	my $pathToMockedFile;
	$pathToMockedFile = 'input/mockedWWW/' . $pathToDownload . 'index.html';
	

	open my $mockedFilefh, "<", $pathToDownload or die "Unable to open mocked file ${pathToDownload}";
	die 'to be continued!!!' ;
	die "implementation missing";

};


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
