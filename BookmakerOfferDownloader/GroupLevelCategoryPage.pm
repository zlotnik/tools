package GroupLevelCategoryPage;

use CategoryPage;
use warnings;
use strict;

our @ISA = qw(CategoryPage);

sub getAllSubCategories($)
{
	return ('Legia-Wisla', 'Plock-Zaglebie');
}

1;



