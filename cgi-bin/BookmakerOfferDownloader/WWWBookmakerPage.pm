package WWWBookmakerPage;
use strict;
use warnings;
use Class::Interface;
use LWP::Simple ();
use File::Spec ();
use String::Random;
use File::Basename;
use Digest::MD5 qw(md5_hex);

use parent qw(SourceOfBookmakerPage);
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


sub downloadSuccesfull($)
{
        my ( $rawData ) = @_;

        
        if ($rawData =~ /div class/)
        {
                return 1;
        }
        else
        {
                return 0;
        }

}


sub createRawDataFileOfEvent($)
{
	my ($linkToEvent) = @_;
	my $javaScriptToRun = createJavaScriptForDownload($linkToEvent);
        my $moduleDirPath = dirname( $INC{"WWWBookmakerPage.pm"} );

	my $commandDownloadingRawData = "${moduleDirPath}/phantomjs.elf $javaScriptToRun";
	my $rawData = `$commandDownloadingRawData`;
	my $isDownloadSuccesfull = downloadSuccesfull($rawData);
 
        my $tryTime = 3;
        while(!$isDownloadSuccesfull and $tryTime <= 12  )
        {
                print "try another time for $linkToEvent\n";
                sleep($tryTime);
                $rawData = `$commandDownloadingRawData`;
	        $isDownloadSuccesfull = downloadSuccesfull($rawData);
                $tryTime = $tryTime *2;
        }

        #print $rawData;	
	my $randomPostfix = new String::Random;
	$randomPostfix =  $randomPostfix->randregex('\w\w\w\w\w\w');
	my $rawDataFileName = "tmp/". 'rawdataevent_' . $randomPostfix . '.txt';


	open RAWDATA , ">", $rawDataFileName or die "Error while writing to $rawDataFileName\n"; 
	print RAWDATA $rawData;
	close RAWDATA or die;
			
	return $rawDataFileName;
	
}


sub createJavaScriptForDownload($)
{
	my $linkToReplace = $_[0];
	
	my $md5sum = md5_hex($linkToReplace);
	my $resultFile = "tmp/download1x2Data_${md5sum}_tmp.js";
	
        my $moduleDirPath = dirname( $INC{"WWWBookmakerPage.pm"} );


	open( TEMPLATE  , "<" , "${moduleDirPath}/download1x2Data_template.js") or die $!;
	
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
	print "curl command: curl -A \"Mozilla/5.0\" $linkToGet\n";
	#my $result = LWP::Simple::get($linkToGet) or die "unable to get $linkToGet $? $0";  
	my $result = `curl -A "Mozilla/5.0" $linkToGet`;
	return $result;
};



1;
