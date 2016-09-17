#!/usr/bin/perl -w
use POSIX ":sys_wait_h";
use LWP::Simple;
use 5.010;


############ SUB PROTOTYPES ###################################

sub getsLinksForAllEventsFromSubCategory($$);
sub getTableWithEvents($);
sub getLinksToEventFromTable($);

sub generateReport(\@);
sub generateReportForSubCategory(\%);
sub generateReportLine($);
sub getRawDataOfEvent($);
sub checkNumberOfBookmaker($);


############# MAIN ############################################



my @groupA = ( {nation=> 'germany', league=>'bundesliga'}
	      ,{nation=> 'belgium', league=>'jupiler-league'});


generateReport(@groupA);


############# SUBS DEFINITIONS ################################



sub generateReport(\@)
{
	my @groupToAnalize = @{$_[0]};

	foreach(@groupToAnalize)
	{
		%categoryToAnalize = %{$_};	
		generateReportForSubCategory(%categoryToAnalize);
		
	}
}

sub generateReportForSubCategory(\%)
{
	my %category = %{$_[0]};
	my $nation = $category{'nation'};
	my $league = $category{'league'};
	my @allLinksToEventInSubCategory = getsLinksForAllEventsFromSubCategory($nation, $league);
		
	foreach(@allLinksToEventInSubCategory)
	{
		my $linkToEvent = $_;
		my $rowDataForReport = getRawDataOfEvent($linkToEvent);
		print $rowDataForReport;
	}
	
};



sub getRawDataOfEvent($)
{
	my $linkToEvent = $_[0];
	createJavaScriptForDownload($linkToEvent);
		
	my $res = 0;
	my $retryIdx = 0; 
	my $toReturn = '';
	
	my $pid = fork();
	if(not $pid)
	{
		my $toReturnInChild = `phantomjs.exe download1x2Data.js`;
		open RAWDATA , ">", 'rawdataevent.txt' or die;
		print RAWDATA $toReturnInChild;
		close RAWDATA or die;
		#print STDOUT "before exit\n";		
		exit(1);
	}
	else
	{
		while($res == 0 and $retryIdx++ < 3)
		{
			sleep(26);
			$res = waitpid($pid, WNOHANG);
			print STDOUT "no answer from $linkToEvent  attemp no $retryIdx\n";					
		}
	}
	
	
	if($res == 0)
	{
		kill 9, $pid;
		print STDOUT "UNABLE TO FETCH $linkToEvent PID $pid RESPONSE $res\n";
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



sub getsLinksForAllEventsFromSubCategory($$)
{
	my $categoryName = $_[0];
	my $subCategoryName = $_[1];
	my $link = 'http://www.betexplorer.com/soccer/' .  $categoryName .'/'. $subCategoryName;
	
	my $content  = get($link) or die "unable to get $link \n";
        # print $content;
	
	return getLinksToEventFromTable(getTableWithEvents($content));
	die "bug: getRelativeLinksToEventFromTable after go through array and ad prefix address "; 

	#print $content;
};

sub getLinksToEventFromTable($)
{
	my $tableWithEvents = $_[0];
	#open OUTPUT, '>', "output.txt" or die "Can't create filehandle: $!";
	#select OUTPUT;
	my @linksToEvents;
	foreach (split("\n",$tableWithEvents))
	{
		my $lineWithData = $_;
		if($lineWithData =~ /a href="(.*?)"/)
		{
			my $linkToEvent = $1;
			if(checkNumberOfBookmaker($lineWithData) > 0)
			{
				print $lineWithData;die;
				push @linksToEvents, "http://www.betexplorer.com$1";die "bug return only $1";			
			#	print STDOUT "after link==$1 \n";
			}
			#print STDOUT 'no of bookmakers ' . checkNumberOfBookmaker($lineWithData) ."\n";
			
		} 
	}
	return @linksToEvents;
}

sub eventInLinkAlreadyPlayed($)
{

	my $linkToEvent = $_[0];

}

sub checkNumberOfBookmaker($)
{
	my $rowToAnalize = $_[0];
	
	if($rowToAnalize =~ /td class="bs">(\d?\d)/)
	{
		return $1;
	}

	return 0;

}



sub getTableWithEvents($)
{
	#open OUTPUT, '>', "output.txt" or die "Can't create filehandle: $!";
	#select OUTPUT;
	my $htmlPageWithEvents = $_[0];
	$htmlPageWithEvents =~ /(<table class=\"result-table)([\s\S]*?)(table>)/m;
#	$htmlPageWithEvents =~ /(table id=\")(*)\"/;
	return $1.$2.$3;
}







