package GroupLevelCategoryPage;

use CategoryPage;
use warnings;
use strict;
use LWP::Simple;
use BetExplorerParser;


our @ISA = qw(CategoryPage);

sub getAllSubCategories($)
{
	my $self = shift;
	my $aBetExplorerParser  = new BookmakerParser->makeParser($self);
	my $tableWithEventList = $aBetExplorerParser->getTableWithEventList();

	
	
	return ('Legia-Wisla', 'Plock-Zaglebie');
}

1;



