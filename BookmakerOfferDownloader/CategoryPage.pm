package CategoryPage;
#our @ISA = qw(BookmakerParser);

use warnings;
use strict;
use CountryLevelCategoryPage;
use GroupLevelCategoryPage;
use EventLevelCategoryPage;
use EventDetailsLevelCategoryPage;

######################################################
sub makeCategoryPageObject();
sub checkLevelOfCategoryPage($);

######################################################

 
sub makeCategoryPageObject()
{
	my $class = shift;
	my $subCategoryXpath = shift;
	my $self = {};
	
	my $categoryPage = checkCategoryPage($subCategoryXpath);
	if ($categoryPage eq 'CountryLevelCategoryPage')
	{
		return CountryLevelCategoryPage->new($subCategoryXpath);
	}
	elsif($categoryPage eq 'GroupLevelCategoryPage')
	{
		return GroupLevelCategoryPage->new($subCategoryXpath);
	}
	elsif($categoryPage eq 'EventLevelCategoryPage')
	{
		return EventLevelCategoryPage->new($subCategoryXpath);
	}
	elsif($categoryPage eq 'EventDetailsLevelCategoryPage')
	{
		return EventDetailsLevelCategoryPage->new($subCategoryXpath);
	}
	else
	{
		die "Isn't possible to create CategoryPage object basis on object string: $categoryPage";
	}
	#return bless $self, $class

}

sub checkCategoryPage($)
{
	my $categoryPageSelector = shift;
		
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
		return 'CountryLevelCategoryPage';
	}
	elsif($#tokenizedCategoryPageSelector == 2)
	{
		return 'GroupLevelCategoryPage';
	}
	elsif($categoryPageSelector =~  m|http|)
	{
		return 'EventLevelCategoryPage';
	}
	elsif($#tokenizedCategoryPageSelector == 4)
	{
		die "propably an unused fragment";
		return 'EventDetailsLevelCategoryPage';
	}
	else
	{
		die "unsupported category page $categoryPageSelector \n";
		
	}
	
	

}


sub new($)
{
	my $class = shift;
	my ($mSubCategoryXpath) = @_;
	my $self = bless { mSubCategoryXpath => $mSubCategoryXpath }, $class;	
	return $self;

}

#requires 'getAllSubCategories';

1;
