package SportEvent;
use strict;
use warnings;

sub new();
sub insertIntoSelectorFile($);

sub new()
{

        my $class = shift;
        my $self = bless {}, $class;
        return $self;
}

sub insertIntoSelectorFile($)
{
        my $self = shift;
        my ( $selectorFile ) = @_;

}

1;
