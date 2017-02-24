package CountryLevelCategoryPage;
use CategoryPage;
use warnings;
use strict;
use LWP::Simple;

#############TODO#########################
#-hardcoded category list
#


our @ISA = qw(CategoryPage);

sub getAllSubCategories()
{
	my $self = shift;
	my $mSubCategoryXpath = $self->{mSubCategoryXpath}; 
	my @toReturn = ();
	
	my $linkToCategory = 'http://www.betexplorer.com/' ;#. $mSubCategoryXpath;  # move it to CategoryPage objects
	my $contentOfSubcategoryPage  = get($linkToCategory) or die "unable to get $linkToCategory \n"; # move it to CategoryPage objects 
	
	
	while($contentOfSubcategoryPage =~ m|${mSubCategoryXpath}/(.*?)/|g)
	{
			push @toReturn, $1;
	}
	
	
	
	
	return @toReturn;

}


1;



