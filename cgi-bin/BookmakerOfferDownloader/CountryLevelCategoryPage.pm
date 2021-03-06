package CountryLevelCategoryPage;
use BookmakerPageCrawler;
use CategoryPage;
use warnings;
use strict;

#############TODO#########################
#-hardcoded category list
#

use parent qw(CategoryPage);

sub new();

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
	
	if($#tokenizedCategoryPageSelector == 1)
	{
		return 1;
	}
	return 0;
	
};

sub new()
{
	my ($class, $referenceToStrategyOfObtainingBookmakerData) = @_;
	my $self = bless {}, $class;		
	$self->{m_strategyOfObtainingBookmakerData} = $referenceToStrategyOfObtainingBookmakerData;
	
	return $self;
}

sub downloadSoccerLeagueNames($);
sub downloadSoccerLeagueNames($)
{
	my ($self, $subCategoryXpath ) = @_;
	my @toReturn;
	
	my $linkToCategory = 'https://www.betexplorer.com/soccer/' ;
	my $contentOfSubcategoryPage  = $self->{m_strategyOfObtainingBookmakerData}->get($linkToCategory); 
	
	while($contentOfSubcategoryPage =~ m|<a href="${subCategoryXpath}/(.*?)/" class="list|gi)
	{
			push @toReturn, $1;
	}
	
	if ($#toReturn == -1)
	{
		print "There is no any event for ${subCategoryXpath}\n";
	}
	
	return @toReturn;
}

1;
