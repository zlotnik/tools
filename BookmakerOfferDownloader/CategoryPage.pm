package CategoryPage;
#our @ISA = qw(BookmakerParser);

use warnings;
use strict;
use FirstLevelPageCategory;
use ThirdLevelPageCategory;
use SecondLevelPageCategory;

#our $test = 'xyz';

sub makeCategoryPageObject
{
	my $class = shift;
	my $subCategoryXpath = shift;
	my $self = {};
	
	if (1)
	{
		return FirstLevelPageCategory->new($subCategoryXpath);
	}
	elsif(1)
	{
		return SecondLevelPageCategory->new($subCategoryXpath);
	}
	elsif(1)
	{
		return ThirdLevelPageCategory->new($subCategoryXpath);
	}
	else
	{
		die "Isn't possible to create CategoryPage object";
	}
 
	#return bless $self, $class

}

#requires 'getAllSubCategories';

1;