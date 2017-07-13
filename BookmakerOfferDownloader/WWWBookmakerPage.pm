package WWWBookmakerPage;
use strict;
use warnings;
use Class::Interface;
use LWP::Simple;

our @ISA = qw(SourceOfBookmakerPage);

our @EXPORT = qw(getRawDataOfEvent new);


sub getRawDataOfEvent($);
sub new();
sub get($);

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

sub get($)
{
	my ($self, $linkToGet) = @_;

	get($linkToGet) or die "unable to get $linkToGet";  
};


1;