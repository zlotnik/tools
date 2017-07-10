package CountryLevelCategoryPage;
use BookmakerPageCrawler;
use CategoryPage;
use warnings;
use strict;
use LWP::Simple;

#############TODO#########################
#-hardcoded category list
#

our @ISA = qw(CategoryPage);

sub new();

sub new()
{
	my $class = shift;
	#my ($mSubCategoryXpath) = @_;
	#my $self = $class->SUPER::new($mSubCategoryXpath);
	my $self = bless {}, $class;		
	#$self->{mlinkToCategory} = 'http://www.betexplorer.com/';
	return $self;

}

sub getAllSubCategories()
{
	my $self = shift;
	my $mSubCategoryXpath = $self->{mSubCategoryXpath}; 
	my @toReturn = ();
	
	my $linkToCategory = 'http://www.betexplorer.com/' ;
	my $contentOfSubcategoryPage  = get($linkToCategory) or die "unable to get $linkToCategory \n"; # move it to CategoryPage objects 
		
	while($contentOfSubcategoryPage =~ m|${mSubCategoryXpath}/(.*?)/|gi)
	{
			push @toReturn, $1;
	}
	return @toReturn;
}

1;



