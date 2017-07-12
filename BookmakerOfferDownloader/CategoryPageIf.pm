package CategoryPageIf;

use warnings;
use strict;

use Class::Interface;
&interface; 


#Im not sure if all below subs must be implemented in child
sub makeParser;#($);
sub downloadOffer;
#sub new($);
sub getAllSubCategories;#();
sub checkCategoryPage;#($);
sub checkLevelOfCategoryPage;#($);
sub couldYouHandleThatXPath;#($);
sub setStrategy;#($);


1;
