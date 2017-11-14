#!/usr/bin/perl -w
use strict;
use warnings;

########################SUBS DECLARATIONS###############
sub checkProgramArguments();
sub showUsage();



########################MAIN###############
if(!checkProgramArguments())
{
	showUsage();
}


#######################SUBS DEFINITIONS#################
sub checkProgramArguments()
{
	if ($#ARGV == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
};


sub showUsage()
{
	open my $usageFile_FH , '<', 'design/usage.txt' or die;

	{
		local $/ = undef;
		print <$usageFile_FH>;
	}
	
	close $usageFile_FH or die;
}
	
	
