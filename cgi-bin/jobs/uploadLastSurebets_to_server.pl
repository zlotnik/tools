#!/usr/bin/perl
#
use strict;
use warnings;

sub pushBreakLine();


my $dataLocation = '/var/www/data/last_surebets';

my @list = `ls -t $ENV{BACKEND_ROOT_DIRECTORY}/results`;
my $newestDirectory = $list[0];
chomp($newestDirectory);

print "$ENV{BACKEND_ROOT_DIRECTORY}/jobs/showOnlySurebets.sh $ENV{BACKEND_ROOT_DIRECTORY}/results/$newestDirectory >$dataLocation" . "\n"; 
my $surebets = `$ENV{BACKEND_ROOT_DIRECTORY}/jobs/showOnlySurebets.sh $ENV{BACKEND_ROOT_DIRECTORY}/results/$newestDirectory >$dataLocation`;
print $surebets;



sub pushBreakLine()
{
	system(qq|echo '<BR>' >>$dataLocation |);
}
