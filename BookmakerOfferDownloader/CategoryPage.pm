package CategoryPage;
use Data::Dumper;
use warnings;
use strict;
use Class::Interface;
&implements( 'CategoryPageIf' );
#our @ISA = qw(CategoryPageIf);

sub getAllSubCategories($);
sub setStrategy($);

#would be nice to find some UML creator
#Im not sure if all below subs must be implemented in child
sub makeParser($){};# maybe there is a more elegant way; inheriting without implementation
sub downloadOffer{};
sub couldYouHandleThatXPath($){};

sub setStrategy($)
{
	my ($self, $mockedOrRealWWW_argument) = @_;

	if ($mockedOrRealWWW_argument eq '--realnet')
	{
	
		$self->{m_strategyOfObtainingBookmakerData} = WWWBookmakerPage->new();		
	}
	elsif($mockedOrRealWWW_argument eq '--mockednet')
	{
		$self->{m_strategyOfObtainingBookmakerData} = MockedBookmakerPage->new();
	}
	else
	{
		die;
	}
	

};


sub new($)
{
	#CategoryPage::new
	my ($class, $mockedOrRealWWW_argument) = @_;
	my $self = bless {}, $class;	
		
	$self->setStrategy($mockedOrRealWWW_argument);									  
	
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
		my $aCategoryPageHandler = $_;
		if($aCategoryPageHandler->couldYouHandleThatXPath($xpatToSubcategory))
		{
			return $aCategoryPageHandler->getAllSubCategories($xpatToSubcategory);			
		}; 	
	}
	die "This xpath can not be handled by any CategoryPage";	
};

sub checkCategoryPage($){};
sub checkLevelOfCategoryPage($){};
1;
