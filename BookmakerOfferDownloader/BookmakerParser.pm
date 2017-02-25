package BookmakerParser;
#################BACKLOG         #######################################################
#################DICTIONARY      #######################################################
#################SUB PROTOTYPES  #######################################################
sub new();
sub makeParser($);
#################MAIN            #######################################################




#################SUB DEFINITIONS #######################################################
sub new()
{
	my $class = shift;
	my $self = {};
	return bless $self, $class

}

sub makeParser($)
{
	my ($objectOfClassCategoryPage) = @_;
	if(ref $objectOfClassCategoryPage eq 'GroupLevelCategoryPage')
	{
		return GroupLevelCategoryPageParser->new();
	}
	else
	{
		die "unsupported CategoryPage objext"
	}

}

sub downloadOffer()
{
	print "xxx";



}


1;
