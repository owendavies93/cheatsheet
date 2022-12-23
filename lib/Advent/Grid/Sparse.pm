package Advent::Grid::Sparse;

use Mojo::Base 'Advent::Grid';

sub new {
    my $class = shift;
    my $self = {
        grid => {},
    };
    bless $self, $class;
    return $self;
}

# return the total number of coordinates with values
sub count_set {
    my $self = shift;
    return scalar keys %{$self->{grid}};
}

# return value at an (x, y) coordinate
sub get {
    my ($self, $x, $y) = @_;
    return $self->{grid}->{$x, $y};
}

# incrememnt the value at (x, y)
sub inc {
    my ($self, $x, $y) = @_;
    $self->{grid}->{$x, $y}++;
}

# return values of neighbours given an x, y coordinate
sub neighbour_values {
    my ($self, $x, $y) = @_;
    return map { $self->get($_->[0], $_->[1]) } $self->neighbours($x, $y);
}

# return neighbour coordinates given an x, y coordinate
sub neighbours {
    my ($self, $x, $y) = @_;

    my @ns = ();
    for my $dy (-1..1) {
        for my $dx (-1..1) {
            next if $dx == 0 and $dy == 0;
            push @ns, [$x + $dx, $y + $dy];
        }
    }
    return @ns;
}

# sets the value of the given x, y coordinate
sub set {
    my ($self, $x, $y, $v) = @_;
    $self->{grid}->{$x, $y} = $v;
}

1;
