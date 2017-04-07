package BookmakerXmlDataParser;
use base 'Exporter';
our @EXPORT = qw(isCorectBookmakerOfferFile isCorectBookmakerSelectorFile);
#nice to have; tool to create templates for files .pm, .pl   
#move all parsers to new directory
#think about code coverage
#incorrect inputs should be
##################DECLARATION##################################
sub new();
sub isCorectBookmakerSelectorFile($);
sub isCorectBookmakerOfferFile($);
sub xmlSelectorContainsAllNeededData($);

#################DEFINITION####################################
sub new()
{
	my $class = shift;
	my $self = bless {}, $class;
	return $self;
};

sub isCorectBookmakerOfferFile($)
{
};

sub isCorrectEventListFile($)
{
	return 0;
};

sub isCorectBookmakerSelectorFile($)
{
	my $xmlParser = XML::LibXML->new; 
	my $isCorrectXmlFile = $xmlParser->parse_file($pathToXmlSelector); 
	
	if($isCorrectXmlFile and xmlSelectorContainsAllNeededData($))
	{
		return 1;
	}
	return 0;
};

sub xmlSelectorContainsAllNeededData($)
{
	return (isOneOrMoreBookmakersSpecifiedInXmlSelector($) and isOneOrMoreDyscyplineSpecified($));


};

sub isOneOrMoreBookmakersSpecifiedInXmlSelector($)
{
	
	#findForDataSources 
		#if exist check if contains list of bookmaker
			#check if  each bookmaker is supported
		#else return 0
};

sub isOneOrMoreDyscyplineSpecified($)
{
	my $xmlDoc = $_[0];
	
	my $dataChoosenToDownloadXmlNode = $doc->findnodes("/note/dataChoosenToDownload")->[0];
	
	die 'Iam not sure if it is correct formula';
	if (not defined($dataChoosenToDownloadXmlNode))
	{
		return 0 ;
	}
	
	foreach($dataChoosenToDownloadXmlNode->nonBlankChildNodes())
	{
		my $disciplineName = $_;
		if(not isCorrectDisciplineName($disciplineName))
		{
			return 0;
		}
	}
		
};



1;