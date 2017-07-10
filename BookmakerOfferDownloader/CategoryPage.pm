package CategoryPage;
use Data::Dumper;
use warnings;
use strict;
use Class::Interface;
&implements( 'CategoryPageIf' );
#our @ISA = qw(CategoryPageIf);

sub getAllSubCategories($);

#Im not sure if all below subs must be implemented in child
sub makeParser($){};# maybe there is a more elegant way; inheriting without implementation
sub downloadOffer{};
sub new($)
{
	#CategoryPage::new
	my $class = $_[0];
	my $self = bless {}, $class;
	
	CountryLevelCategoryPage->new();
	GroupLevelCategoryPage->new();
	my $test = EventLevelCategoryPage->new();
	$self->{m_ddd};
	
	$self->{m_CategoryPagesHandlers}  = [CountryLevelCategoryPage->new(),
										  GroupLevelCategoryPage->new(),
										  EventLevelCategoryPage->new()
										  ];
	return $self;
};

sub getAllSubCategories($)
{
	#CategoryPage::getAllSubCategories
	my ($self, $xpatToSubcategory) = @_;

	for(@{$self->{m_CategoryPagesHandlers}})
	{
		print $_;	
	}
	die;		
};

sub checkCategoryPage($){};
sub checkLevelOfCategoryPage($){};
1;
