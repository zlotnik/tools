package EventLevelCategoryPage;

use BookmakerPageCrawler;
use warnings;
use strict;

our @ISA = qw(CategoryPage);

sub new();

sub new()
{
	my $class = shift;
	#my ($subCategoryXpath) = @_;
	
	#my $self = $class->SUPER::new($subCategoryXpath);
	my $self = bless {}, $class;
	#$self->{mlinkToCategory} = 'http://www.betexplorer.com/' . $self->{mSubCategoryXpath};	
	return $self;
}

sub getAllSubCategories($)
{
	return ();
}

1;



