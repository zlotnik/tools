package CountryLevelCategoryPage;
use BookmakerPageCrawler;
use CategoryPage;
use warnings;
use strict;

#############TODO#########################
#-hardcoded category list
#

our @ISA = qw(CategoryPage);

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
	#my ($mSubCategoryXpath) = @_;
	#my $self = $class->SUPER::new($mSubCategoryXpath);
	my $self = bless {}, $class;		
	$self->{m_strategyOfObtainingBookmakerData} = $referenceToStrategyOfObtainingBookmakerData;
	#$self->{mlinkToCategory} = 'http://www.betexplorer.com/';
	return $self;
}

sub getAllSubCategories()
{
	my ($self, $subCategoryXpath ) = @_;
	my @toReturn = ();
	
	my $linkToCategory = 'http://www.betexplorer.com/soccer/' ;
	my $contentOfSubcategoryPage  = $self->{m_strategyOfObtainingBookmakerData}->get($linkToCategory); 
	
	#die "below there is problem; incorrect returned results";
	#while($contentOfSubcategoryPage =~ m|${subCategoryXpath}/(.*?)/|gi)
	while($contentOfSubcategoryPage =~ m|<a href="${subCategoryXpath}/(.*?)/|gi)
	{
			push @toReturn, $1;
	}
	return @toReturn;
}

1;



