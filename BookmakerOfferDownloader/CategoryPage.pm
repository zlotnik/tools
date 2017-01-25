package CategoryPage;
#our @ISA = qw(BookmakerParser);
use warnings;
use strict;


#our $test = 'xyz';

sub makeCategoryPageObject
{
	my $class = shift;
	my $subCategoryXpath = shift;
	my $self = {};
	
	if ()
	{
		return FirstLevelPageCategory->new($subCategoryXpath);
	}
	elsif()
	{
		return SecondLevelPageCategory->new($subCategoryXpath);
	}
	elsif()
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
