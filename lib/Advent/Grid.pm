package Advent::Grid;

use Mojo::Base -strict;

use Carp;

sub new {
    croak "Don't instantiate this";
}

# get a hashref of all edges, in a to => from format
sub edge_list {
    croak "Not implemented!";
}

# return in bounds neighbours given an x, y coordinate
sub neighbours {
    croak "Not implemented!";
}

1;
