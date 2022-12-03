package Advent::Grid::Dense::Diagonal;

use Mojo::Base 'Advent::Grid::Dense';

# return in bounds neighbors from an index, including diagonals
sub neighbours_from_index {
    my ($self, $i) = @_;

    my @adjacent = ($i + $self->{width}, $i - $self->{width});
    if ($i % $self->{width} == 0) {
        push @adjacent, (
            $i + 1, $i - $self->{width} + 1, $i + $self->{width} + 1
        );
    } elsif ($i % $self->{width} == ($self->{width} - 1)) {
        push @adjacent, (
            $i - 1, $i - $self->{width} - 1, $i + $self->{width} - 1
        ); 
    } else {
        push @adjacent, (
            $i + 1, $i - 1, $i - $self->{width} + 1, $i + $self->{width} + 1,
            $i - $self->{width} - 1, $i + $self->{width} - 1 
        );
    }   
    return grep { $self->check_bounds_of_index($_) } @adjacent;
 
}

1;
