package CategoryPage;
#our @ISA = qw(BookmakerParser);

use warnings;
use strict;
use CountryLevelCategoryPage;
use GroupLevelCategoryPage;
use EventLevelCategoryPage;


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
	else
	{
		die "Isn't possible to create CategoryPage object basis on object string: $categoryPage";
	}
 
	#return bless $self, $class

}

sub checkCategoryPage($)
{
	my $categoryPageSelector = shift;
	my @tokoenizedCategoryPageSelector = split('/',$categoryPageSelector);
	if ($tokoenizedCategoryPageSelector[$#tokoenizedCategoryPageSelector] eq '')
	{
		pop @tokoenizedCategoryPageSelector;
	}
	if ($tokoenizedCategoryPageSelector[0] eq '')
	{
		shift @tokoenizedCategoryPageSelector;
	}
	
	if($#tokoenizedCategoryPageSelector == 1)
	{
		return 'CountryLevelCategoryPage';
	}
	elsif($#tokoenizedCategoryPageSelector == 2)
	{
		return 'GroupLevelCategoryPage'
	}
	elsif($#tokoenizedCategoryPageSelector == 3)
	{
		return 'EventLevelCategoryPage'
	}
	else
	{
		die 'unsupported category page'
		
	}
	
	

}


sub new
{
	my $class = shift;
	my ($mSubCategoryXpath) = @_;
	my $self = bless { mSubCategoryXpath => $mSubCategoryXpath }, $class;
	return $self;

}

#requires 'getAllSubCategories';

1;
