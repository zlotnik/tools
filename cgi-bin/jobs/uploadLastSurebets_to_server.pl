#!/usr/bin/perl
#
use strict;
use warnings;

sub pushBreakLine();


my $dataLocation = '/var/www/data/last_surebets';

my @list = `ls -t ../results`;
my $newestDirectory = $list[0];
chomp($newestDirectory);

my $surebets = `./showOnlySurebets.sh ../results/$newestDirectory >$dataLocation`;
print $surebets;



sub pushBreakLine()
{
	system(qq|echo '<BR>' >>$dataLocation |);
}
