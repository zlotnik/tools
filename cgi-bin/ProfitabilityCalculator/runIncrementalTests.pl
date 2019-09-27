#!/usr/bin/perl

my $incrementalTestsDirectory = "tests/incremental"; 

opendir(my $dh, $incrementalTestsDirectory) or die;
while(my $filename = readdir $dh)
{
    if ($filename =~ /\.pl$/)
    {
        $runTestCommand = "perl ${incrementalTestsDirectory}/${filename}";
        print "Running $runTestCommand\n";
        system($runTestCommand);
    }    

}

closedir ($dh) or die;