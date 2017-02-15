package CountryCategoryPage;
use CategoryPage;
use warnings;
use strict;

#############TODO#########################
#-hardcoded category list
#


our @ISA = qw(CategoryPage);

sub getAllSubCategories($)
{
	return ('Albania', 'Algeria', 'Australia');

}


1;



