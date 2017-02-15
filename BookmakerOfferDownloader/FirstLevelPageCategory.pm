package FirstLevelPageCategory;

use CategoryPage;
use warnings;
use strict;

our @ISA = qw(CategoryPage);

sub getAllSubCategories($)
{
	return ('Albania', 'Algeria', 'Australia');

}


1;



