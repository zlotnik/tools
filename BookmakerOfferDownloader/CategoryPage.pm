package CategoryPage;

use warnings;
use strict;
use Class::Interface;
&implements( 'CategoryPageIf' );
#our @ISA = qw(CategoryPageIf);

#Im not sure if all below subs must be implemented in child
sub makeParser($){};# maybe there is a more elegant way; inheriting without implementation
sub downloadOffer{};
sub new($)
{
	die "here a problem"
	my $class = $_[0];
	my $self = bless{},$class;
	
	$self->{m_CategoryPagesHandlers}  = \(CountryLevelCategoryPage->new(),
										  GroupLevelCategoryPage->new(),
										  EventLevelCategoryPage->new()
										  );

};
sub getAllSubCategories()
{
	my $self = $_[0];

	for(@{$self->{m_CategoryPagesHandlers}})
	{
		print $_;
	
	}
	die;
	
	
};
sub checkCategoryPage($){};
sub checkLevelOfCategoryPage($){};


1;
