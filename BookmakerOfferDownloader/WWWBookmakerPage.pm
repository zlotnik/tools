package WWWBookmakerPage;
use strict;
use warnings;
use FindBin;
use Class::Interface;
use LWP::Simple ();
use File::Basename ();
use File::Spec ();
use String::Random;
use POSIX ":sys_wait_h";


our @ISA = qw(SourceOfBookmakerPage);

our @EXPORT = qw(getRawDataOfEvent new);


sub getRawDataOfEvent($);
sub new();
sub get($);
sub createJavaScriptForDownload($);
sub createRawDataFileOfEvent($);


#todo change module name to RealWWWBookmakerPage
sub new()
{		
	my $class = shift;
	

	my $self = bless {}, $class;
	return $self; 
}

sub getRawDataOfEvent($)
{
	
	my ($self, $linkToEvent) = @_;
	
	
	my $modelRawDataPath = createRawDataFileOfEvent($linkToEvent); 
	
	if( $modelRawDataPath )
	{
		
		open (my $rawDataFileHandler, "<" , $modelRawDataPath) or die "error during reading from $modelRawDataPath";
		
		
		{
			local $/ = undef;
			my $rawData = <$rawDataFileHandler>;
			close $rawDataFileHandler or die; #todo all die should have message
			return $rawData;
		}
	}
	else
	{
		return '';
	}
}




#WWWBookmakerPage::createRawDataFileOfEvent
sub createRawDataFileOfEvent($)
{
	my ($linkToEvent) = @_;
	createJavaScriptForDownload($linkToEvent);
		
	my $res = 0;
	my $retryIdx = 0; 
	my $toReturn = ''; #todo clean up here
	my $limitOfTrying = 4;
	
	my $rawDataFileName = ''; 
	while($res == 0 and $retryIdx++ < $limitOfTrying)
	{
	
		my $rawData = `phantomjs.exe download1x2Data.js`;
		my $isDownloadingSuccesfull = 1;
		if ($rawData =~ /Unable to access network/)
		{
			$isDownloadingSuccesfull = 0;
		}
		

		if($isDownloadingSuccesfull)
		{
			my $randomPostfix = new String::Random;
			$randomPostfix =  $randomPostfix->randregex('\w\w\w\w\w\w');
			$rawDataFileName = "tmp/". 'rawdataevent_' . $randomPostfix . '.txt';
			open RAWDATA , ">", $rawDataFileName or die "Error while writing to $rawDataFileName\n"; 
			print RAWDATA $rawData;
			close RAWDATA or die;
			return $rawDataFileName;
		}
				
	}
	return $rawDataFileName;
	
}


sub createJavaScriptForDownload($)
{
	my $linkToReplace = $_[0];
	
	open( TEMPLATE  , "<" , 'download1x2Data_template.js') or die;
	
	open( JAVASCRIPT  , ">" , 'download1x2Data.js') or die;
	
	while(<TEMPLATE>)
	{
		my $line = $_;
		if ($line =~ /(.*)(__URL_TO_FILL__)(.*)/)
		{
			print JAVASCRIPT $1.$linkToReplace.$3."\n"; 
		}
		else
		{
			print JAVASCRIPT $line;
		}
	}
	close(JAVASCRIPT)or die;
	close(TEMPLATE)or die;

}

sub get($)
{
	my ($self, $linkToGet) = @_;

	LWP::Simple::get($linkToGet) or die "unable to get $linkToGet";  
};



1;
