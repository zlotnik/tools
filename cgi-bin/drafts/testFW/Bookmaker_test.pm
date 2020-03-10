#
#===============================================================================
#
#              FILE: Bookmaker_test.pm
#
#  RESPONSIBILITIES: 
#
#
#             FILES: ---
#              BUGS: ---
#             NOTES: ---
#            AUTHOR: WOJCIECH MARZEC (), marzec.wojciech@gmail.com
#      ORGANIZATION: 
#           CREATED: 03/03/20 17:23:00
#===============================================================================

use strict;
use warnings;
 

#should be a script to init directory structure


my $testPlan = TestPlan->new();
my $testPlan->set_setUp( \&initProcedure );
my $testPlan->set_tearDown( \&cleaningProcedure );


#$testPlan->loadTestSuites('testPlan/'); #Iam not sure that is good

my $testPlan->set_TestsPlanDirectory('testPlan');

my $testSuite = TestSuite->new();
my $testSuite->load(\&validateSelectorFile);



my $testSuitexs


