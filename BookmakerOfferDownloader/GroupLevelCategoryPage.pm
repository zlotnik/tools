package GroupLevelCategoryPage;
use BookmakerPageCrawler;
use warnings;
use strict;
use LWP::Simple;
use BetexplorerParser;

our @ISA = qw(CategoryPage);

sub new();

sub new()
{
	my $class = shift;
	#my ($subCategoryXpath) = @_;
	
	#my $self = $class->SUPER::new($subCategoryXpath);
	my $self = bless {}, $class;
	#$self->{mlinkToCategory} = 'http://www.betexplorer.com/' . $self->{mSubCategoryXpath};	
	return $self;

}

sub getAllSubCategories($)
{
	my $self = shift;
	#BetexplorerParser::pickupLinksToEventFromTable("");
	my @toReturn = BetexplorerParser::pickupLinksToEventFromTable(BetexplorerParser::pickupTableWithEventsFromWeburl($self->{mlinkToCategory}));	
	return @toReturn;
}

1;



