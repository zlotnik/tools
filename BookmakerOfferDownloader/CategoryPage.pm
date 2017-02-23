package CategoryPage;
#our @ISA = qw(BookmakerParser);

use warnings;
use strict;
use CountryLevelCategoryPage;
use GroupLevelPageCategory;
use EventLevelPageCategory;

#our $test = 'xyz';
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
	if ($categoryPage eq 'CountryLevelPageCategory')
	{
		return CountryLevelCategoryPage->new($subCategoryXpath);
	}
	elsif($categoryPage == 2)
	{
		return GroupLevelPageCategory->new($subCategoryXpath);
	}
	elsif($categoryPage == 3)
	{
		return EventLevelPageCategory->new($subCategoryXpath);
	}
	else
	{
		die "Isn't possible to create CategoryPage object";
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
		return 'CountryLevelPageCategory';
	}
	else
	{
		die 'unsoported category page'
		
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
