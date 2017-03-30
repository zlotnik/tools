package BookmakerXmlDataParser;
use base 'Exporter';
our @EXPORT = qw(isCorectBookmakerOfferFile isCorectBookmakerSelectorFile);
#nice to have; tool to create templates for files .pm, .pl   
#move all parsers to new directory
#code coverage
##################DECLARATION##################################
sub new();
sub isCorectBookmakerSelectorFile($);
sub isCorectBookmakerOfferFile($);


#################DEFINITION####################################
sub new()
{
	my $class = shift;
	my $self = bless {}, $class;
	return $self;
};

sub isCorectBookmakerOfferFile($)
{
	return 0;
};

sub isCorrectEventListFile($)
{
	return 0;
};

sub isCorectBookmakerSelectorFile($)
{
	return 0;
};

1;