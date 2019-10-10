#!/usr/bin/perl
#
use strict;
use warnings;

sub pushBreakLine();


my $dataLocation = '/var/www/data/last_surebets';

my @list = `ls -t ../results`;
my $newestDirectory = $list[0];
chomp($newestDirectory);

system("echo execution start `date` >>$dataLocation");
pushBreakLine();
my $surebets = `perl showOnlySurebets.pl ../results/$newestDirectory >$dataLocation`;
print $surebets;
pushBreakLine();
system("echo execution end `date`  >>$dataLocation ");
pushBreakLine();



sub pushBreakLine()
{
	system(qq|echo '<BR>' >>$dataLocation |);
}
