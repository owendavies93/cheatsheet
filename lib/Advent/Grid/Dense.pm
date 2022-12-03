package Advent::Grid::Dense;

use Mojo::Base 'Advent::Grid';

use Carp;

# grid should be a 1d arrayref
sub new {
    my ($class, $opts) = @_;
    my $self = {
        grid  => $opts->{grid},
        width => $opts->{width},
    };
    bless $self, $class;
    return $self;
}
    
# check whether a given index is within the grid
sub check_bounds_of_index {
    my ($self, $index) = @_;
    return ($index >= 0 && $index < scalar @{$self->{grid}});
}

# get a hashref of all edges, in a to => from format
sub edge_list {
    my $self = shift;
    my $edges = {};
    for (my $i = 0; $i < scalar @{$self->{grid}}; $i++) {
        for my $n ($self->neighbours_from_index($i)) {
            $edges->{$i}->{$n} = $self->{grid}->[$n];
        }   
    }
    return $edges;
}

# get a value in the grid at an index
sub get_at_index {
    my ($self, $index) = @_;
    return $self->{grid}->[$index];
}

# increment the value in the grid at an index
sub inc_at_index {
    my ($self, $index) = @_;
    $self->set_at_index($index, $self->get_at_index($index) + 1)
}

# return in bounds neighbours given an x, y coordinate
sub neighbours {
    my ($self, $x, $y) = @_;
    return $self->neighbour_from_index($y * $self->{width} + $x);
}

# return in bounds neighbors from an index
sub neighbours_from_index {
    croak "Not implemented!";
}

# set the value in the grid at an index
sub set_at_index {
    my ($self, $index, $value) = @_;
    $self->{grid}->[$index] = $value;
}

1;
