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
use Digest::MD5 qw(md5 md5_hex md5_base64);


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
	my $javaScriptToRun = createJavaScriptForDownload($linkToEvent);
		
	my $res = 0;
	my $retryIdx = 0; 
	my $toReturn = ''; #todo clean up here
	my $limitOfTrying = 4;
	
	my $rawDataFileName = ''; 
	while($res == 0 and $retryIdx++ < $limitOfTrying)
	{
	
		my $commandDownloadingRawData = "./phantomjs.elf $javaScriptToRun";
		my $rawData = `$commandDownloadingRawData`;
		my $isDownloadingSuccesfull = 1;
		if ($rawData =~ /Unable to access network/ )
		{
			$isDownloadingSuccesfull = 0;
		}
		unless ($rawData =~ /ookmaker/)
		{
			$isDownloadingSuccesfull = 0;	
		}	
	

		if($isDownloadingSuccesfull)
		{
			my $randomPostfix = new String::Random;
			$randomPostfix =  $randomPostfix->randregex('\w\w\w\w\w\w');
			$rawDataFileName = "tmp/". 'rawdataevent_' . $randomPostfix . '.txt'; #todo rawdata should have the same postfix as javascript used to download
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
	
	my $md5sum = md5_hex($linkToReplace);
	my $resultFile = "tmp/download1x2Data_${md5sum}_tmp.js";
	
	open( TEMPLATE  , "<" , 'download1x2Data_template.js') or die;
	
	open( JAVASCRIPT  , ">" , $resultFile) or die "Can't open $resultFile\n";
	
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
	return $resultFile;

}

sub get($)
{
	my ($self, $linkToGet) = @_;

	#my $result = LWP::Simple::get($linkToGet) or die "unable to get $linkToGet $? $0";  
	my $result = `curl -A "Mozilla/5.0" $linkToGet`;
	return $result;
};



1;
