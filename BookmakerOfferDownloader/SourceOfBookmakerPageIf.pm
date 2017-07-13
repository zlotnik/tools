package SourceOfBookmakerPageIf;

use warnings;
use strict;

use Class::Interface;
&interface; 


#Im not sure if all below subs must be implemented in child
#sub makeParser($); #needed ?
#sub downloadOffer; #needed ?
#sub new($);	#needed ?
#sub getAllSubCategories(); #needed ?
#sub checkCategoryPage($); #needed ?
#sub checkLevelOfCategoryPage($); #needed ?
#sub getRawDataOfEvent($);
sub getRawDataOfEvent;
sub get;#($);

1;
