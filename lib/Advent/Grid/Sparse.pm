package Advent::Grid::Sparse;

use Mojo::Base 'Advent::Grid';

use Advent::Point::Point2;

sub new {
    my $class = shift;
    my $self = {
        grid => {},
    };
    bless $self, $class;
    return $self;
}

# return all set points in the grid (no values)
sub all {
    my $self = shift;
    return keys %{$self->{grid}};
}

# return the total number of coordinates with values
sub count_set {
    my $self = shift;
    return scalar keys %{$self->{grid}};
}

# remove a point from the grid
sub delete {
    my ($self, $p) = @_;
    delete $self->{grid}->{$p->key}; 
}

# return value at an (x, y) coordinate
sub get {
    my ($self, $p) = @_;
    return $self->{grid}->{$p->key};
}

# incrememnt the value at (x, y)
sub inc {
    my ($self, $p) = @_;
    $self->{grid}->{$p}++;
}

# return values of neighbours given an x, y coordinate
sub neighbour_values {
    my ($self, $p) = @_;
    return map { $self->get($_) } $self->neighbours($p);
}

# return neighbour coordinates given an x, y coordinate
sub neighbours {
    my ($self, $p) = @_;

    my @ns = ();
    for my $dy (-1..1) {
        for my $dx (-1..1) {
            next if $dx == 0 and $dy == 0;
            my $p2 = Advent::Point::Point2->new($dx, $dy);
            my $p3 = $p->add($p2);
            push @ns, $p3;
        }
    }
    return @ns;
}

# print the grid in the AOC style, using the bounding box of the point set
# poor memory usage, creates points twice
sub print {
    my $self = shift;
    my $minx = my $miny = ~0;
    my $maxx = my $maxy = 0;
     
    for my $i ($self->all()) {
        my ($x, $y) = split $;, $i;
        my $p = Advent::Point::Point2->new($x, $y);
        $minx = $p->x if $p->x < $minx;
        $maxx = $p->x if $p->x > $maxx;
        $miny = $p->y if $p->y < $miny;
        $maxy = $p->y if $p->y > $maxy;
    }

    print "\n";
    for my $y ($miny..$maxy) {
        for my $x ($minx..$maxx) {
            my $p = Advent::Point::Point2->new($x, $y);
            my $v = $self->get($p);
            print ($v // '.');
        }
        print "\n";
    }
    print "\n";
}

# sets the value of the given x, y coordinate
sub set {
    my ($self, $p, $v) = @_;
    $self->{grid}->{$p->key} = $v;
}

1;
