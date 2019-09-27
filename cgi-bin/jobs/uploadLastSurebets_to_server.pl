#!/usr/bin/perl
#
use strict;
use warnings;

sub pushBreakLine();


my $webPageLocation = '/var/www/html/index.php';

my @list = `ls -t ../results`;
my $newestDirectory = $list[0];
chomp($newestDirectory);

system("echo execution start `date` >>/var/www/html/index.php");
pushBreakLine();
my $surebets = `perl showOnlySurebets.pl ../results/$newestDirectory >>/var/www/html/index.php`;
print $surebets;
pushBreakLine();
system("echo execution end `date`  >>/var/www/html/index.php ");
pushBreakLine();
#((system ("echo $surebets >>/var/www/html/index.php")) == 0 ) or die;



sub pushBreakLine()
{
	system(qq|echo '<BR>' >>$webPageLocation |);
}
