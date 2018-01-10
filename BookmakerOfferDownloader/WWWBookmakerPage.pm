package WWWBookmakerPage;
use strict;
use warnings;
use FindBin;
use Class::Interface;
use LWP::Simple ();
use File::Basename ();
use File::Spec ();


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

sub getRawDataOfEvent($)
{
	
	my $modelRawDataPath = "input/data/examples/modelRawData";
	my $modelRawDataFileHandler;
	
	#chdir 'BookmakerOfferDownloader';	#very dirty but i don't know how it works 
	
	open ($modelRawDataFileHandler, "<" , $modelRawDataPath) or die $!;
	
	{
		$/ = undef;
		my $rawData = <$modelRawDataFileHandler>;
		close $modelRawDataFileHandler or die;
		return $rawData;
	}
	
	#chdir '..'; #very dirty but i don't know how it works
}

sub get($)
{
	my ($self, $linkToGet) = @_;

	LWP::Simple::get($linkToGet) or die "unable to get $linkToGet";  
};



1;
