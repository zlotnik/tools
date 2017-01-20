#!/usr/bin/perl -w
use POSIX ":sys_wait_h";
use LWP::Simple;
use 5.010;
use Data::Dumper;
push @INC, "/c/Perl64/site/";
#use XML::Simple;
#use XML::LibXML::Simple;
use XML::LibXML;
#use /c/Perl64/site/lib/XML/
#use HTML::TableParser;


#($#ARGV +1) == 1 or die 'usage surebet.pl inputFile';

#my $inputFileName = $ARGV[0];

#open(INPUT, "<", $inputFileName) or die "Unable to open file"; 
###############SUB PROTOTYPES############################################
sub getsLinksForAllEventsFromSubCategory($$);
sub getTableWithEvents($);
sub getLinksToEventFromTable($);
sub findTheBestOddInLinkToEvent($);
sub generateOutputXML($);
sub downloadRawDataOfChoosenOfert(\%);
sub generateReportLine($);
sub getRawDataOfEvent($);
sub findBestOdds($);
sub calculateProfit(\%);
sub checkNumberOfBookmaker($);
sub convertRawDownloadedDataToHash($);
sub createEventListXML($$);
sub getAllSubCategories($$);
#################DICTIONARY##############################################
#choosen bookmaker offer - choosen part of bookmaker offer by appling an offert selector eg. all German, soccer, matches  



#################TODO####################################################
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

############################MAIN##############################################
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


my $pathToXmlSelector = $ARGV[0];
$pathToXmlSelector = "input/spainLaLigaSelector.xml";
generateOutputXML($pathToXmlSelector);



####################SUB DEFINITIONS############################################
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


sub generateOutputXML($)
{
	my @offersChoosenToDownload = @{$_[0]};
	
	my $pathToXmlSelector = shift;
	my $xmlParser = XML::LibXML->new; 
	my $doc = $xmlParser->parse_file($pathToXmlSelector);
	my $xpath = "/dataChoosenToDownload";
	$xpath = "/note/dataChoosenToDownload";
	$xpath = "";
	
	die "copy here xml to temporary file";
	createEventListXML($doc, $xpath);
	
	#foreach(@offersChoosenToDownload)
	{
	#	%anOfferChoosenToDownload = %{$_};	
		
	#	my $downloadedDataRawText = downloadRawDataOfChoosenOfert(%anOfferChoosenToDownload);
	#	my %hashWithAnDownloadOffer = connvertRawDownloadedDataToHash($downloadedDataRawText);
		
	}
}


sub createEventListXML($$)
{
	my $xmlDoc = $_[0];
	my $xpath = $_[1];
	#$xpath = '';
	foreach ($xmlDoc->childNodes()) 
	{
		my $node = $_;				
		if($node->nodeName !~ /#text/)
		{
			#print "XPATH $xpath\n";
			my $nodeName = $node->nodeName;
			#$xpath .= "/". $node->nodeName ;
			#print "BEFORE $xpath\n"; 
			
			if($node->hasChildNodes() )
			{
				my $childNode = $_;
				createEventListXML($node,"$xpath/$nodeName");
			}
			else
			{
				print "END OF RECURENCE $xpath/$nodeName\n";
				updateXmlNodeWithDataFromBookmaer($node);
				#$xpath .= "/$nodeName";
				#createEventListXML($xmlDoc,$xpath);
			}
		}
	
		#print "END OF RECURENCE 2 $xpath\n"
	}
			

};

sub updateXmlNodeWithDataFromBookmaer($$);
{
	my $node = $_[0];
	my $subPath = $_[1];
	die "finished here";
		
	for(getAllSubCategories($node,$subPath))
	{
		my $subCategoryName = $_;
		getSubAllSubCategories($node,$subPath+$subCategoryName);
	}
	#open temporary xml 
	#save add new node basis on xpath to temporary file
	#close file
	

}

sub getAllSubCategories($$)
{

	#IN:  "soccer/Portugal"
	#Out arra: ["LaLiga","LaLiga", "and so on"];
	die;

}









sub convertRawDownloadedDataToHash($)
{
	my $downloadedDataRawText = $_[0];
	print $downloadedDataRawText;
	die;


};



sub downloadRawDataOfChoosenOfert(\%)
{
	my %category = %{$_[0]};
	my $nation = $category{'nation'};
	my $league = $category{'league'};
	my @allLinksToEventInSubCategory = getsLinksForAllEventsFromSubCategory($nation, $league);
	
	foreach(@allLinksToEventInSubCategory)
	{

		my $linkToEvent = $_;
		my $rowDataForReport = getRawDataOfEvent($linkToEvent);
		print "### $rowDataForReport  ###";
		die;
	}
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
		my $numberOfAttempts = 3;
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
		if($lineWithData =~ /a href="(.*?)" class="in-match"/)
		{
			my $linkToEvent = "http://www.betexplorer.com$1";
			#if(checkNumberOfBookmaker($lineWithData) > 0) #doesn't used anymore propably it was used to check how many bookmaker link contains
			#{
			push @linksToEvents, "http://www.betexplorer.com$1";			
			#	print STDOUT "after link==$1 \n";
			#}
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
	my $htmlPageWithEvents = $_[0];
	$htmlPageWithEvents =~ /(<table class=\"table\-main)([\s\S]*?)(table>)/m;
	
	(defined $1 and defined $1 and defined $1) or die "BetExplorerParser: Isn't possible to parse the table with events "; 
	return $1.$2.$3;
}







