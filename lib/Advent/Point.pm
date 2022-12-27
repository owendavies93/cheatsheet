package Advent::Point;

use Mojo::Base -strict;

use Carp;

sub add {
    croak "Not implemented";
}

sub dist {
    croak "Not implemented";
}

sub key {
    croak "Not implemented"; 
}

sub print {
    croak "Not implemented";
}

sub x {
    my $self = shift;
    return $self->{x};
}

sub y {
    my $self = shift;
    return $self->{y};
}

1;
