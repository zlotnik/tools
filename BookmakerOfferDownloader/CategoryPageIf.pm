package CategoryPageIf;

use warnings;
use strict;

use Class::Interface;
&interface; 


die "Im not sure if all below subs must be implemented in child"
sub makeParser($);
sub downloadOffer;
sub new($);
sub getAllSubCategories();
sub checkCategoryPage($);
sub checkLevelOfCategoryPage($);


1;
