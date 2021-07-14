package EventLevelCategoryPage;

use BookmakerPageCrawler;
use warnings;
use strict;

use parent qw(CategoryPage);

sub new();

sub new()
{
	my $class = shift;

	my $self = bless {}, $class;

	return $self;
}

sub getAllSubCategories($)
{
	return ();
}

sub couldYouHandleThatXPath($)
{	
	
	my ($self, $categoryPageSelector) = @_;
		
	my @tokenizedCategoryPageSelector = split('/',$categoryPageSelector);
	if ($tokenizedCategoryPageSelector[$#tokenizedCategoryPageSelector] eq '')
	{
		pop @tokenizedCategoryPageSelector;
	}
	if ($tokenizedCategoryPageSelector[0] eq '')
	{
		shift @tokenizedCategoryPageSelector;
	}
	
	if($categoryPageSelector =~  m|http|)
	{
		return 1;
	}
	return 0;
	
};


1;



