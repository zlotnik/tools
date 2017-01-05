#!/usr/bin/perl -w
use POSIX ":sys_wait_h";
use LWP::Simple;
use 5.010;
#use HTML::TableParser;

#($#ARGV +1) == 1 or die 'usage surebet.pl inputFile';

#my $inputFileName = $ARGV[0];

#open(INPUT, "<", $inputFileName) or die "Unable to open file"; 
sub getsLinksForAllEventsFromSubCategory($$);
sub getTableWithEvents($);
sub getLinksToEventFromTable($);
sub findTheBestOddInLinkToEvent($);
sub generateReport(\@);
sub generateReportForSubCategory(\%);
sub generateReportLine($);
sub getRawDataOfEvent($);
sub findBestOdds($);
sub calculateProfit(\%);
sub checkNumberOfBookmaker($);

#TODO
#zeby nie pobieral danych zakladu jezeli nie ma zadnego()-96 na outpucie
#dodac statystyki
#filter buchmacher z pliku
#add show usage
#add parse input file


#getsLinksForAllEventsFromSubCategory('germany','bundesliga');


#open OUTPUT, '>', "output.txt" or die "Can't create filehandle: $!";
#select OUTPUT; 
#$| = 1;  # make unbuffered

#findTheBestOddInLinkToEvent('http://www.betexplorer.com/soccer/germany/bundesliga/mainz-schalke/GEcPMEM6/#1x2');


my @groupA = ( {nation=> 'germany', league=>'bundesliga'}
			   ,{nation=> 'belgium', league=>'jupiler-league'});

my @groupB = 
					(
						{nation=> 'argentina', league=>'primera-division'}
						,{nation=> 'brazil', league=>'campeonato-paulista'}
						,{nation=> 'brazil', league=>'campeonato-carioca'}
						,{nation=> 'brazil', league=>'campeonato-gaucho'}
						,{nation=> 'chile', league=>'primera-division'}
					);			   
			   

my @groupC = 
						(
							{nation=> 'austria', league=>'tipico-bundesliga'},
							,{nation=> 'bulgaria', league=>'a-pfg'}
							,{nation=> 'croatia', league=>'1-hnl'}
							,{nation=> 'czech-republic', league=>'synot-liga'}
							,{nation=> 'denmark', league=>'superliga'}
							,{nation=> 'england', league=>'premier-league'}
						);


my @groupD = 
						(
							{nation=> 'finland', league=>'veikkausliiga'}
							,{nation=> 'france', league=>'ligue-1'}
							,{nation=> 'france', league=>'ligue-2'}
							,{nation=> 'hungary', league=>'otp-bank-liga'}
							,{nation=> 'india', league=>'i-league'}
							,{nation=> 'iran', league=>'persian-gulf-pro-league'}
							,{nation=> 'italy', league=>'serie-a'}
							,{nation=> 'italy', league=>'serie-b'}
							,{nation=> 'lebanon', league=>'premier-league'}
							,{nation=> 'mexico', league=>'primera-division'}
							,{nation=> 'mexico', league=>'liga-de-ascenso'}
							,{nation=> 'netherlands', league=>'eredivisie'}
							,{nation=> 'netherlands', league=>'eerste-divisie'}
							,{nation=> 'new-zealand', league=>'football-championship'}
							,{nation=> 'northern-ireland', league=>'nifl-premiership'}
							,{nation=> 'norway', league=>'tippeligaen'}
							,{nation=> 'norway', league=>'obos-ligaen'}
							,{nation=> 'poland', league=>'ekstraklasa'}
			
						);

my @groupE	=
			(
			{nation=> 'portugal', league=>'primeira-liga'}
			,{nation=> 'portugal', league=>'segunda-liga'}
			,{nation=> 'romania', league=>'liga-1'}
			,{nation=> 'russia', league=>'fnl-cup'}
			,{nation=> 'russia', league=>'premier-league'}
			,{nation=> 'scotland', league=>'premiership'}
			,{nation=> 'scotland', league=>'championship'}
			,{nation=> 'serbia', league=>'super-liga'}
			,{nation=> 'spain', league=>'segunda-division'}
			,{nation=> 'spain', league=>'primera-division'}
			);
			
