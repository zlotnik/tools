use SurebetHarvester;
#
#        ________________          _________________            _______________
#	|SurebetHarvester| 1-----*| IBookMakerParser|<-------- |BookMakerParser| <--- MarathonParser
#	----------------- 	   -----------------            ---------------  <--- PinnacleParser	
#                                  |                |
sub main
{


	my theSurebetHarvester = SurebetHarvester->new();
	theSurebetHarvester->addBookmakerParser('Pinnacle');
	theSurebetHarvester->addBookmakerParser('Marathon');
	theSurebetHarvester->addFilterLimitingDiscipline('soccer');
	theSurebetHarvester->addFilterLimitingCountry('*');
	theSurebetHarvester->addFilterExtendingCountry('Poland');
	theSurebetHarvester->go();



}


sub parseInputArguments()
{


}

sub scanInputArguments()
{

}


sub showUsage
{
	print "harvest --discipline-add=soccer --country-rm=* --country-add=Poland\n";
#	print "harvest --country-rm=*\n";
#	print "harvest --country-add=Poland\n";

}
