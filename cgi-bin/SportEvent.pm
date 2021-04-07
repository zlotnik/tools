package SportEvent;
use strict;
use warnings;

sub new();

sub new()
{

        my $class = shift;
        my $self = bless {}, $class;
        return $self;
}
