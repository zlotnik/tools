package CountryLevelCategoryPage;
use CategoryPage;
use warnings;
use strict;

#############TODO#########################
#-hardcoded category list
#


our @ISA = qw(CategoryPage);

sub getAllSubCategories($)
{
	return ('Ekstraklasa', 'Polish Cup');

}


1;



