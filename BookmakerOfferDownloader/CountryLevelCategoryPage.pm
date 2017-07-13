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
	my $class = shift;
	#my ($mSubCategoryXpath) = @_;
	#my $self = $class->SUPER::new($mSubCategoryXpath);
	my $self = bless {}, $class;		
	#$self->{mlinkToCategory} = 'http://www.betexplorer.com/';
	return $self;
}

sub getAllSubCategories()
{
	my ($self, $subCategoryXpath ) = @_;
	my @toReturn = ();
	
	my $linkToCategory = 'http://www.betexplorer.com/' ;
	my $contentOfSubcategoryPage  = $self->get($linkToCategory); 
	
	while($contentOfSubcategoryPage =~ m|${subCategoryXpath}/(.*?)/|gi)
	{
			push @toReturn, $1;
	}
	return @toReturn;
}

1;