my @groupF	= (
					{nation=> 'sweden', league=>'allsvenskan'}
					,{nation=> 'sweden', league=>'superettan'}
					,{nation=> 'switzerland', league=>'super-league'}
					,{nation=> 'switzerland', league=>'challenge-league'}
					,{nation=> 'turkey', league=>'super-lig'}
					,{nation=> 'united-arab-emirates', league=>'uae-league'}
					,{nation=> 'uruguay', league=>'primera-division'}
					,{nation=> 'wales', league=>'premier-league'}
					,{nation=> 'wales', league=>'division-1'}
			  );
			
			

			
my @smallGroup = ( {nation=> 'germany', league=>'bundesliga'});

#generateReport(@groupA);
#generateReport(@groupB);
#generateReport(@groupC);
#generateReport(@groupE);
#generateReport(@groupF);


generateReport(@smallGroup);

sub findTheBestOddInLinkToEvent($)
{
	open OUTPUT, '>', "output.html" or die "Can't create filehandle: $!";
	select OUTPUT; 
	my $linkToEvent = $_[0];
	my $content  = get($linkToEvent) or die "unable to get $linkToEvent \n";
	my $best1odd;
	
	#$content =~ /td class="course best-betrate arrow-up" data-odd=(.)/m;
	#$content =~ /course best-betra(te)/m;
	print $content;
}


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

	
	
	#select REPORT;
	foreach(@allLinksToEventInSubCategory)
	{
		#$| = 1;
		my $linkToEvent = $_;
		my $reportLine = generateReportLine($linkToEvent);
		if($reportLine)
		{
			open (REPORT,">>",'report.txt') or die ;
			print REPORT $reportLine;
			close REPORT or die;		
		}
		
	
	}
	
	#select STDOUT; 
	
	
};

sub generateReportLine($)
{	
	my $linkToEvent = $_[0];
	my $resultLine = '';
	my $rowDataForReport = getRawDataOfEvent($linkToEvent);
	
	if($rowDataForReport)
	{
		my %bestOdds  = findBestOdds($rowDataForReport);	
		my $profit = calculateProfit(%bestOdds);
			
		$resultLine = $linkToEvent . ' ' . $bestOdds{'1'} .' ' . $bestOdds{'X'} .' ' . $bestOdds{'2'}  .' ' . $profit."\n"; 	
		print STDOUT $resultLine; 	
		if($profit > 0)
		{
			return $resultLine;
		}
		else
		{
			return '';
		}
	}
	return '';
}

sub calculateProfit(\%)
{
	%bestOdds = %{$_[0]};

	my $best1  = $bestOdds{'1'};
	my $bestX  = $bestOdds{'X'};
	my $best2  = $bestOdds{'2'};
	
	$profit1 = $best1 * 100;  
	$betX  = $profit1 / $bestX;  
	$bet2  = $profit1 / $best2;
	
	my $profit  =  ($best1 * 100) - (100 + $betX + $bet2) ;
	my $profitPercent = ($profit / (100 + $betX + $bet2)) * 100;
	return $profitPercent;
}
	


sub findBestOdds($)
{
	my $dataWithBets  = $_[0];
	#print $dataWithBets; die;
	my %bestOdds; 
	$bestOdds{'1'}  = 0.1;
	$bestOdds{'X'}  = 0.1;
	$bestOdds{'2'}  = 0.1;
	
	foreach(split("\n",$dataWithBets))
	{
		$lineWithBetData = $_;
		$lineWithBetData =~ s/[^\w\.]/#/g;
		
		if($lineWithBetData =~/(\w+)#{0,2}(\d?\d\.\d\d)(\d?\d\.\d\d)(\d?\d\.\d\d)/ )
		{
			if ($1 eq 'Interwetten')
			{
				#print STDOUT "ignoring== $lineWithBetData\n";
				next;			
			}
			if($2 gt $bestOdds{'1'})
			{
				$bestOdds{'1'}  = $2;
			}
			if($3 gt $bestOdds{'X'})
			{
				$bestOdds{'X'}  = $3;
			}
			if($4 gt $bestOdds{'2'})
			{
				$bestOdds{'2'}  = $4;
			}
		}
	}
	#die;
	return %bestOdds;

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

	
	return getLinksToEventFromTable(getTableWithEvents($content))
	
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
				push @linksToEvents, "http://www.betexplorer.com$1";			
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
	
	(defined $1 and defined $1 and defined $1) or die "BetExplorerParser: Isn't possible to parse the table with events "; 
	
#	$htmlPageWithEvents =~ /(table id=\")(*)\"/;
	return $1.$2.$3;
}







