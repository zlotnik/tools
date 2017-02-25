package GroupLevelCategoryPage;

use CategoryPage;
use warnings;
use strict;
use LWP::Simple;
use BetExplorerParser;

our @ISA = qw(CategoryPage);

sub new();




sub new()
{
	my $class = shift;
	my ($subCategoryXpath) = @_;
	
	my $self = $class->SUPER::new($subCategoryXpath);
		
	$self->{mlinkToCategory} = 'http://www.betexplorer.com/' . $self->{mSubCategoryXpath};	
	return $self;

}

sub getAllSubCategories($)
{
	my $self = shift;
	
	
	#my $tableWithEventList = BetExplorerParser::pickupTableWithEventsFromWeburl($self->{mlinkToCategory});

	
	
	return ('Legia-Wisla', 'Plock-Zaglebie');
}

1;



