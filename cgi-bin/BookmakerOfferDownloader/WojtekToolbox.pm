package WojtekToolbox;
use strict;
use warnings;

use LWP::Simple;
use base 'Exporter';


our @EXPORT = qw(tryToGetUrl isConnectedToInternet is_it_Linux is_it_Windows);

sub tryToGetUrl($$);
sub isConnectedToInternet();
sub is_it_Linux();
sub is_it_Windows();

sub tryToGetUrl($$)
{
	my ($url, $maxNumberOfTries) = @_;

	my $triesCount =1;
	while($triesCount <= $maxNumberOfTries)
	{
		my $toReturn = get($url);
	    if (defined $toReturn)
		{
			return $toReturn;
		}
		else
		{
			print "unable to get url $url try ${triesCount}/${maxNumberOfTries}\n";
		}
		$triesCount++;
	}
}

sub isConnectedToInternet()
{
	
	my $ping_answer  = `ping 8.8.8.8 -n 1`;
	
	return ($ping_answer =~ /.*Reply from.*/);
	
}

sub is_it_Linux()
{
	if($^O eq 'linux')
	{	
		return  1;
	}
	return 0;
}

sub is_it_Windows()
{
	if($^O eq 'MSWin32')
	{
		return 1; 
	}
	return 0;
}


1;
