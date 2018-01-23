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
	my ($class, $referenceToStrategyOfObtainingBookmakerData) = @_;
	my $self = bless {}, $class;		
	$self->{m_strategyOfObtainingBookmakerData} = $referenceToStrategyOfObtainingBookmakerData;
	
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
#GroupLevelCategoryPage::getAllSubCategories
sub getAllSubCategories($)
{
	#c GroupLevelCategoryPage::getAllSubCategories
	
	
	my ($self,$subCategoryXpath ) = @_;
	
	my $linkToCategory = 'http://www.betexplorer.com/' . $subCategoryXpath . "/";	
	
	my $contentOfSubcategoryPage  = $self->{m_strategyOfObtainingBookmakerData}->get($linkToCategory); 	
	my @toReturn;
		
	my $regexp = '(<td class=\"table-main__daysign\")([\s\S]*?)(</table>)';
	if(not $contentOfSubcategoryPage =~ m|${regexp}|m )
	{
		print "There is no event for $linkToCategory\n";
		print "DEBUG: Can't match expression ${regexp}\n";
	}
	else	{
		
		my $htmlTableWithEvents = $1.$2.$3;
		@toReturn = BetexplorerParser::pickupLinksToEventFromTable($htmlTableWithEvents);	
	}
	
	return @toReturn;
	
}

1;