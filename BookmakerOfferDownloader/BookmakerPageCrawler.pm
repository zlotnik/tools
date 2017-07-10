package BookmakerPageCrawler;

use warnings;
use strict;
use CountryLevelCategoryPage;
use GroupLevelCategoryPage;
use EventLevelCategoryPage;
use MockedBookmakerPage;
use CategoryPage;
#############TODO#####################################

######################################################
sub makeCategoryPageObject();
sub checkLevelOfCategoryPage($);
sub getAllSubCategories($);

######################################################

sub getAllSubCategories($)
{
	#BookmakerPageCrawler::getAllSubCategories
	my ($self, $subCategoryXpath) = @_;	
	my @toReturn = $self->{m_CategoryPage}->getAllSubCategories($subCategoryXpath);
	return @toReturn;
};
 
sub makeCategoryPageObject()
{
	my $class = shift;
	my $subCategoryXpath = shift;
	my $self = {};
	
	
	die "here finished CountryLevelCategoryPageReal and CountryLevelCategoryPageMocked difference in get  method";
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
	else
	{
		die "unsupported category page $categoryPageSelector \n";
		
	}
	
	

}

#BookmakerPageCrawler::new
sub new($)
{
	my ($class, $mockedOrRealWWW_argument) = @_;
	
	
	
	#my $self = bless { mSubCategoryXpath => $mSubCategoryXpath }, $class;	
	#mSubCategoryXpath seems that doesn't need anymore	
	
	my $self = bless {}, $class;
	
	
	if ($mockedOrRealWWW_argument eq '--realnet')
	{
		$self->{m_BookmakerPage} = WWWBookmakerPage->new();
	}
	elsif($mockedOrRealWWW_argument eq '--mockednet')
	{
		$self->{ m_BookmakerPage} = MockedBookmakerPage->new();
	}
	else
	{
		die;
	}
	
	$self->{ m_CategoryPage} = CategoryPage->new();	
	
	return $self;

}

1;
