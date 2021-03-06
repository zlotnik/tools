package BookmakerPageCrawler;

use warnings;
use strict;
use CountryLevelCategoryPage;
use GroupLevelCategoryPage;
use EventLevelCategoryPage;
use CategoryPage;
#############TODO#####################################

######################################################
sub checkLevelOfCategoryPage($);
sub getAllSubCategories($);
sub getRawDataOfEvent($);
######################################################

sub getRawDataOfEvent($)
{
	my ($self,$linkToEvent) = @_;	
	$self->{m_CategoryPage}->getRawDataOfEvent($linkToEvent);
	
};

sub get($)
{
	my ($self,$linkToEvent) = @_;	
	$self->{m_CategoryPage}->get($linkToEvent);
	
};


sub getAllSubCategories($)
{
	#BookmakerPageCrawler::getAllSubCategories
	my ($self, $subCategoryXpath) = @_;	
	my @toReturn = $self->{m_CategoryPage}->getAllSubCategories($subCategoryXpath);
	return @toReturn;
};

sub checkCategoryPage($)
{
	my $categoryPageSelector = shift;
		
	my @tokenizedCategoryPageSelector = split('/',$categoryPageSelector);
	if ($tokenizedCategoryPageSelector[$#tokenizedCategoryPageSelector] eq '')
	{
		pop @tokenizedCategoryPageSelector;
	}
	if ($tokenizedCategoryPageSelector[0] eq '')
	{
		shift @tokenizedCategoryPageSelector;
	}
	
	if($#tokenizedCategoryPageSelector == 1)
	{
		return 'CountryLevelCategoryPage';
	}
	elsif($#tokenizedCategoryPageSelector == 2)
	{	
		return 'GroupLevelCategoryPage';
	}
	elsif($categoryPageSelector =~  m|http|)
	{
		return 'EventLevelCategoryPage';
	}
	else
	{
		die "unsupported category page $categoryPageSelector \n";
		
	}
	
	

}

#BookmakerPageCrawler::new
sub new($)
{
	my ($class, $mockedOrRealWWW_argument) = @_;	
		
	my $self = bless {}, $class;	
	
	$self->{ m_CategoryPage} = CategoryPage->new($mockedOrRealWWW_argument);	
	
	return $self;

}

1;
