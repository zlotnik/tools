#!/usr/bin/perl -w

#Na podstawie listy bookmacherow w pliku configuracyjnym podanym jako argument ma sprawdzać czy podany bookmacher jest na liscie ignorowanych ignorowany

sub loadIgnoreList($);


my @listOfIgnored = loadIgnoreList('ignore_list.txt');
print $listOfIgnored[0];
print $listOfIgnored[1];




sub loadIgnoreList($)
{
	my $pathToConfigFile = $_[0];
	my @listOfIgnored;

	open IGNOREFILE, '<', $pathToConfigFile or die 'can not open file';


	while(<IGNOREFILE>)
	{
		my $line = $_;
		chomp($line);
		if($line !~ /^#/)
		{
			push @listOfIgnored, $line;
		}
	}
	
	
	close IGNOREFILE or die;
	return  @listOfIgnored;

}







