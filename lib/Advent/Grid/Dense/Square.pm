package Advent::Grid::Dense::Square;

use Mojo::Base 'Advent::Grid::Dense';

# return in bounds neighbors from an index, excluding diagonals
sub neighbours_from_index {
    my ($self, $i) = @_;

    my @adjacent;
    if ($i % $self->{width} == 0) {
        @adjacent = ($i + 1, $i + $self->{width}, $i - $self->{width});
    } elsif ($i % $self->{width} == ($self->{width} - 1)) {
        @adjacent = ($i - 1, $i + $self->{width}, $i - $self->{width});
    } else {
        @adjacent = ($i + 1, $i - 1, $i + $self->{width}, $i - $self->{width});
    }   
    return grep { $self->check_bounds_of_index($_) } @adjacent;
}

1;
