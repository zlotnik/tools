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
	return ('Ektraklasa', 'Polish Cup');

}


1;



