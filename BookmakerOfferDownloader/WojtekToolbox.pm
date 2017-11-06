package WojtekToolbox;
use LWP::Simple;
use base 'Exporter';


our @EXPORT = qw(tryToGetUrl, isConnectedToInternet);

sub tryToGetUrl($$);
sub isConnectedToInternet();


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

1;