package WWWBookmakerPage;
use strict;
use warnings;
use FindBin;
use Class::Interface;
use LWP::Simple ();
use File::Basename ();
use File::Spec ();
use POSIX ":sys_wait_h";


our @ISA = qw(SourceOfBookmakerPage);

our @EXPORT = qw(getRawDataOfEvent new);


sub getRawDataOfEvent($);
sub new();
sub get($);
sub createJavaScriptForDownload($);
sub createRawDataFileOfEvent($);

sub new()
{		
	my $class = shift;
	

	my $self = bless {}, $class;
	return $self; 
}

sub getRawDataOfEvent($)
{
	
	my ($self, $linkToEvent) = @_;
	
	my $modelRawDataPath = "rawdataevent.txt";
	
	my $isUploadingOfDataSuccessfull = createRawDataFileOfEvent($linkToEvent); 
	
	if( $isUploadingOfDataSuccessfull )
	{
		
		open (my $rawDataFileHandler, "<" , $modelRawDataPath) or die $!;
		
		
		{
			$/ = undef;
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


sub createRawDataFileOfEvent($)
{
	my ($linkToEvent) = @_;
	createJavaScriptForDownload($linkToEvent);
		
	my $res = 0;
	my $retryIdx = 0; 
	my $toReturn = '';
	
	my $pid = fork();
	if(not $pid)
	{
		my $toReturnInChild = `phantomjs.exe download1x2Data.js`;
		open RAWDATA , ">", 'rawdataevent.txt' or die; #todo parameter instead of hardcoded name
		print RAWDATA $toReturnInChild;
		close RAWDATA or die;
		#print STDOUT "before exit\n";		
		exit(1);
	}
	else
	{
		my $numberOfAttempts = 6;
		while($res == 0 and $retryIdx++ < $numberOfAttempts)
		{
			sleep(26);
			$res = waitpid($pid, WNOHANG);
			print STDOUT "no answer from $linkToEvent  attemp no $retryIdx/$numberOfAttempts\n";					
		}
	}
	
	
	if($res == 0)
	{
		kill 9, $pid;
		print STDOUT "UNABLE TO FETCH $linkToEvent PID $pid RESPONSE $res\n";
		return;
	}
	else 
	{
		#print STDOUT "process $pid finished\n";
		open(my $fh, '<', 'rawdataevent.txt') or die "cannot open file rawdataevent.txt";
		{
			local $/;
			$toReturn = <$fh>;;
		}
		close $fh or die;
	
	}
	
	
	
	return $toReturn;
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
