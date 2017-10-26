package WojtekToolbox;
use LWP::Simple;
use base 'Exporter';


our @EXPORT = ('tryToGetUrl');

sub tryToGetUrl($$);



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

1;