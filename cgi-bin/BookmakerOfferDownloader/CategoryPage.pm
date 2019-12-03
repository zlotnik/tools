package CategoryPage;
use Data::Dumper;
use warnings;
use strict;
use MockedBookmakerPage;
use WWWBookmakerPage;
#use SourceOfBookmakerPageIf;


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
sub getRawDataOfEvent($);

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

sub getRawDataOfEvent($)
{
	my ($self, $linkToEvent) = @_;
	$self->{m_strategyOfObtainingBookmakerData}->getRawDataOfEvent($linkToEvent);

}


sub new($)
{
	#CategoryPage::new
	my ($class, $mockedOrRealWWW_argument) = @_;
	my $self = bless {}, $class;	
		
	$self->setStrategy($mockedOrRealWWW_argument);									  
	
	$self->{m_CategoryPagesHandlers}  = [CountryLevelCategoryPage->new($self->{m_strategyOfObtainingBookmakerData}),
										  GroupLevelCategoryPage->new($self->{m_strategyOfObtainingBookmakerData}),
										  EventLevelCategoryPage->new($self->{m_strategyOfObtainingBookmakerData})
										  ];
	return $self;
};

sub getAllSubCategories($)
{
	
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
