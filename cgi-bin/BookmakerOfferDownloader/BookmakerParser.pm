package BookmakerParser;
sub new();
sub makeParser($);

sub new()
{
	my $class = shift;
	my $self = {};
	return bless $self, $class

}

sub makeParser($)
{
	my ($objectOfClassBookmakerPageCrawler) = @_;
	if(ref $objectOfClassBookmakerPageCrawler eq 'GroupLevelCategoryPage')
	{
		return GroupLevelCategoryPageParser->new();
	}
	else
	{
		die "unsupported CategoryPage object"
	}

}

sub downloadOffer()
{
	print "xxx";



}


1;
