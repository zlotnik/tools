package MarathonParser;
use parent qw(BookmakerParser);

sub new
{
	my $class = shift;
	my $self = {};
	return bless $self, $class

}


sub downloadOffer(@)
{

	my $class = shift;
	print "Marathon";
}


1;
