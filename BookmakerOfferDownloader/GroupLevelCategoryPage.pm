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

sub couldYouHandleThatXPath($)
{	
	
	my ($self,$categoryPageSelector) = @_;
		
	my @tokenizedCategoryPageSelector = split('/',$categoryPageSelector);
	if ($tokenizedCategoryPageSelector[$#tokenizedCategoryPageSelector] eq '')
	{
		pop @tokenizedCategoryPageSelector;
	}
	if ($tokenizedCategoryPageSelector[0] eq '')
	{
		shift @tokenizedCategoryPageSelector;
	}
	
	if($#tokenizedCategoryPageSelector == 2)
	{
		return 1;
	}
	
	return 0;
	
};

sub getAllSubCategories($)
{
	my ($self,$subCategoryXpath ) = @_;
	#BetexplorerParser::pickupLinksToEventFromTable("");
	my $linkToCategory = 'http://www.betexplorer.com/' . $subCategoryXpath;	
	my @toReturn = BetexplorerParser::pickupLinksToEventFromTable(BetexplorerParser::pickupTableWithEventsFromWeburl($linkToCategory));	
	return @toReturn;
}

1;



