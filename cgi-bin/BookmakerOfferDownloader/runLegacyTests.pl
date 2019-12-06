#!/usr/bin/perl

my $legacyTestDirectory = "tests/functional_tests/legacy"; 

opendir(my $dh, $legacyTestDirectory) or die;
while(my $filename = readdir $dh)
{
    if ($filename =~ /\.pl$/)
    {
        $runTestCommand = "perl ${legacyTestDirectory}/${filename}";
        print "Running $runTestCommand\n";
        system($runTestCommand);
    }    

}

closedir ($dh) or die;