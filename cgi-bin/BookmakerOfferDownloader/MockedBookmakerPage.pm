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
	my $toReturn;
	$pathToDownload =~ s|http://www.betexplorer.com||;
	$pathToMockedFile = 'input/mockedWWW/' . $pathToDownload . 'index.html';
	

	open my $mockedFilefh, "<", $pathToMockedFile or die "Unable to open mocked file ${pathToMockedFile}";
	{
		local $/;
		$toReturn = <$mockedFilefh>;

	
	}
	close $mockedFilefh or die;
	return $toReturn;

};


sub getRawDataOfEvent($)
{
	my ($self, $linkToEvent) = @_;
	
	$linkToEvent =~ m|(http://www.betexplorer.com/)(.*)|; 
	
	my $relativePathToEvent = $2;
	
	my $modelRawDataPath = 'input/mockedWWW/' . $relativePathToEvent . 'rawdataevent.txt';  
	
	my $modelRawDataFileHandler;
	
	open ($modelRawDataFileHandler, "<" , $modelRawDataPath) or die "Can't  open rawdata file for mock from path ${modelRawDataPath}";
	
	{
		$/ = undef;
		my $rawData = <$modelRawDataFileHandler>;
		close $modelRawDataFileHandler or die;
		return $rawData;
	}	
}
;

1;
