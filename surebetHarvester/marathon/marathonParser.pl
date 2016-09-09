#!/usr/bin/perl -w


########### BACKLOG HIGH LEVEL #############################
#1.fetch all soccer event with their stake for UO2.5
#2.Store the results in hash
#	$allEvents{'soccer'}{'poland'}{'extraklasa'}{'Legia'}{'Wisla'}{'Marathon'}{'UO2.5'}{U2.5}
#	$allEvents{'soccer'}{'poland'}{'extraklasa'}{'Legia'}{'Wisla'}{'Marathon'}{'UO2.5'}{O2.5}
#





######### BACKLOG LOW LEVEL ###########################################
sub fetchAllDataFromMainMarathonPage();
sub getListOfCategoriesFromMainMarathonPage();

######### PROTOTYPES ##################################################
sub fetchAllEventsDataFromHtml($);
sub getContentFromPath($);
sub fetchAll_tbody($);
sub getSpecificEventDataFromHtml($$);
sub fetchRegularExpressionForDataHidenInTbody($);


######### MAIN ########################################################
my @listOfEvents; 

fetchAllEventsDataFromHtml('downloadedMarathon.html');




######### PROCEDURE ##################################################
sub fetchAllDataFromMainMarathonPage
{
	my @categories = getListOfCategoriesFromMainMarathonPage();	
	for(@categories)
	{
		my $categoryName = $_;
		#if ($categoryName eq 'Football')
		my $temporaryCategoryName = 'Hurling';
		if ($categoryName eq '$temporaryCategoryName')
		{
			my @region = getListOfRegion_Competition();
		}
	}

}

sub getContentFromPath($)
{
  my $pathToHtmlFileWithEvents = $_[0];
  my $content;
  {
    local $/;
    open HTML_FILE_WITH_EVENTS , '<' , $pathToHtmlFileWithEvents or die ;
    
    #open my $fh, '<', 'tst.txt' or die "can't open $file: $!";
    $content = <HTML_FILE_WITH_EVENTS>;    
    
  }
  
  return $content;

};

sub fetchAll_tbody($)
{
	$htmlContentWithEvents = $_[0];
	my @all_tbody;
	#open OUT_TST, '>', 'tmp_out.log' or die;
	#print OUT_TST $htmlContentWithEvents or die;
	#close OUT_TST or die;
	
	while ($htmlContentWithEvents =~ /(<tbody[\w\W]{1,}?\/tbody\>)/mg )
  	{
		push @all_tbody, $1;
		#print "xxx=".$1."\n";
	};
	return @all_tbody;	
}


sub fetchRegularExpressionForDataHidenInTbody($)
{
	$dataType = $_[0];
	
	if($dataType  eq 'event name' )
	{
			return 'data-event-name=\"(.+?)\"'
			 			
	}	
	elsif($dataType  eq '1' or $dataType  eq 'draw' or $dataType  eq '2')
	{
		my $resultType = $dataType;
		if($resultType  eq '2')
		{
			$resultType = '3';
		}		 		

		return "Match_Result\.$resultType" .'[\w\W]{1,}?(\d{1,2}\.\d\d)</span>'    
		
	}	
	elsif($dataType eq 'date')
	{
		die 'unsupported data type: ' . $dataType;
	}

	die 'unsupported data type' . $dataType;
}

sub getSpecificEventDataFromHtml($$)
{
	$tbodyWithEventData = $_[0];
	$dataType = $_[1];
	$regularExpressionUsedToFindData = fetchRegularExpressionForDataHidenInTbody($dataType);
	
	$tbodyWithEventData = ~ /$regularExpressionUsedToFindData/;
	print "re expression $regularExpressionUsedToFindData";
	print "$dataType $1\n";	
	

	#return '1'=>'2.01'
		
	if($dataType  eq 'event name' )
	{
		#	$tbodyWithEventData = ~ /data-event-name=\"(.+?)\"/;
		#	return $1;			
	}	
	elsif($dataType  eq '1' or $dataType  eq 'draw' or $dataType  eq '2')
	{
		#$tbodyWithEventData = ~ /data-selection-key/;

		#die;
	}	
	else
	{
		die 'unsupported data type' . $dataType;
	}

	return $1;
	
}


sub fetchAllEventsDataFromHtml($)
{
  my $pathToHtmlFileWithEvents = $_[0]; 
  
  my $htmlContentWithEvents = getContentFromPath($pathToHtmlFileWithEvents);

  my @all_tbody = fetchAll_tbody($htmlContentWithEvents);
  
  my %allEvents = ();
  
  #$allEvents  'Wisla - Cracovia'=>'1' 
  
  
  my $idx = 0;
  foreach(@all_tbody)
  {
	my $tbodyWithCurrentEventData = $_;
	my $currentEventName  = getSpecificEventDataFromHtml($tbodyWithCurrentEventData, 'event name');

#	$allEvents{$currentEventName} = '';	

	$allEvents{$currentEventName} =  { 
										'1'=> getSpecificEventDataFromHtml($tbodyWithCurrentEventData, '1')
										, 'X'=> getSpecificEventDataFromHtml($tbodyWithCurrentEventData, 'draw')
										, '2'=> getSpecificEventDataFromHtml($tbodyWithCurrentEventData, '2')
										#, 'date' => getSpecificEventDataFromHtml($tbodyWithCurrentEventData, 'date')
	
	 							};
	#die 'todo content of $allEvents{$currentEventName}'; 
	print "\n\n\n";
	print $allEvents{'Al-Ittihad Jeddah vs Al Nasr Dubai'}{'1'} ."\n";	
	
	#my $eventData = ( 'event name' => fetchEventNameFrom_tbody() ); 
	#fetchEventNameFrom_tbody();
	
  }
  die;


}
